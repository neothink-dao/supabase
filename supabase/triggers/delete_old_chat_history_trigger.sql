-- Trigger: delete_old_chat_history_trigger
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER delete_old_chat_history_trigger
BEFORE INSERT ON public.chat_history
FOR EACH ROW
EXECUTE FUNCTION public.delete_old_chat_history();
