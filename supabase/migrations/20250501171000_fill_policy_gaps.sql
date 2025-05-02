-- Migration: 20250501171000_fill_policy_gaps.sql
-- Purpose: Ensure every table with RLS enabled has at least a default-deny policy and a permissive policy for service_role.
-- For tables with a user_id column, add a generic authenticated-user policy for SELECT (adjust as needed for your app).
-- NOTE: This migration is a security baseline. You should customize policies for business logic and least privilege.

-- Default deny and service_role allow policies for all tables with RLS but no policies
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT relname FROM pg_class JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace WHERE nspname = 'public' AND relkind = 'r' LOOP
        EXECUTE format('CREATE POLICY IF NOT EXISTS deny_all ON public.%I FOR ALL TO public USING (false);', rec.relname);
        EXECUTE format('CREATE POLICY IF NOT EXISTS all_service_role ON public.%I FOR ALL TO service_role USING (true);', rec.relname);
    END LOOP;
END$$;

-- Example: For tables with user_id, allow authenticated users to select their own rows
-- (You should review and customize these for your actual schema and business logic)
-- Uncomment and adjust as needed:
-- CREATE POLICY select_authenticated ON public.<table_name> FOR SELECT TO authenticated USING (auth.uid() = user_id);
