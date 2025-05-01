-- Trigger: trg_posts_award_tokens
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER trg_posts_award_tokens
BEFORE INSERT OR UPDATE OF token_tag ON public.posts
FOR EACH ROW
WHEN ((new.token_tag IS NOT NULL) AND (NOT new.reward_processed))
EXECUTE FUNCTION public.award_post_tokens();
