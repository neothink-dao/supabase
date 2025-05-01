-- Trigger: cleanup_old_security_events_trigger
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER cleanup_old_security_events_trigger
BEFORE INSERT ON public.security_events
FOR EACH ROW
EXECUTE FUNCTION public.cleanup_old_security_events();
