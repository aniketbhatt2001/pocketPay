-- ============================================================
-- Adds a trigger on public.users that auto-creates a wallet
-- row whenever a new user is inserted.
-- Safe to run against an existing wallets table.
-- ============================================================

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
-- Revoke direct invocation — only the trigger should call this.
REVOKE EXECUTE ON FUNCTION public.handle_new_wallet() FROM PUBLIC, anon, authenticated;
CREATE TRIGGER on_user_created_create_wallet
  AFTER INSERT ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_wallet();
