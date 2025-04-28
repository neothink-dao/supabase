-- Function: public.advance_user_week
-- Extracted from baseline migration

CREATE OR REPLACE FUNCTION public.advance_user_week(
    p_user_id uuid,
    p_platform text
) RETURNS boolean
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
-- function body here
$$;
