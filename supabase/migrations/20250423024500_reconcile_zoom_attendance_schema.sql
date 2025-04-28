-- Migration: Reconcile zoom_attendance table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for zoom_attendance
-- Affected Table: public.zoom_attendance
-- Created: 2025-04-23 02:45:00 UTC

-- 1. Add missing columns if not present
alter table public.zoom_attendance add column if not exists meeting_id text not null;
alter table public.zoom_attendance add column if not exists join_time timestamptz not null default now();
alter table public.zoom_attendance add column if not exists leave_time timestamptz;
alter table public.zoom_attendance add column if not exists reward_processed boolean default false;

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.zoom_attendance drop column if exists event_id;
-- alter table public.zoom_attendance drop column if exists joined_at;
-- alter table public.zoom_attendance drop column if exists left_at;

-- 3. Add comments for documentation
comment on table public.zoom_attendance is 'Tracks user attendance at Zoom events for analytics, engagement, and rewards.';
comment on column public.zoom_attendance.meeting_id is 'Zoom meeting ID.';
comment on column public.zoom_attendance.join_time is 'Timestamp when user joined the Zoom meeting.';
comment on column public.zoom_attendance.leave_time is 'Timestamp when user left the Zoom meeting.';
comment on column public.zoom_attendance.reward_processed is 'Whether attendance reward has been processed.';
comment on column public.zoom_attendance.user_id is 'Foreign key to auth.users.';

-- 4. (Re)Add RLS if not present
alter table public.zoom_attendance enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'zoom_attendance' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.zoom_attendance';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.zoom_attendance for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'zoom_attendance' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.zoom_attendance';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.zoom_attendance for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'zoom_attendance' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.zoom_attendance';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.zoom_attendance for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'zoom_attendance' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.zoom_attendance';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.zoom_attendance for delete to authenticated using (true);

-- End of migration
