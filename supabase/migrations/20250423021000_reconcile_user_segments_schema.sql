-- Migration: Reconcile user_segments table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for user_segments
-- Affected Table: public.user_segments
-- Created: 2025-04-23 02:10:00 UTC

-- 1. Add missing columns if not present
alter table public.user_segments add column if not exists platform text not null;
alter table public.user_segments add column if not exists segment_name text not null;
alter table public.user_segments add column if not exists segment_rules jsonb not null;
alter table public.user_segments add column if not exists created_by uuid;
alter table public.user_segments add column if not exists updated_at timestamptz default now();

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.user_segments drop column if exists user_id;
-- alter table public.user_segments drop column if exists segment_key;
-- alter table public.user_segments drop column if exists segment_value;
-- alter table public.user_segments drop column if exists assigned_at;

-- 3. Add comments for documentation
comment on table public.user_segments is 'Tracks user segmentation for advanced analytics, onboarding, and personalization.';
comment on column public.user_segments.platform is 'Platform or app context for the segment.';
comment on column public.user_segments.segment_name is 'Name of the segment.';
comment on column public.user_segments.segment_rules is 'JSON rules for segment membership.';
comment on column public.user_segments.created_by is 'User who created the segment.';
comment on column public.user_segments.updated_at is 'Timestamp of last update.';

-- 4. (Re)Add RLS if not present
alter table public.user_segments enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
-- Drop then create policies for idempotency
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_segments' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.user_segments';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.user_segments for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_segments' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.user_segments';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.user_segments for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_segments' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.user_segments';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.user_segments for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_segments' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.user_segments';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.user_segments for delete to authenticated using (true);

-- End of migration
