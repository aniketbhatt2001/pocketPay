-- Hashes the raw MPIN with bcrypt (via pgcrypto) and writes it to the user row.
-- Called exclusively by the set-mpin edge function using the service-role key,
-- so we accept the target user id as a parameter instead of relying on auth.uid().
CREATE OR REPLACE FUNCTION public.hash_and_set_mpin(p_user_id UUID, p_raw_mpin TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  UPDATE public.users
  SET
    mpin_hash   = extensions.crypt(p_raw_mpin, extensions.gen_salt('bf')),
    is_mpin_set = TRUE
  WHERE id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'User profile not found for id %', p_user_id;
  END IF;
END;
$$;

-- Only the service role (used by the edge function) should call this.
REVOKE EXECUTE ON FUNCTION public.hash_and_set_mpin(UUID, TEXT) FROM PUBLIC, anon, authenticated;
GRANT  EXECUTE ON FUNCTION public.hash_and_set_mpin(UUID, TEXT) TO service_role;
