-- 1. Add the column (safe to run on existing tables — defaults to FALSE for
--    all existing rows, including users who have already set an MPIN).
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS is_mpin_set BOOLEAN NOT NULL DEFAULT FALSE;

-- 2. Back-fill: any user who already has a mpin_hash should be marked as set.
UPDATE public.users
  SET is_mpin_set = TRUE
  WHERE mpin_hash IS NOT NULL
    AND is_mpin_set = FALSE;

-- 3. Replace the set_mpin DB function so it keeps both columns in sync.
--    Called by the `set-mpin` edge function after hashing the raw PIN.
CREATE OR REPLACE FUNCTION public.set_mpin(p_mpin_hash TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  UPDATE public.users
  SET
    mpin_hash    = p_mpin_hash,
    is_mpin_set  = TRUE
  WHERE id = auth.uid();

  IF NOT FOUND THEN
    RAISE EXCEPTION 'User profile not found.';
  END IF;
END;
$$;

-- Only authenticated users may call this function.
REVOKE EXECUTE ON FUNCTION public.set_mpin(TEXT) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.set_mpin(TEXT) TO authenticated;;
