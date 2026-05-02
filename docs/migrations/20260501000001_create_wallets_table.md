# Migration: `20260501000001_create_wallets_table`

## High-Level Overview

This migration introduces the **wallet system** for PocketPay. Every user in the app has exactly one wallet that holds their balance. This migration does three things:

1. **Creates the `wallets` table** — stores each user's balance with a foreign key back to `public.users`.
2. **Secures it with Row Level Security (RLS)** — users can only ever read their own wallet; balance writes are restricted to the service role.
3. **Automates wallet provisioning** — a database trigger creates a wallet row automatically the moment a user row is inserted into `public.users`, so no application code needs to manually create wallets.

The end result: from the moment a user signs up, they have a wallet with a `0.00` balance, and the app can safely fetch it without worrying about missing rows.

---

## How It Fits Into the Existing Migration Chain

The three migrations build on each other in sequence:

```
auth.users  (Supabase managed)
     │
     │  AFTER INSERT → on_auth_user_created trigger
     ▼
public.users  (migration 20260430075522)
     │
     │  AFTER INSERT → on_user_created_create_wallet trigger  ← THIS MIGRATION
     ▼
public.wallets  (this migration)
```

- **Migration 1** (`20260430075522`) — creates `public.users`
- **Migration 2** (`20260430080109`) — creates a trigger that populates `public.users` when `auth.users` gets a new row
- **Migration 3** (`20260501000001`, this file) — creates `public.wallets` and a trigger that populates it when `public.users` gets a new row

So a full new-user signup flows through all three layers automatically, with no application code involved in wallet creation.

---

## Low-Level Breakdown

### 1. The `wallets` Table

```sql
CREATE TABLE public.wallets (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL UNIQUE REFERENCES public.users(id) ON DELETE CASCADE,
  balance     NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
  currency    TEXT NOT NULL DEFAULT 'USD',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

| Column | Type | Notes |
|---|---|---|
| `id` | `UUID` | Primary key, auto-generated. Keeps the wallet independently addressable (useful for future transaction foreign keys). |
| `user_id` | `UUID` | Foreign key to `public.users(id)`. `UNIQUE` enforces the one-wallet-per-user rule at the database level. |
| `balance` | `NUMERIC(15, 2)` | Stores up to 13 digits before the decimal and exactly 2 after. `NUMERIC` is used instead of `FLOAT` or `DOUBLE` to avoid floating-point rounding errors — critical for money. |
| `currency` | `TEXT` | Defaults to `'USD'`. Included now so multi-currency support can be added later without a schema change. |
| `created_at` | `TIMESTAMPTZ` | Timestamp with timezone, set once on insert. |
| `updated_at` | `TIMESTAMPTZ` | Timestamp with timezone, updated automatically on every row change via a trigger (see below). |

**`ON DELETE CASCADE`** on `user_id` means if a user is deleted from `public.users`, their wallet row is deleted automatically — no orphaned wallet rows.

**`NOT NULL DEFAULT 0.00`** on `balance` means a wallet can never be created without a balance value, and new wallets always start at zero.

---

### 2. Row Level Security (RLS)

```sql
ALTER TABLE public.wallets ENABLE ROW LEVEL SECURITY;
```

RLS is enabled immediately. Without explicit policies, **no client can read or write any row** — this is the secure default.

#### Select Policy

```sql
CREATE POLICY "wallets_select_own" ON public.wallets
  FOR SELECT USING (auth.uid() = user_id);
```

- `auth.uid()` is the ID of the currently authenticated Supabase user.
- This policy means a `SELECT` query on `wallets` will only ever return the row where `user_id` matches the caller's auth ID.
- Even if a client tries `SELECT * FROM wallets`, they will only see their own row — Postgres filters the rest out silently.

#### Update Policy

```sql
CREATE POLICY "wallets_update_own" ON public.wallets
  FOR UPDATE USING (auth.uid() = user_id);
```

- Allows the authenticated user to update their own wallet row.
- In practice, balance changes should go through a **Supabase Edge Function** using the service role key (which bypasses RLS entirely) to ensure proper validation and transaction logging. This policy is a fallback for direct client updates if needed.

> **Note:** There is intentionally no `INSERT` policy for clients. Wallet rows are only ever created by the `handle_new_wallet` trigger function, which runs as `SECURITY DEFINER` (elevated privileges). This prevents users from manually inserting wallet rows.

---

### 3. The `updated_at` Trigger

```sql
CREATE OR REPLACE FUNCTION public.update_wallet_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

CREATE TRIGGER wallets_updated_at
  BEFORE UPDATE ON public.wallets
  FOR EACH ROW EXECUTE FUNCTION public.update_wallet_updated_at();
```

- Fires **before** every `UPDATE` on any wallet row.
- Sets `updated_at` to the current timestamp automatically.
- `BEFORE UPDATE` (not `AFTER`) is used so the new timestamp is written as part of the same operation — no second write needed.
- This gives you a reliable audit trail of when a balance last changed, without any application-level code.

---

### 4. The Wallet Auto-Provisioning Trigger

This is the core of the migration.

#### The Function

```sql
CREATE OR REPLACE FUNCTION public.handle_new_wallet()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.wallets (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$;
```

- `NEW.id` refers to the `id` column of the newly inserted `public.users` row.
- Only `user_id` is provided — all other columns (`balance`, `currency`, `created_at`, `updated_at`) use their `DEFAULT` values.
- `ON CONFLICT (user_id) DO NOTHING` — if a wallet for this user already exists (e.g. the trigger fires twice due to the `upsert` in `verifyOtp`), the insert is silently skipped. No error, no duplicate.
- `SECURITY DEFINER` — the function executes with the privileges of the function owner (typically `postgres`/superuser), not the calling user. This is necessary because the calling context at signup time may not have direct `INSERT` permission on `wallets` (there is no client-facing insert RLS policy).
- `SET search_path = ''` — a security hardening measure. It prevents search path injection attacks by ensuring the function only resolves objects by their fully qualified names (e.g. `public.wallets`, not just `wallets`).

#### The Permission Revocation

```sql
REVOKE EXECUTE ON FUNCTION public.handle_new_wallet() FROM PUBLIC, anon, authenticated;
```

Even though the function is `SECURITY DEFINER`, this line ensures no client (anonymous or authenticated) can call it directly via `SELECT public.handle_new_wallet()`. Only the trigger mechanism can invoke it.

#### The Trigger

```sql
CREATE TRIGGER on_user_created_create_wallet
  AFTER INSERT ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_wallet();
```

- Fires **after** a row is inserted into `public.users`.
- `AFTER INSERT` (not `BEFORE`) is used because the `public.users` row must be fully committed before `wallets` can reference it via the foreign key.
- `FOR EACH ROW` means it runs once per inserted row (as opposed to once per statement).

---

## Full Execution Flow: New User Signup

```
1. User enters phone number → app calls Supabase Auth OTP
2. Supabase Auth creates a row in auth.users
        └─► TRIGGER: on_auth_user_created
                └─► INSERT INTO public.users (id, phone_number)
                        └─► TRIGGER: on_user_created_create_wallet
                                └─► INSERT INTO public.wallets (user_id)
                                        balance  = 0.00  (default)
                                        currency = 'USD' (default)
3. verifyOtp() in Flutter upserts public.users (ON CONFLICT DO NOTHING)
        └─► TRIGGER: on_user_created_create_wallet fires again
                └─► INSERT INTO public.wallets → ON CONFLICT DO NOTHING (skipped)
4. verifyOtp() fetches public.users profile → success
5. Dashboard fetches public.wallets → returns balance: 0.00
```

---

## Files in This Migration

| Object | Type | Purpose |
|---|---|---|
| `public.wallets` | Table | Stores user balances |
| `wallets_select_own` | RLS Policy | Users read only their own wallet |
| `wallets_update_own` | RLS Policy | Users update only their own wallet |
| `public.update_wallet_updated_at` | Function + Trigger | Keeps `updated_at` current on every balance change |
| `public.handle_new_wallet` | Function + Trigger | Auto-creates a wallet when a user row is inserted |

---

## How to Apply

**Via Supabase CLI:**
```bash
supabase db push
```

**Via Supabase Dashboard:**  
Go to SQL Editor → paste the contents of `supabase/migrations/20260501000001_create_wallets_table.sql` → Run.
