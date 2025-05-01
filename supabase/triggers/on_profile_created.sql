-- Trigger: on_profile_created
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER on_profile_created
AFTER INSERT ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();
