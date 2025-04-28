-- migration to fix any database inconsistencies and optimize for production
-- this migration focuses on optimizing indexes, fixing constraints, and ensuring RLS policies are correctly applied

-- comment on this migration
comment on migration '20250423170000_production_readiness_fixes.sql' is 'Fixes database inconsistencies and optimizes for production';

-- ensure all tables have RLS enabled
do $$
declare
  tbl text;
begin
  for tbl in
    select table_name
    from information_schema.tables
    where table_schema = 'public'
    and table_type = 'BASE TABLE'
  loop
    execute format('alter table public.%I enable row level security;', tbl);
  end loop;
end $$;

-- add missing indexes for foreign keys to improve query performance
create index if not exists idx_analytics_events_user_id on public.analytics_events(user_id);
create index if not exists idx_sessions_user_id on public.sessions(user_id);
create index if not exists idx_sessions_scheduled_at on public.sessions(scheduled_at);
create index if not exists idx_profiles_updated_at on public.profiles(updated_at);

-- optimize jsonb columns with gin indexes for faster json queries
create index if not exists idx_analytics_events_properties_gin on public.analytics_events using gin (properties jsonb_path_ops);
create index if not exists idx_profiles_metadata_gin on public.profiles using gin (metadata jsonb_path_ops);

-- ensure all tables have proper security policies
-- analytics_events policies
drop policy if exists "Users can insert their own events" on public.analytics_events;
create policy "Users can insert their own events"
  on public.analytics_events
  for insert
  with check (auth.uid() = user_id or user_id is null);

drop policy if exists "Only admins can view analytics events" on public.analytics_events;
create policy "Only admins can view analytics events"
  on public.analytics_events
  for select
  using (auth.jwt() ? 'admin_access');

-- sessions policies
drop policy if exists "Users can view their own sessions" on public.sessions;
create policy "Users can view their own sessions"
  on public.sessions
  for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert their own sessions" on public.sessions;
create policy "Users can insert their own sessions"
  on public.sessions
  for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own sessions" on public.sessions;
create policy "Users can update their own sessions"
  on public.sessions
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own sessions" on public.sessions;
create policy "Users can delete their own sessions"
  on public.sessions
  for delete
  using (auth.uid() = user_id);

-- profiles policies
drop policy if exists "Users can view their own profile" on public.profiles;
create policy "Users can view their own profile"
  on public.profiles
  for select
  using (auth.uid() = id);

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- add function to track user last active time
create or replace function public.handle_user_activity()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.profiles
  set last_active_at = now()
  where id = auth.uid();
  return new;
end;
$$;

-- create trigger to update last active time on session creation
drop trigger if exists on_session_created on public.sessions;
create trigger on_session_created
  after insert on public.sessions
  for each row
  execute function public.handle_user_activity();

-- create trigger to update last active time on analytics event creation
drop trigger if exists on_analytics_event_created on public.analytics_events;
create trigger on_analytics_event_created
  after insert on public.analytics_events
  for each row
  execute function public.handle_user_activity();

-- add function to generate user-friendly session IDs
create or replace function public.generate_friendly_id(length int default 8)
returns text
language plpgsql
security invoker
set search_path = ''
as $$
declare
  chars text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- omitting confusing characters like I, O, 1, 0
  result text := '';
  i int;
begin
  for i in 1..length loop
    result := result || substr(chars, floor(random() * length(chars))::integer + 1, 1);
  end loop;
  return result;
end;
$$;

-- add function to check if a user has completed onboarding
create or replace function public.has_completed_onboarding(user_id uuid)
returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
declare
  completed boolean;
begin
  select onboarding_completed into completed
  from public.profiles
  where id = user_id;
  
  return coalesce(completed, false);
end;
$$;
