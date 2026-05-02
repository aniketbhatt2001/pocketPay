-- ─────────────────────────────────────────────────────────────────────────────
-- Migration: 20260502000001_add_increment_wallet_balance_fn
--
-- Creates a SECURITY DEFINER RPC that atomically increments a user's wallet
-- balance. Called by the Flutter app after a successful Razorpay payment.
--
-- Why SECURITY DEFINER?
--   The wallets_update_own RLS policy allows direct client updates, but using
--   a server-side function ensures the increment is atomic (no race conditions)
--   and the amount is validated before touching the balance.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.increment_wallet_balance(
  p_user_id UUID,
  p_amount   NUMERIC
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  -- Guard: amount must be positive.
  IF p_amount <= 0 THEN
    RAISE EXCEPTION 'Amount must be greater than zero.';
  END IF;

  -- Guard: caller must be the owner of the wallet.
  IF auth.uid() IS DISTINCT FROM p_user_id THEN
    RAISE EXCEPTION 'Unauthorized.';
  END IF;

  UPDATE public.wallets
  SET balance = balance + p_amount
  WHERE user_id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Wallet not found for user %.', p_user_id;
  END IF;
END;
$$;
-- Only the authenticated role (logged-in users) may call this function.
REVOKE EXECUTE ON FUNCTION public.increment_wallet_balance(UUID, NUMERIC) FROM PUBLIC, anon;
GRANT  EXECUTE ON FUNCTION public.increment_wallet_balance(UUID, NUMERIC) TO authenticated;
