-- Trigger: set_updated_at_timestamp on feedback
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER set_updated_at
BEFORE UPDATE ON public.feedback
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();
