-- Migration: Create user_sessions table for scheduled meetings and onboarding tracking
-- Purpose: Store all scheduled meeting sessions for onboarding, coaching, and funnel analytics.
-- Affected tables: user_sessions (new)
-- Special considerations: RLS enabled, granular policies for select/insert/update/delete for anon/authenticated roles

-- 1. Create the user_sessions table
create table public.user_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  strategist_id uuid references public.profiles(id),
  scheduled_at timestamptz not null, -- when the session is scheduled for
  time_slot text not null,           -- e.g. '10:00 AM'
  platform text not null,            -- e.g. 'hub', 'ascenders', etc
  value_paths text[] not null,       -- user's selected value paths at time of scheduling
  assessment_id uuid,                -- optional, link to assessment if exists
  status text not null default 'scheduled', -- scheduled, completed, canceled, no-show
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.user_sessions is 'Stores all scheduled onboarding, coaching, and funnel sessions for analytics and user journey tracking.';

-- 2. Enable Row Level Security (RLS)
alter table public.user_sessions enable row level security;

-- 3. RLS Policies (granular, for select/insert/update/delete, anon and authenticated)
-- SELECT policy for authenticated users (can only see their own sessions)
create policy "Authenticated users can select their own sessions"
  on public.user_sessions
  for select
  using (auth.uid() = user_id);

-- INSERT policy for authenticated users (can only insert for themselves)
create policy "Authenticated users can insert their own sessions"
  on public.user_sessions
  for insert
  with check (auth.uid() = user_id);

-- UPDATE policy for authenticated users (can only update their own sessions)
create policy "Authenticated users can update their own sessions"
  on public.user_sessions
  for update
  using (auth.uid() = user_id);

-- DELETE policy for admins only (never for general users)
create policy "Admins can delete sessions"
  on public.user_sessions
  for delete
  using (EXISTS (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

-- 4. Index for fast lookups by user and date
create index if not exists idx_user_sessions_user_id_scheduled_at on public.user_sessions (user_id, scheduled_at desc);

-- 5. Trigger to update updated_at on row modification
create or replace function public.update_user_sessions_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger update_user_sessions_updated_at_trigger
before update on public.user_sessions
for each row
execute function public.update_user_sessions_updated_at();
