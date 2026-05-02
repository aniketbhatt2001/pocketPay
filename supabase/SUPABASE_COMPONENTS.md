# Supabase Components Reference

A breakdown of every database function, trigger, and edge function in this project — what each one does, how they connect, and what breaks if one is missing.

---

## Overview: How They Fit Together

```
User signs up (phone OTP)
        │
        ▼
  auth.users row created  ──► [Trigger] on_auth_user_created
                                        │
                                        ▼
                              [Function] handle_new_user()
                              Inserts row into public.users
                                        │
                                        ▼
                              [Trigger] on_user_created_create_wallet
                                        │
                                        ▼
                              [Function] handle_new_wallet()
                              Inserts row into public.wallets
                                        │
                                        ▼
                              User sets MPIN
                                        │
                              [Edge Function] set-mpin
                              Hashes MPIN, stores in public.users
                                        │
                              [Edge Function] verify-mpin
                              Compares hash on login
```

RLS policies and helper functions (`rls_auto_enable`, `update_updated_at`) run passively in the background to enforce security and keep timestamps accurate.

---

## Database Functions

### 1. `handle_new_user()`

| Property | Detail |
|---|---|
| Type | Trigger function |
| Language | PL/pgSQL |
| Security | `SECURITY DEFINER` |
| Fires on | `AFTER INSERT` on `auth.users` |

**What it does:** When Supabase Auth creates a new user (after OTP verification), this function automatically inserts a matching row into `public.users`, copying the user's `id` and `phone` number. The `ON CONFLICT DO NOTHING` guard makes it safe to re-run.

**What breaks without it:** New users exist in `auth.users` but have no row in `public.users`. Every query that joins or reads from `public.users` returns nothing for that user. RLS policies that check `auth.uid() = id` will also fail to match, effectively locking the user out of their own data. The wallet creation chain also never starts.

**Needed?** Yes — critical.

---

### 2. `handle_new_wallet()`

| Property | Detail |
|---|---|
| Type | Trigger function |
| Language | PL/pgSQL |
| Security | `SECURITY DEFINER` |
| Fires on | `AFTER INSERT` on `public.users` |

**What it does:** Immediately after a row lands in `public.users`, this function inserts a corresponding row into `public.wallets` for that user. The `ON CONFLICT (user_id) DO NOTHING` guard prevents duplicates if the trigger fires more than once.

**What breaks without it:** New users have no wallet. Any screen that reads wallet balance or transaction history will either crash or show an empty/error state. The wallet would need to be created manually or via a separate API call, adding complexity and a potential race condition.

**Needed?** Yes — critical.

---

### 3. `rls_auto_enable`

| Property | Detail |
|---|---|
| Type | Utility / helper function |
| Purpose | Automatically enables Row Level Security on tables |

**What it does:** Ensures RLS is enabled on tables so that the policies defined (e.g., `users_select_own`, `users_update_own`) are actually enforced. Without RLS being enabled, policies exist but are ignored — any authenticated user could read or write any row.

**What breaks without it:** If RLS is not enabled on a table, all the security policies become decorative. Any authenticated user can read every user's data, wallet balances, and MPIN hashes. This is a serious security vulnerability.

**Needed?** Yes — security-critical.

---

### 4. `set_mpin`

| Property | Detail |
|---|---|
| Type | Database function (called by edge function) |
| Purpose | Stores a hashed MPIN in `public.users` |

**What it does:** Receives a hashed MPIN value and writes it to the `mpin_hash` column of the calling user's row in `public.users`. The actual hashing happens in the edge function before this is called, so the raw PIN never touches the database layer.

**What breaks without it:** The edge function `set-mpin` has nowhere to persist the hash, or must use a direct `UPDATE` statement instead — losing the encapsulation and any additional validation logic inside the function.

**Needed?** Yes, if the edge function delegates to it. If the edge function does a direct `UPDATE`, this specific function is optional — but having it is better practice.

---

### 5. `update_updated_at`

| Property | Detail |
|---|---|
| Type | Trigger function |
| Language | PL/pgSQL |
| Fires on | `BEFORE UPDATE` on tables with an `updated_at` column |

**What it does:** Sets `updated_at = NOW()` automatically on any row update. This is a standard housekeeping function used by the `wallets_updated_at` trigger (and potentially others).

**What breaks without it:** The `updated_at` column on `wallets` (and any other table using it) never updates — it stays at the creation timestamp forever. This breaks any logic that relies on "last modified" time, such as cache invalidation, sync logic, or audit displays.

**Needed?** Yes, if `updated_at` tracking matters. Low risk to remove if you don't use that field, but it's cheap to keep.

---

## Triggers

### 1. `on_auth_user_created` (on `auth.users`)

**Calls:** `handle_new_user()`  
**Fires:** After every new row inserted into `auth.users`

This is the entry point of the entire user provisioning chain. Supabase Auth manages `auth.users` internally — you cannot insert into it directly. This trigger is the only reliable hook to react to a new signup.

**What breaks without it:** `handle_new_user()` exists but never runs. No `public.users` row is created, no wallet is created, and the user is effectively a ghost in the system.

---

### 2. `on_user_created_create_wallet` (on `public.users`)

**Calls:** `handle_new_wallet()`  
**Fires:** After every new row inserted into `public.users`

This is the second step in the chain. It listens on `public.users` (not `auth.users`) so it fires only after the user profile row is confirmed to exist.

**What breaks without it:** `handle_new_wallet()` exists but never runs. Users are created without wallets. Every wallet-related feature fails for new users.

---

### 3. `wallets_updated_at` (on `public.wallets`)

**Calls:** `update_updated_at()`  
**Fires:** Before every update on `public.wallets`

Keeps the `updated_at` timestamp on wallet rows current.

**What breaks without it:** `updated_at` on wallets is always stale. Low functional impact unless your app uses that field for display or sync logic.

---

## Edge Functions

Edge functions run in Deno on Supabase's servers. They execute outside the database, can use secrets (like a pepper/salt for hashing), and are called directly from the Flutter app via HTTPS.

### 1. `set-mpin`

**Called from:** Flutter app after the user enters their MPIN for the first time  
**What it does:**
1. Receives the raw MPIN from the client
2. Hashes it securely (e.g., using bcrypt or a similar algorithm with a server-side secret)
3. Stores the hash in `public.users.mpin_hash` for the authenticated user

**Why an edge function and not a direct DB call?** The raw MPIN must never be sent to the database in plaintext. The edge function is the secure boundary where hashing happens using server-side secrets that the client never sees.

**What breaks without it:** No way to set an MPIN securely. You'd either have to hash on the client (insecure — client controls the hash) or store the PIN in plaintext (a serious security issue).

**Needed?** Yes — security-critical.

---

### 2. `verify-mpin`

**Called from:** Flutter app on every MPIN login attempt  
**What it does:**
1. Receives the raw MPIN from the client
2. Fetches the stored `mpin_hash` for the authenticated user
3. Compares the input against the hash
4. Returns success or failure

**Why an edge function?** Same reason as `set-mpin` — the comparison must happen server-side using the same secret used during hashing. A client-side comparison would expose the hash and allow offline brute-force attacks.

**What breaks without it:** MPIN login is impossible. Users who have set an MPIN cannot authenticate. If you tried to move this logic to the client, it would be a significant security regression.

**Needed?** Yes — security-critical.

---

## Difference: Database Functions vs Edge Functions

| | Database Functions / Triggers | Edge Functions |
|---|---|---|
| **Where they run** | Inside PostgreSQL | Deno runtime on Supabase servers |
| **Triggered by** | Database events (INSERT, UPDATE) | HTTP requests from the app |
| **Access to secrets** | No (env vars not available) | Yes (Supabase Vault / env vars) |
| **Can hash passwords?** | Possible with `pgcrypto`, but no server secret | Yes, with full crypto libraries |
| **Called by Flutter?** | No (indirectly via DB operations) | Yes, directly via HTTPS |
| **Use case here** | Auto-provisioning users & wallets, timestamps, RLS | Secure MPIN set/verify |

The key distinction: **triggers and DB functions react to data changes automatically**, while **edge functions are called explicitly by the app** and are the right place for logic that needs secrets or external calls.

---

## What Happens If Each Component Is Missing

| Component | Missing Impact | Severity |
|---|---|---|
| `handle_new_user` | No `public.users` row on signup; user locked out | 🔴 Critical |
| `on_auth_user_created` | `handle_new_user` never fires; same as above | 🔴 Critical |
| `handle_new_wallet` | No wallet created on signup; wallet features broken | 🔴 Critical |
| `on_user_created_create_wallet` | `handle_new_wallet` never fires; same as above | 🔴 Critical |
| `rls_auto_enable` | RLS not enforced; all user data exposed to any authenticated user | 🔴 Security Critical |
| `set-mpin` (edge fn) | Cannot set MPIN securely; MPIN feature broken | 🔴 Critical |
| `verify-mpin` (edge fn) | Cannot verify MPIN; login broken for MPIN users | 🔴 Critical |
| `set_mpin` (DB fn) | Edge function must use direct UPDATE instead; minor refactor needed | 🟡 Low |
| `update_updated_at` | `updated_at` on wallets never refreshes | 🟡 Low |
| `wallets_updated_at` | `update_updated_at` never fires for wallets | 🟡 Low |

---

## Summary

All components are needed. The two "Low" severity items (`update_updated_at` and `wallets_updated_at`) are safe to remove only if nothing in the app reads `wallets.updated_at`. Everything else is load-bearing — removing any one of them breaks either core functionality or security.
