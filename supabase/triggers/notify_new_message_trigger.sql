-- Trigger: notify_new_message_trigger
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER notify_new_message_trigger
AFTER INSERT ON public.chat_messages
FOR EACH ROW
EXECUTE FUNCTION public.notify_new_message();
