-- Migration: Update user progress tracking and onboarding support
-- Purpose: Update tables and columns for tracking user progress, mastery levels, and onboarding status
-- Affected tables: profiles, user_progress
-- Date: 2025-04-23

-- Add onboarding columns to profiles table if they don't exist
alter table public.profiles
add column if not exists onboarding_progress text[] default '{}',
add column if not exists onboarding_current_step text default 'profile',
add column if not exists onboarding_completed boolean default false,
add column if not exists onboarding_completed_at timestamptz;

-- Add comments for new columns if they don't exist
comment on column public.profiles.onboarding_progress is 'Array of completed onboarding steps';
comment on column public.profiles.onboarding_current_step is 'Current onboarding step';
comment on column public.profiles.onboarding_completed is 'Whether onboarding has been completed';
comment on column public.profiles.onboarding_completed_at is 'When onboarding was completed';

-- Create user_progress table if it doesn't exist
create table if not exists public.user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  
  -- Prosperity path progress
  prosperity_completion integer default 0,
  prosperity_level integer default 1,
  prosperity_milestones text[] default '{}',
  
  -- Happiness path progress
  happiness_completion integer default 0,
  happiness_level integer default 1,
  happiness_milestones text[] default '{}',
  
  -- Longevity path progress
  longevity_completion integer default 0,
  longevity_level integer default 1,
  longevity_milestones text[] default '{}',
  
  -- Metadata
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Add comment for user_progress table
comment on table public.user_progress is 'Stores user progress across all value paths';

-- Enable RLS on the user_progress table if not already enabled
alter table public.user_progress enable row level security;

-- Drop existing policies to avoid errors
do $$
begin
  -- Drop policies if they exist
  if exists (
    select 1 from pg_policies 
    where tablename = 'user_progress' and policyname = 'Users can view their own progress'
  ) then
    drop policy "Users can view their own progress" on public.user_progress;
  end if;
  
  if exists (
    select 1 from pg_policies 
    where tablename = 'user_progress' and policyname = 'Users can create their own progress'
  ) then
    drop policy "Users can create their own progress" on public.user_progress;
  end if;
  
  if exists (
    select 1 from pg_policies 
    where tablename = 'user_progress' and policyname = 'Users can update their own progress'
  ) then
    drop policy "Users can update their own progress" on public.user_progress;
  end if;
end
$$;

-- Create RLS policies for user_progress
create policy "Users can view their own progress"
on public.user_progress
for select
to authenticated
using (auth.uid() = user_id);

create policy "Users can create their own progress"
on public.user_progress
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Users can update their own progress"
on public.user_progress
for update
to authenticated
using (auth.uid() = user_id);

-- Create index for faster queries if it doesn't exist
create index if not exists user_progress_user_id_idx on public.user_progress (user_id);

-- Create user_activity_logs table if it doesn't exist
create table if not exists public.user_activity_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  activity_type text not null,
  activity_path text,
  metadata jsonb,
  created_at timestamptz not null default now()
);

-- Add comment for user_activity_logs table
comment on table public.user_activity_logs is 'Stores user activity logs for analytics';

-- Enable RLS on the user_activity_logs table if not already enabled
alter table public.user_activity_logs enable row level security;

-- Drop existing policies to avoid errors
do $$
begin
  -- Drop policies if they exist
  if exists (
    select 1 from pg_policies 
    where tablename = 'user_activity_logs' and policyname = 'Users can view their own activity logs'
  ) then
    drop policy "Users can view their own activity logs" on public.user_activity_logs;
  end if;
  
  if exists (
    select 1 from pg_policies 
    where tablename = 'user_activity_logs' and policyname = 'Users can create their own activity logs'
  ) then
    drop policy "Users can create their own activity logs" on public.user_activity_logs;
  end if;
end
$$;

-- Create RLS policies for user_activity_logs
create policy "Users can view their own activity logs"
on public.user_activity_logs
for select
to authenticated
using (auth.uid() = user_id);

create policy "Users can create their own activity logs"
on public.user_activity_logs
for insert
to authenticated
with check (auth.uid() = user_id);

-- Create indexes for faster queries if they don't exist
create index if not exists user_activity_logs_user_id_idx on public.user_activity_logs (user_id);
create index if not exists user_activity_logs_activity_type_idx on public.user_activity_logs (activity_type);
