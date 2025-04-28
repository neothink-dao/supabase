-- Migration: Create analytics_events table for first-party event tracking
-- Created: 20250420191211 UTC
-- Purpose: Enable granular, extensible tracking of user/admin/app events for audit, analytics, and growth—no third-party code required.
-- Affected: Adds new table, RLS policies, and indexes

-- 1. Create analytics_events table
create table if not exists public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  event_type text not null, -- e.g. 'onboarding_step', 'profile_update', 'admin_action', etc.
  event_data jsonb,         -- Arbitrary event payload (e.g., {"step": "welcome", "source": "hub"})
  created_at timestamptz default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.analytics_events enable row level security;

-- 3. RLS Policies
-- Users can insert their own events
create policy "Users can insert their own analytics events"
  on public.analytics_events
  for insert
  to authenticated
  with check (auth.uid() = user_id);

-- Users can select their own events
create policy "Users can select their own analytics events"
  on public.analytics_events
  for select
  to authenticated
  using (auth.uid() = user_id);

-- Admins (service_role) can select all events
create policy "Admins can select all analytics events"
  on public.analytics_events
  for select
  to service_role
  using (true);

-- 4. Index for querying by user and event type
create index if not exists analytics_events_user_id_idx on public.analytics_events(user_id);
create index if not exists analytics_events_event_type_idx on public.analytics_events(event_type);

-- 5. Documentation
-- All policies and indexes above are documented inline. Update project docs to reference this migration for audit/compliance.

-- End of migration
