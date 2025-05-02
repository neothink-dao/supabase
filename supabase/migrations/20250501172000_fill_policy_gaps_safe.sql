-- Migration: 20250501172000_fill_policy_gaps_safe.sql
-- Purpose: Ensure every table with RLS enabled has at least a default-deny policy and a permissive policy for service_role.
-- This migration uses DO blocks and conditional checks since CREATE POLICY IF NOT EXISTS is not supported.

DO $$
DECLARE
    rec RECORD;
    policy_count INTEGER;
BEGIN
    FOR rec IN SELECT relname FROM pg_class JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace WHERE nspname = 'public' AND relkind = 'r' LOOP
        -- Check if any policies exist for this table
        SELECT COUNT(*) INTO policy_count FROM pg_policy WHERE polrelid = rec.oid;
        IF policy_count = 0 THEN
            EXECUTE format('CREATE POLICY deny_all ON public.%I FOR ALL TO public USING (false);', rec.relname);
            EXECUTE format('CREATE POLICY all_service_role ON public.%I FOR ALL TO service_role USING (true);', rec.relname);
        END IF;
    END LOOP;
END$$;
