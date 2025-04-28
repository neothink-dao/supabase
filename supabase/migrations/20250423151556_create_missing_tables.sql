-- Migration: Create analytics_events, user_achievements, and platform_access tables
-- Generated: 2025-04-23 15:15:56 UTC
-- Purpose: Add missing tables required by application code, with RLS and clear policies for production-readiness
-- NOTE: user_id columns are uuid and reference auth.users(id) in application logic, but no DB-level foreign key is created to avoid Supabase typegen issues.

-- 1. Drop tables if they exist (safe for empty tables, for dev only)
drop table if exists public.analytics_events cascade;
drop table if exists public.user_achievements cascade;
drop table if exists public.platform_access cascade;

-- 2. Create analytics_events table
create table if not exists public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null, -- references auth.users(id)
  platform text not null,
  event_name text not null,
  properties jsonb default '{}'::jsonb not null,
  created_at timestamptz not null default now()
);

-- Enable Row Level Security (RLS)
alter table public.analytics_events enable row level security;

-- RLS Policy: Allow authenticated users to insert their own events (WITH CHECK)
create policy "Authenticated users can insert their own analytics events" on public.analytics_events
  for insert to authenticated
  with check (auth.uid() = user_id);

-- RLS Policy: Allow authenticated users to select their own events
create policy "Authenticated users can select their own analytics events" on public.analytics_events
  for select to authenticated
  using (auth.uid() = user_id);

-- RLS Policy: Allow admin access (example; adjust as needed)
create policy "Admins can select all analytics events" on public.analytics_events
  for select to service_role
  using (true);

-- 3. Create user_achievements table
create table if not exists public.user_achievements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null, -- references auth.users(id)
  achievement_id uuid not null,
  achieved_at timestamptz not null default now(),
  platform text not null
);

alter table public.user_achievements enable row level security;

-- RLS Policy: Allow authenticated users to insert their own achievements (WITH CHECK)
create policy "Authenticated users can insert their own achievements" on public.user_achievements
  for insert to authenticated
  with check (auth.uid() = user_id);

-- RLS Policy: Allow authenticated users to select their own achievements
create policy "Authenticated users can select their own achievements" on public.user_achievements
  for select to authenticated
  using (auth.uid() = user_id);

-- 4. Create platform_access table
create table if not exists public.platform_access (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null, -- references auth.users(id)
  platform_slug text not null,
  granted_at timestamptz not null default now()
);

alter table public.platform_access enable row level security;

-- RLS Policy: Allow authenticated users to insert their own platform access (WITH CHECK)
create policy "Authenticated users can insert their own platform access" on public.platform_access
  for insert to authenticated
  with check (auth.uid() = user_id);

-- RLS Policy: Allow authenticated users to select their own platform access
create policy "Authenticated users can select their own platform access" on public.platform_access
  for select to authenticated
  using (auth.uid() = user_id);

-- End of migration
