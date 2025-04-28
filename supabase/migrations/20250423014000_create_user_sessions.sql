-- Migration: Create user_sessions table for session management, analytics, and personalization
-- Purpose: Ensure all user session data is tracked in codebase for reproducible, scalable analytics and UX
-- Affected Table: public.user_sessions
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 01:40:00 UTC

-- 1. Create user_sessions table
create table if not exists public.user_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  session_token text not null,
  device_info jsonb,
  ip_address text,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.user_sessions enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own sessions)
create policy "Select own sessions (authenticated)" on public.user_sessions for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can create their own session)
create policy "Insert own session (authenticated)" on public.user_sessions for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own session)
create policy "Update own session (authenticated)" on public.user_sessions for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own session)
create policy "Delete own session (authenticated)" on public.user_sessions for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public sessions only, if desired)
create policy "Select public sessions (anon)" on public.user_sessions for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists user_sessions_user_id_idx on public.user_sessions(user_id);

-- 5. Comments for documentation
comment on table public.user_sessions is 'Tracks user sessions for analytics, personalization, and security.';
comment on column public.user_sessions.session_token is 'Session token for authentication.';
comment on column public.user_sessions.device_info is 'JSON object with device/browser info.';
comment on column public.user_sessions.user_id is 'Foreign key to auth.users.';

-- End of migration
