-- Migration: Create zoom_attendance table for tracking user participation in Zoom events
-- Purpose: Ensure all Zoom attendance data is tracked in codebase for reproducible, scalable analytics and engagement
-- Affected Table: public.zoom_attendance
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 02:05:00 UTC

-- 1. Create zoom_attendance table
create table if not exists public.zoom_attendance (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  event_id uuid not null, -- Reference to the event (could be a separate events table)
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  duration_minutes integer,
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.zoom_attendance enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own attendance)
create policy "Select own attendance (authenticated)" on public.zoom_attendance for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can create their own attendance record)
create policy "Insert own attendance (authenticated)" on public.zoom_attendance for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own attendance record)
create policy "Update own attendance (authenticated)" on public.zoom_attendance for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own attendance record)
create policy "Delete own attendance (authenticated)" on public.zoom_attendance for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public attendance only, if desired)
create policy "Select public attendance (anon)" on public.zoom_attendance for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists zoom_attendance_user_id_idx on public.zoom_attendance(user_id);

-- 5. Comments for documentation
comment on table public.zoom_attendance is 'Tracks user attendance at Zoom events for analytics, engagement, and rewards.';
comment on column public.zoom_attendance.event_id is 'Reference to the Zoom event.';
comment on column public.zoom_attendance.user_id is 'Foreign key to auth.users.';
comment on column public.zoom_attendance.duration_minutes is 'Duration of attendance in minutes.';

-- End of migration
