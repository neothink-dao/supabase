-- Trigger: on_profile_platform_change
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER on_profile_platform_change
AFTER UPDATE OF platforms ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.handle_profile_platform_changes();
