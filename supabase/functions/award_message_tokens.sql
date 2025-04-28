-- Function: public.award_message_tokens
-- Extracted from baseline migration

CREATE OR REPLACE FUNCTION public.award_message_tokens()
RETURNS trigger
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
-- function body here
$$;
