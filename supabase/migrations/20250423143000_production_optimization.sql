-- Migration: 20250423143000_production_optimization.sql
-- Purpose: Final production optimizations for database performance and security
-- Affected tables: user_progress, user_activity_logs, messages, profiles
-- Special considerations: Implements performance optimizations and ensures all tables have proper RLS policies

-- Add indexes for improved query performance
-- These indexes target the most frequently used queries across all four apps

-- Optimize user_progress queries
create index if not exists idx_user_progress_user_content_type on public.user_progress (user_id, content_type);
create index if not exists idx_user_progress_completed on public.user_progress (completed) where completed = true;
create index if not exists idx_user_progress_updated_at on public.user_progress (updated_at desc);

comment on index public.idx_user_progress_user_content_type is 'Improves performance for filtering progress by user and content type';
comment on index public.idx_user_progress_completed is 'Partial index for quickly finding completed content';
comment on index public.idx_user_progress_updated_at is 'Improves performance for sorting by last updated';

-- Optimize user_activity_logs queries
create index if not exists idx_user_activity_logs_action_type on public.user_activity_logs (action_type);
create index if not exists idx_user_activity_logs_created_at on public.user_activity_logs (created_at desc);
create index if not exists idx_user_activity_logs_user_action on public.user_activity_logs (user_id, action_type);

comment on index public.idx_user_activity_logs_action_type is 'Improves performance for filtering by action type';
comment on index public.idx_user_activity_logs_created_at is 'Improves performance for sorting by creation date';
comment on index public.idx_user_activity_logs_user_action is 'Improves performance for filtering by user and action type';

-- Optimize messages queries with GIN index for JSONB
create index if not exists idx_messages_attachments on public.messages using gin (attachments jsonb_path_ops);
create index if not exists idx_messages_type_context on public.messages (type, context);

comment on index public.idx_messages_attachments is 'GIN index for efficient querying of JSONB attachments';
comment on index public.idx_messages_type_context is 'Improves performance for filtering by message type and context';

-- Ensure all tables have proper RLS policies
-- This follows the best practices outlined in the user rules

-- RLS for user_progress
alter table if exists public.user_progress enable row level security;

-- Drop existing policies to ensure clean slate
drop policy if exists "Users can view their own progress" on public.user_progress;
drop policy if exists "Users can update their own progress" on public.user_progress;
drop policy if exists "Users can insert their own progress" on public.user_progress;

-- Create comprehensive RLS policies for user_progress
create policy "Users can view their own progress"
on public.user_progress
for select
to authenticated
using (auth.uid() = user_id);

create policy "Users can insert their own progress"
on public.user_progress
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Users can update their own progress"
on public.user_progress
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- RLS for user_activity_logs
alter table if exists public.user_activity_logs enable row level security;

-- Drop existing policies to ensure clean slate
drop policy if exists "Users can view their own activity logs" on public.user_activity_logs;
drop policy if exists "Users can insert their own activity logs" on public.user_activity_logs;

-- Create comprehensive RLS policies for user_activity_logs
create policy "Users can view their own activity logs"
on public.user_activity_logs
for select
to authenticated
using (auth.uid() = user_id);

create policy "Users can insert their own activity logs"
on public.user_activity_logs
for insert
to authenticated
with check (auth.uid() = user_id);

-- Create optimized function for retrieving user progress across all content types
create or replace function public.get_user_progress_summary(
  p_user_id uuid
)
returns table (
  content_type text,
  completed_count bigint,
  in_progress_count bigint,
  total_count bigint,
  completion_percentage numeric
)
language plpgsql
security invoker
set search_path = ''
as $$
begin
  return query
  select
    up.content_type,
    count(*) filter (where up.completed = true) as completed_count,
    count(*) filter (where up.completed = false) as in_progress_count,
    count(*) as total_count,
    round((count(*) filter (where up.completed = true)::numeric / nullif(count(*)::numeric, 0)) * 100, 2) as completion_percentage
  from public.user_progress up
  where up.user_id = p_user_id
  group by up.content_type
  order by up.content_type;
end;
$$;

comment on function public.get_user_progress_summary is 'Returns a summary of user progress across all content types';

-- Create function to get recent user activity
create or replace function public.get_recent_user_activity(
  p_user_id uuid,
  p_limit integer default 10
)
returns table (
  id uuid,
  action_type text,
  created_at timestamptz,
  metadata jsonb
)
language plpgsql
security invoker
set search_path = ''
as $$
begin
  return query
  select
    ual.id,
    ual.action_type,
    ual.created_at,
    ual.metadata
  from public.user_activity_logs ual
  where ual.user_id = p_user_id
  order by ual.created_at desc
  limit p_limit;
end;
$$;

comment on function public.get_recent_user_activity is 'Returns recent activity for a specific user';

-- Add metadata validation to ensure consistent structure
alter table public.user_progress
  add constraint check_metadata_json check (metadata is null or jsonb_typeof(metadata) = 'object');

alter table public.user_activity_logs
  add constraint check_metadata_json check (metadata is null or jsonb_typeof(metadata) = 'object');

alter table public.messages
  add constraint check_attachments_json check (attachments is null or jsonb_typeof(attachments) = 'array');

-- Add comments to tables for better documentation
comment on table public.user_progress is 'Tracks user progress across all content types in all four apps';
comment on table public.user_activity_logs is 'Logs user activities for analytics and audit trails';
comment on table public.messages is 'Stores messages for real-time communication across all apps';

-- Add comments to columns for better documentation
comment on column public.user_progress.user_id is 'The ID of the user';
comment on column public.user_progress.content_type is 'The type of content (course, article, video, etc.)';
comment on column public.user_progress.content_id is 'The ID of the content';
comment on column public.user_progress.progress_percentage is 'The percentage of completion (0-100)';
comment on column public.user_progress.completed is 'Whether the content has been completed';
comment on column public.user_progress.metadata is 'Additional metadata about the progress';

comment on column public.user_activity_logs.user_id is 'The ID of the user';
comment on column public.user_activity_logs.action_type is 'The type of action performed';
comment on column public.user_activity_logs.metadata is 'Additional metadata about the action';

comment on column public.messages.author_id is 'The ID of the message author';
comment on column public.messages.content is 'The content of the message';
comment on column public.messages.context is 'The context or room where the message was sent';
comment on column public.messages.type is 'The type of message (chat, post, announcement)';
comment on column public.messages.attachments is 'File attachments for the message';
