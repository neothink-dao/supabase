-- Trigger: ensure_token_balance_trigger
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER ensure_token_balance_trigger
BEFORE INSERT ON public.token_balances
FOR EACH ROW
EXECUTE FUNCTION public.ensure_token_balance();
