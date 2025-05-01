-- Trigger: set_updated_at_timestamp on profiles
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER set_updated_at_timestamp
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();
