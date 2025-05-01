-- Trigger: set_updated_at_timestamp on content_modules
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER set_updated_at_timestamp
BEFORE UPDATE ON public.content_modules
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();
