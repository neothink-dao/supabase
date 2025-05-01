-- Trigger: posts_notify_trigger
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER posts_notify_trigger
AFTER INSERT OR DELETE OR UPDATE ON public.posts
FOR EACH ROW
EXECUTE FUNCTION public.handle_post_changes();
