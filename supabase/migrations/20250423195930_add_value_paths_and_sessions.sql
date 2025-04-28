-- Migration: Add value paths and scheduled sessions support
-- Purpose: Add columns to profiles table and create scheduled_sessions table for the sales funnel integration
-- Affected tables: profiles, scheduled_sessions (new)
-- Date: 2025-04-23

-- Add value_paths column to profiles table
alter table public.profiles
add column if not exists value_paths text[] default '{}',
add column if not exists has_scheduled_session boolean default false,
add column if not exists first_name text;

comment on column public.profiles.value_paths is 'Array of value path IDs selected by the user (prosperity, happiness, longevity)';
comment on column public.profiles.has_scheduled_session is 'Whether the user has scheduled a session';
comment on column public.profiles.first_name is 'User''s first name for personalized greetings';

-- Create scheduled_sessions table
create table if not exists public.scheduled_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  session_date text not null,
  session_time text not null,
  value_paths text[] not null,
  status text not null default 'scheduled',
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.scheduled_sessions is 'Stores scheduled sessions for users';

-- Enable RLS on the scheduled_sessions table
alter table public.scheduled_sessions enable row level security;

-- Create RLS policies for scheduled_sessions

-- Policy for select operations for authenticated users (can only see their own sessions)
create policy "Users can view their own scheduled sessions"
on public.scheduled_sessions
for select
to authenticated
using (auth.uid() = user_id);

-- Policy for insert operations for authenticated users (can only create sessions for themselves)
create policy "Users can create their own scheduled sessions"
on public.scheduled_sessions
for insert
to authenticated
with check (auth.uid() = user_id);

-- Policy for update operations for authenticated users (can only update their own sessions)
create policy "Users can update their own scheduled sessions"
on public.scheduled_sessions
for update
to authenticated
using (auth.uid() = user_id);

-- Policy for delete operations for authenticated users (can only delete their own sessions)
create policy "Users can delete their own scheduled sessions"
on public.scheduled_sessions
for delete
to authenticated
using (auth.uid() = user_id);

-- Create index for faster queries
create index if not exists scheduled_sessions_user_id_idx on public.scheduled_sessions (user_id);
