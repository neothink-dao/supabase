-- Migration: Create user_events table for contextual, cross-app analytics
-- Purpose: Track user behavior, engagement, and feature usage across all apps/sites in the monorepo
-- Affected: Adds user_events table with RLS for privacy and admin analytics
-- Special: Fully context-aware, privacy-respecting, and optimized for querying by app/context/user/event

-- 1. Create the user_events table
create table if not exists public.user_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  context text not null, -- e.g. 'hub', 'ascenders', 'neothinkers', 'immortals', or app identifier
  event_type text not null, -- e.g. 'login', 'post', 'reply', 'context_switch', 'page_view', etc.
  event_payload jsonb, -- optional metadata (feature, location, etc.)
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.user_events enable row level security;

-- 3. RLS Policy: Allow insert for authenticated users (can only insert their own events)
create policy "Allow insert own event" on public.user_events
  for insert to authenticated
  using (auth.uid() = user_id);

-- 4. RLS Policy: Allow select for admin role only
create policy "Allow select for admin" on public.user_events
  for select to authenticated
  using (auth.role() = 'service_role');

-- 5. RLS Policy: Allow users to select their own events (optional, can remove for more privacy)
create policy "Allow select own events" on public.user_events
  for select to authenticated
  using (auth.uid() = user_id);

-- 6. Index for fast querying by user/context/event_type
create index if not exists idx_user_events_user_context_event on public.user_events (user_id, context, event_type);

-- 7. Comments for documentation
comment on table public.user_events is 'Tracks user behavior/events across all apps/contexts. Used for analytics, engagement, and product improvement.';
comment on column public.user_events.context is 'The app/site/context in which the event occurred.';
comment on column public.user_events.event_type is 'Type of event (login, post, reply, etc).';
comment on column public.user_events.event_payload is 'Optional metadata for event (feature, location, etc).';
comment on column public.user_events.user_id is 'User who performed the event.';

-- 8. (Optional) Add triggers for audit/logging if needed
