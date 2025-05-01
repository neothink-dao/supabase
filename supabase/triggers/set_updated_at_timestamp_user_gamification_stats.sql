-- Trigger: set_user_gamification_stats_timestamp
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER set_user_gamification_stats_timestamp
BEFORE UPDATE ON public.user_gamification_stats
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();
