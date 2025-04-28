-- Migration: Reconcile user_skills table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for user_skills
-- Affected Table: public.user_skills
-- Created: 2025-04-23 02:25:00 UTC

-- 1. Add missing columns if not present
alter table public.user_skills add column if not exists proficiency_level integer not null;
alter table public.user_skills add column if not exists last_assessed_at timestamptz default now();
alter table public.user_skills add column if not exists updated_at timestamptz default now();

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.user_skills drop column if exists endorsed_by;

-- 3. Add comments for documentation
comment on table public.user_skills is 'Tracks user skills for endorsements, recommendations, and personalization.';
comment on column public.user_skills.skill_name is 'Name of the skill.';
comment on column public.user_skills.proficiency_level is 'User-reported proficiency (integer scale).';
comment on column public.user_skills.last_assessed_at is 'Timestamp of last skill assessment.';
comment on column public.user_skills.user_id is 'Foreign key to auth.users.';

-- 4. (Re)Add RLS if not present
alter table public.user_skills enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_skills' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.user_skills';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.user_skills for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_skills' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.user_skills';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.user_skills for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_skills' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.user_skills';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.user_skills for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_skills' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.user_skills';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.user_skills for delete to authenticated using (true);

-- End of migration
