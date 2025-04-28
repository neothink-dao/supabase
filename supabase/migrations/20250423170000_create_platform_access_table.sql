-- Migration: Create platform_access table
-- Description: Creates a table to track user access to different platforms
-- Author: Cascade AI
-- Date: 2025-04-23

-- Create platform_access table
create table if not exists public.platform_access (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  platform_slug text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  
  -- Ensure unique user-platform combinations
  constraint platform_access_user_platform_unique unique (user_id, platform_slug)
);

-- Add comment
comment on table public.platform_access is 'Tracks which platforms each user has access to';

-- Enable Row Level Security
alter table public.platform_access enable row level security;

-- Create RLS policies
-- Allow users to read their own platform access
create policy "Users can view their own platform access"
  on public.platform_access
  for select
  to authenticated
  using (auth.uid() = user_id);

-- Allow users to insert their own platform access (for self-service upgrades)
create policy "Users can request platform access"
  on public.platform_access
  for insert
  to authenticated
  with check (auth.uid() = user_id);

-- Allow service role to manage all platform access
create policy "Service role can manage all platform access"
  on public.platform_access
  for all
  to service_role
  using (true);

-- Create index for faster lookups
create index platform_access_user_id_idx on public.platform_access (user_id);
create index platform_access_platform_slug_idx on public.platform_access (platform_slug);
