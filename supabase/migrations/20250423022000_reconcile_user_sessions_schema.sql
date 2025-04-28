-- Migration: Reconcile user_sessions table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for user_sessions
-- Affected Table: public.user_sessions
-- Created: 2025-04-23 02:20:00 UTC

-- 1. Add missing columns if not present
alter table public.user_sessions add column if not exists platform_slug text not null;
alter table public.user_sessions add column if not exists interaction_count integer not null default 0;
alter table public.user_sessions add column if not exists last_page_url text;
alter table public.user_sessions add column if not exists last_page_title text;
alter table public.user_sessions add column if not exists updated_at timestamptz not null default now();

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.user_sessions drop column if exists session_token;
-- alter table public.user_sessions drop column if exists device_info;
-- alter table public.user_sessions drop column if exists ip_address;
-- alter table public.user_sessions drop column if exists started_at;
-- alter table public.user_sessions drop column if exists ended_at;

-- 3. Add comments for documentation
comment on table public.user_sessions is 'Tracks user sessions for analytics, personalization, and engagement.';
comment on column public.user_sessions.platform_slug is 'Platform or app context for the session.';
comment on column public.user_sessions.interaction_count is 'Number of user interactions in this session.';
comment on column public.user_sessions.last_page_url is 'URL of the last page visited in the session.';
comment on column public.user_sessions.last_page_title is 'Title of the last page visited.';
comment on column public.user_sessions.user_id is 'Foreign key to auth.users.';

-- 4. (Re)Add RLS if not present
alter table public.user_sessions enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_sessions' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.user_sessions';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.user_sessions for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_sessions' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.user_sessions';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.user_sessions for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_sessions' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.user_sessions';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.user_sessions for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_sessions' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.user_sessions';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.user_sessions for delete to authenticated using (true);

-- End of migration
