# Supabase Auto User Creation — Issue, Fix & How It Works

## The Goal

When a user successfully verifies their phone OTP, a corresponding row should be
automatically created in `public.users` — without any client-side code doing the
insert. The Flutter app should never be responsible for creating the profile row.

---

## What Was Built

### 1. `public.users` Table

A profile table that mirrors every authenticated user from Supabase Auth:

```sql
CREATE TABLE public.users (
  id                UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  phone_number      TEXT NOT NULL UNIQUE,
  full_name         TEXT,
  mpin_hash         TEXT,
  biometric_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

- `id` is a foreign key to `auth.users(id)` — the two tables are always in sync
- RLS is enabled: users can only read/write their own row

### 2. PostgreSQL Trigger Function

A `SECURITY DEFINER` function that runs inside the database:

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.users (id, phone_number)
  VALUES (
    NEW.id,
    COALESCE(NEW.phone, '')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;
```

### 3. The Trigger

```sql
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
```

This fires automatically every time Supabase Auth inserts a new row into
`auth.users` — which happens the first time a user verifies their OTP.

---

## The Problem — Why It Wasn't Working

### Timeline

| Date | Event |
|------|-------|
| April 29 | Test user signed up and verified OTP → row created in `auth.users` |
| April 30 | Trigger `on_auth_user_created` was created |

The trigger was created **after** the test user already existed. PostgreSQL triggers
only fire on **future** inserts — they do not retroactively process rows that were
inserted before the trigger existed.

So the state was:

```
auth.users       → 1 row  ✅  (user from April 29)
public.users     → 0 rows ❌  (trigger didn't exist yet when user signed up)
```

The trigger was correctly written and attached — it just had no chance to run for
the existing user.

### How It Was Diagnosed

Three queries were run to confirm the state:

```sql
-- 1. Is the trigger actually there?
SELECT trigger_name, event_object_schema, event_object_table
FROM information_schema.triggers
WHERE event_object_table = 'users';
-- Result: on_auth_user_created on auth.users ✅

-- 2. Does the function exist?
SELECT routine_name, security_type
FROM information_schema.routines
WHERE routine_name = 'handle_new_user';
-- Result: handle_new_user, DEFINER ✅

-- 3. What's in each table?
SELECT id, phone FROM auth.users;        -- 1 row (April 29)
SELECT id FROM public.users;             -- 0 rows ← the bug
```

The mismatch between `auth.users` (1 row) and `public.users` (0 rows) confirmed
the trigger timing issue.

---

## The Fix — Backfill

A one-time backfill query was run to insert any `auth.users` rows that had no
corresponding `public.users` row:

```sql
INSERT INTO public.users (id, phone_number)
SELECT id, COALESCE(phone, '')
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.users)
ON CONFLICT (id) DO NOTHING;
```

After this ran:

```
auth.users       → 1 row  ✅
public.users     → 1 row  ✅  (backfilled)
```

---

## How It Works End-to-End (After the Fix)

```
User enters phone number
        │
        ▼
Supabase Auth sends OTP SMS
        │
        ▼
User enters OTP code
        │
        ▼
Supabase Auth verifies OTP
        │
        ▼
INSERT into auth.users  ◄─── happens on first-time signup
        │
        ▼  (trigger fires automatically)
handle_new_user() runs
        │
        ▼
INSERT into public.users (id, phone_number)
        │
        ▼
Flutter app fetches profile from public.users
        │
        ▼
AuthUser entity populated with full profile data
```

For **returning users**, the OTP verify does not re-insert into `auth.users`, so
the trigger does not fire again — the existing `public.users` row is untouched.

---

## Security Notes

### Why `SECURITY DEFINER`?

When the trigger fires, the executing role is `supabase_auth_admin` (the internal
Supabase Auth role). That role does not have write access to `public.users` by
default. `SECURITY DEFINER` makes the function run with the **owner's** privileges
(the `postgres` superuser role), which does have access.

### Why `REVOKE EXECUTE`?

```sql
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated;
```

Without this, the function would be callable directly via the Supabase REST API
(`/rest/v1/rpc/handle_new_user`). Since it's a `SECURITY DEFINER` function, any
anonymous user calling it could potentially abuse the elevated privileges. Revoking
execute ensures only the trigger can invoke it.

### Why `SET search_path = ''`?

Prevents search path injection attacks. Without it, a malicious user could create
a schema that shadows `public` and redirect the function's table writes. With an
empty search path, all table references must be fully qualified (e.g.
`public.users`), which is exactly what the function does.

### RLS Policies on `public.users`

```sql
-- Users can only read their own row
CREATE POLICY "users_select_own" ON public.users
  FOR SELECT USING (auth.uid() = id);

-- Users can only insert their own row
CREATE POLICY "users_insert_own" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Users can only update their own row
CREATE POLICY "users_update_own" ON public.users
  FOR UPDATE USING (auth.uid() = id);
```

The trigger bypasses RLS (because it runs as `SECURITY DEFINER`), but all direct
client queries are restricted to the authenticated user's own row.

---

## Migration Files

Both migrations are stored in `supabase/migrations/` and version-controlled:

| File | Description |
|------|-------------|
| `20260430075522_create_users_table.sql` | Creates `public.users` with RLS |
| `20260430080109_create_user_on_signup_trigger.sql` | Creates the trigger function and trigger |

---

## Key Takeaway

> **Triggers only fire on future events.** If you add a trigger to a table that
> already has data, existing rows are not affected. Always run a backfill query
> when retrofitting a trigger onto a table with pre-existing data.
