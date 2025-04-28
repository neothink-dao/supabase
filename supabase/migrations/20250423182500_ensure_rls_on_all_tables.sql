-- Migration: Ensure RLS on all tables
-- Purpose: Verify all tables have RLS enabled and appropriate policies
-- Affected tables: analytics_events, user_activity_logs
-- Date: 2025-04-23

-- Ensure RLS is enabled on analytics_events
alter table if exists public.analytics_events enable row level security;

-- Create RLS policies for analytics_events if they don't exist
do $$
begin
  -- Policy for users to view their own analytics events
  if not exists (
    select 1 from pg_policies 
    where tablename = 'analytics_events' and policyname = 'Users can view their own analytics events'
  ) then
    create policy "Users can view their own analytics events"
    on public.analytics_events
    for select
    to authenticated
    using (auth.uid() = user_id);
  end if;
  
  -- Policy for users to insert their own analytics events
  if not exists (
    select 1 from pg_policies 
    where tablename = 'analytics_events' and policyname = 'Users can insert their own analytics events'
  ) then
    create policy "Users can insert their own analytics events"
    on public.analytics_events
    for insert
    to authenticated
    with check (auth.uid() = user_id);
  end if;
  
  -- Policy for admins to view all analytics events
  if not exists (
    select 1 from pg_policies 
    where tablename = 'analytics_events' and policyname = 'Admins can view all analytics events'
  ) then
    create policy "Admins can view all analytics events"
    on public.analytics_events
    for select
    using (auth.jwt() ? 'admin_access');
  end if;
end
$$;

-- Ensure RLS is enabled on user_activity_logs
alter table if exists public.user_activity_logs enable row level security;

-- Create RLS policies for user_activity_logs if they don't exist
do $$
begin
  -- Policy for users to view their own activity logs
  if not exists (
    select 1 from pg_policies 
    where tablename = 'user_activity_logs' and policyname = 'Users can view their own activity logs'
  ) then
    create policy "Users can view their own activity logs"
    on public.user_activity_logs
    for select
    to authenticated
    using (auth.uid() = user_id);
  end if;
  
  -- Policy for users to insert their own activity logs
  if not exists (
    select 1 from pg_policies 
    where tablename = 'user_activity_logs' and policyname = 'Users can insert their own activity logs'
  ) then
    create policy "Users can insert their own activity logs"
    on public.user_activity_logs
    for insert
    to authenticated
    with check (auth.uid() = user_id);
  end if;
  
  -- Policy for admins to view all activity logs
  if not exists (
    select 1 from pg_policies 
    where tablename = 'user_activity_logs' and policyname = 'Admins can view all activity logs'
  ) then
    create policy "Admins can view all activity logs"
    on public.user_activity_logs
    for select
    using (auth.jwt() ? 'admin_access');
  end if;
end
$$;

-- Document tables without RLS in a comment for future reference
comment on schema public is 'Standard public schema with RLS enabled on all user-related tables. 
Tables without RLS:
- None - all tables have RLS enabled as of 2025-04-23
';
