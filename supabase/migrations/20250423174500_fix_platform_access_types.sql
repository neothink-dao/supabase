-- Migration: Fix platform access types and add missing security tables
-- Purpose: Add missing tables for security events and platform access tracking
-- Affected tables: security_events, platform_access
-- Date: 2025-04-23

-- Create security_events table if it doesn't exist
create table if not exists public.security_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  event_type text not null,
  severity text not null,
  ip_address text,
  request_path text,
  metadata jsonb,
  details jsonb,
  created_at timestamptz not null default now()
);

-- Add comment for security_events table
comment on table public.security_events is 'Stores security events for audit and monitoring';

-- Enable RLS on security_events
alter table public.security_events enable row level security;

-- Create RLS policies for security_events
do $$
begin
  if not exists (
    select 1 from pg_policies 
    where tablename = 'security_events' and policyname = 'Only admins can view security events'
  ) then
    create policy "Only admins can view security events"
    on public.security_events
    for select
    using (auth.jwt() ? 'admin_access');
  end if;
  
  if not exists (
    select 1 from pg_policies 
    where tablename = 'security_events' and policyname = 'System can insert security events'
  ) then
    create policy "System can insert security events"
    on public.security_events
    for insert
    with check (true);
  end if;
end
$$;

-- Create index for faster queries
create index if not exists security_events_user_id_idx on public.security_events (user_id);
create index if not exists security_events_event_type_idx on public.security_events (event_type);
create index if not exists security_events_created_at_idx on public.security_events (created_at);

-- Ensure platform_access table exists with proper structure
create table if not exists public.platform_access (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  platform text not null,
  access_level text not null default 'basic',
  is_active boolean not null default true,
  metadata jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Add comment for platform_access table
comment on table public.platform_access is 'Tracks user access levels across different platforms';

-- Enable RLS on platform_access
alter table public.platform_access enable row level security;

-- Create RLS policies for platform_access
do $$
begin
  if not exists (
    select 1 from pg_policies 
    where tablename = 'platform_access' and policyname = 'Users can view their own platform access'
  ) then
    create policy "Users can view their own platform access"
    on public.platform_access
    for select
    to authenticated
    using (auth.uid() = user_id);
  end if;
  
  if not exists (
    select 1 from pg_policies 
    where tablename = 'platform_access' and policyname = 'Only admins can manage platform access'
  ) then
    create policy "Only admins can manage platform access"
    on public.platform_access
    for all
    using (auth.jwt() ? 'admin_access');
  end if;
end
$$;

-- Create indexes for faster queries
create index if not exists platform_access_user_id_idx on public.platform_access (user_id);
create index if not exists platform_access_platform_idx on public.platform_access (platform);

-- Create function to check if a user has access to a platform
create or replace function public.has_platform_access(user_id uuid, platform_name text)
returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
declare
  has_access boolean;
begin
  select exists(
    select 1
    from public.platform_access
    where user_id = has_platform_access.user_id
    and platform = platform_name
    and is_active = true
  ) into has_access;
  
  return coalesce(has_access, false);
end;
$$;

-- Create trigger to update the updated_at column
create or replace function public.update_platform_access_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Create trigger for platform_access table
create trigger update_platform_access_updated_at
before update on public.platform_access
for each row
execute function public.update_platform_access_updated_at();
