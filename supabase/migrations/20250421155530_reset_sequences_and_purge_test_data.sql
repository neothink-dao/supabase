-- Migration: Reset all sequences and purge any lingering test/demo data
-- Generated: 2025-04-21 15:55:30 UTC
-- Purpose: Ensure all auto-incrementing IDs start at 1 and the database is fully clean for production launch.

-- 1. Reset sequences for all tables (auth.users, public.*)
-- Replace 'users_id_seq' and other sequence names as appropriate for your schema
-- Example for 'auth.users' (adjust if your PK is UUID or different):
DO $$
DECLARE
  seq_name text;
BEGIN
  -- Reset all sequences in the 'public' schema
  FOR seq_name IN SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public' LOOP
    EXECUTE format('ALTER SEQUENCE public.%I RESTART WITH 1;', seq_name);
  END LOOP;
  -- Reset all sequences in the 'auth' schema
  FOR seq_name IN SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'auth' LOOP
    EXECUTE format('ALTER SEQUENCE auth.%I RESTART WITH 1;', seq_name);
  END LOOP;
END $$;

-- 2. Purge all users except your admin account (replace 'your-admin-id' with your real admin UUID)
delete from auth.users where id != 'your-admin-id';

-- 3. Purge any test/demo data from other tables (add more as needed)
-- delete from public.content where ...;
-- delete from public.analytics_events where ...;

-- 4. (Optional) Truncate tables with only test/demo data
-- truncate table public.legacy_table restart identity cascade;

-- 5. Add any additional cleanup as needed

-- RLS and other security policies already enforced in prior migrations.
