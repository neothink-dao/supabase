-- Trigger: set_updated_at_timestamp on tokens
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER set_tokens_timestamp
BEFORE UPDATE ON public.tokens
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();
