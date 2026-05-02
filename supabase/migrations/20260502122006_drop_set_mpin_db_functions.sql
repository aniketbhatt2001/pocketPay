-- Drop both overloads of the dead set_mpin DB function.
-- The edge function set-mpin handles all hashing and writes directly;
-- these DB functions are never called and the old one is a security risk
-- (raw PIN visible in query logs).
DROP FUNCTION IF EXISTS public.set_mpin(uuid, text);
DROP FUNCTION IF EXISTS public.set_mpin(text);;
