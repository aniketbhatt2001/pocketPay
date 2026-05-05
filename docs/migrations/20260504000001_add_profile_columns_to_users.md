# Migration: Add Profile Columns to Users Table

**Date:** 2026-05-04  
**Purpose:** Add `first_name`, `last_name`, and `email` columns to the `users` table to support the profile setup screen.

## SQL

Run this in the Supabase SQL editor (or as a migration file):

```sql
-- Add first_name column
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS first_name TEXT;

-- Add last_name column
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS last_name TEXT;

-- Add email column
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS email TEXT;

-- Backfill full_name from first_name + last_name for any future updates
-- (full_name is already kept in sync by the app on profile save)
```

## Notes

- All three columns are **nullable** — existing rows are unaffected.
- The app writes `full_name` as `'$firstName $lastName'` on every profile save, keeping it consistent with the existing `full_name` column used elsewhere.
- RLS policies on the `users` table already restrict writes to the row owner (`auth.uid() = id`), so no additional policy changes are needed.
- The `email` column stores the user-provided email; it is separate from Supabase Auth's built-in email field.
