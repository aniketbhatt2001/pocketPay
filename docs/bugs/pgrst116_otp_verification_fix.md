# Bug Fix: PGRST116 — "Cannot coerce the result to a single JSON object"

## Summary

A `PostgrestException` with code `PGRST116` was thrown whenever a user tapped **Verify OTP**, preventing successful login.

```
PostgrestException(
  message: Cannot coerce the result to a single JSON object,
  code: PGRST116,
  details: The result contains 0 rows,
  hint: null
)
```

---

## Where It Happened

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`  
**Method:** `verifyOtp()`

After successfully verifying the OTP with Supabase Auth, the code immediately queried the `public.users` table using `.single()`:

```dart
final profile = await _db
    .from('users')
    .select('id, phone_number, full_name, biometric_enabled, created_at')
    .eq('id', user.id)
    .single(); // ← crashed here when 0 rows returned
```

`.single()` throws `PGRST116` if the query returns anything other than exactly 1 row.

---

## Root Cause

The app relied on a **database trigger** to create the `public.users` row automatically whenever a new user was created in `auth.users`:

```sql
-- supabase/migrations/20260430080109_create_user_on_signup_trigger.sql

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
```

**The problem:** This trigger only fires on `INSERT` into `auth.users`.

With Supabase phone OTP, the `auth.users` row is created the very first time a phone number is verified. On **every subsequent login**, Supabase reuses the existing `auth.users` row — no new `INSERT` happens, so the trigger never fires again.

If for any reason the `public.users` row was missing (e.g. trigger failed silently, row was deleted, database was reset, or the user was created before the trigger existed), the `.single()` query would find **0 rows** and throw `PGRST116`.

### Affected Scenarios

| Scenario | Trigger fires? | `public.users` row exists? | Result |
|---|---|---|---|
| Brand new user, first login | ✅ Yes | ✅ Yes | Works |
| Returning user, re-login | ❌ No | ✅ Yes (from first login) | Works |
| User whose row was missing for any reason | ❌ No | ❌ No | **CRASHES** |
| DB reset / migration re-run without re-triggering | ❌ No | ❌ No | **CRASHES** |

---

## Fix

Added an **upsert** step before the `.single()` fetch in `verifyOtp()`. This guarantees the `public.users` row always exists at the point of querying, regardless of whether the trigger ran.

```dart
// 2. Ensure the public profile row exists (the trigger may not fire for
//    returning users whose auth.users row already existed).
await _db.from('users').upsert(
  {
    'id': user.id,
    'phone_number': user.phone ?? verificationId,
  },
  onConflict: 'id',
  ignoreDuplicates: true, // don't overwrite full_name / mpin_hash etc.
);

// 3. Fetch the public profile
final profile = await _db
    .from('users')
    .select('id, phone_number, full_name, biometric_enabled, created_at')
    .eq('id', user.id)
    .single();
```

### Why `ignoreDuplicates: true`?

- For **new users** — inserts the row fresh.
- For **returning users** — the `ON CONFLICT DO NOTHING` path is taken, so existing data like `full_name`, `mpin_hash`, and `biometric_enabled` are **not overwritten**.

### RLS Compatibility

The existing Row Level Security policy already permits this:

```sql
CREATE POLICY "users_insert_own" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

Since the user is authenticated at this point (OTP was just verified), `auth.uid()` matches `user.id` and the upsert is allowed.

---

## Files Changed

| File | Change |
|---|---|
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Added upsert before `.single()` fetch in `verifyOtp()` |

---

## Prevention

- Never use `.single()` on a query that could return 0 rows without first guaranteeing the row exists.
- Avoid relying solely on database triggers for critical data bootstrapping — triggers can fail silently or not fire in all expected scenarios.
- Consider using `.maybeSingle()` as a defensive alternative when a missing row is a recoverable state.
