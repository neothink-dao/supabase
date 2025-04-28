-- Migration: Reconcile user_profiles table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for user_profiles
-- Affected Table: public.user_profiles
-- Created: 2025-04-23 02:15:00 UTC

-- 1. Add missing columns if not present
alter table public.user_profiles add column if not exists platform text not null;
alter table public.user_profiles add column if not exists preferences jsonb default '{}'::jsonb;
alter table public.user_profiles add column if not exists interests text[] default ARRAY[]::text[];
alter table public.user_profiles add column if not exists expertise text[] default ARRAY[]::text[];
alter table public.user_profiles add column if not exists social_links jsonb default '{}'::jsonb;
alter table public.user_profiles add column if not exists updated_at timestamptz default now();

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.user_profiles drop column if exists some_old_column;

-- 3. Add comments for documentation
comment on table public.user_profiles is 'Stores user profile data for onboarding, personalization, and engagement.';
comment on column public.user_profiles.platform is 'Platform or app context for the profile.';
comment on column public.user_profiles.preferences is 'User preferences/settings as JSON.';
comment on column public.user_profiles.interests is 'Array of user interests.';
comment on column public.user_profiles.expertise is 'Array of user expertise areas.';
comment on column public.user_profiles.social_links is 'JSON object of user social links.';
comment on column public.user_profiles.user_id is 'Foreign key to auth.users.';

-- 4. (Re)Add RLS if not present
alter table public.user_profiles enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.user_profiles';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.user_profiles for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.user_profiles';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.user_profiles for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.user_profiles';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.user_profiles for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.user_profiles';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.user_profiles for delete to authenticated using (true);

-- End of migration
