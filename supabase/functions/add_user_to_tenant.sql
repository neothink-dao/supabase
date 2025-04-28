-- Function: public.add_user_to_tenant
-- Extracted from baseline migration

CREATE OR REPLACE FUNCTION public.add_user_to_tenant(
    _user_id uuid,
    _tenant_slug text,
    _role text DEFAULT 'member'
) RETURNS boolean
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
-- function body here
$$;
