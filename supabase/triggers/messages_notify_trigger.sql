-- Trigger: messages_notify_trigger
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER messages_notify_trigger
AFTER INSERT OR UPDATE ON public.messages
FOR EACH ROW
EXECUTE FUNCTION public.handle_message_changes();
