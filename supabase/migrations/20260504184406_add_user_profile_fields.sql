-- Migration: Add profile fields to public.users
-- Adds: first_name, last_name, email, is_profile_complete
-- Note: is_mpin_set already exists in the current schema

ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS first_name TEXT,
  ADD COLUMN IF NOT EXISTS last_name TEXT,
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS is_profile_complete BOOLEAN NOT NULL DEFAULT FALSE;

-- Optional: backfill first_name / last_name from full_name where possible
-- (splits on the first space; safe to remove if not needed)
UPDATE public.users
SET
  first_name = SPLIT_PART(full_name, ' ', 1),
  last_name   = NULLIF(SUBSTRING(full_name FROM POSITION(' ' IN full_name) + 1), '')
WHERE full_name IS NOT NULL
  AND first_name IS NULL;