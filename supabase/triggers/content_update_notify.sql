-- Trigger: content_update_notify
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER content_update_notify
AFTER INSERT OR UPDATE ON public.content
FOR EACH ROW
EXECUTE FUNCTION public.notify_content_update();
