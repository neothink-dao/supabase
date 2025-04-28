-- create_analytics_events_table.sql
-- migration to create the analytics_events table for event tracking

-- create analytics_events table
create table if not exists public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  event_name text not null,
  user_id uuid references auth.users(id),
  properties jsonb not null default '{}',
  timestamp timestamp with time zone default now() not null,
  created_at timestamp with time zone default now() not null
);

-- add comment to the table
comment on table public.analytics_events is 'Stores user event tracking data for analytics';

-- enable row level security
alter table public.analytics_events enable row level security;

-- create policies
-- only authenticated users can insert their own events
create policy "Users can insert their own events"
  on public.analytics_events
  for insert
  with check (auth.uid() = user_id or user_id is null);

-- only admins can select events
create policy "Only admins can view analytics events"
  on public.analytics_events
  for select
  using (auth.jwt() ? 'admin_access');

-- create index for faster queries
create index analytics_events_user_id_idx on public.analytics_events(user_id);
create index analytics_events_event_name_idx on public.analytics_events(event_name);
create index analytics_events_timestamp_idx on public.analytics_events(timestamp);
