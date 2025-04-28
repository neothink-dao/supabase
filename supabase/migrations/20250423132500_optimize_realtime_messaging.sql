-- Migration: 20250423132500_optimize_realtime_messaging.sql
-- Purpose: Optimize database for realtime messaging across all four apps
-- Affected tables: messages, user_activity_logs, realtime_channels
-- Special considerations: Implements declarative schema approach for Supabase

-- Enable the pgcrypto extension if not already enabled
create extension if not exists pgcrypto;

-- Create or update the messages table with optimized structure
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references auth.users(id) on delete cascade,
  content text not null,
  context text not null,
  type text not null default 'chat',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  attachments jsonb,
  metadata jsonb
);

comment on table public.messages is 'Stores messages for real-time communication across all Neothink apps';

-- Create indexes for efficient querying
create index if not exists idx_messages_author on public.messages (author_id);
create index if not exists idx_messages_context on public.messages (context);
create index if not exists idx_messages_created_at on public.messages (created_at desc);
create index if not exists idx_messages_type on public.messages (type);

-- Enable Row Level Security
alter table public.messages enable row level security;

-- Create RLS policies for messages
drop policy if exists "Users can view messages in their context" on public.messages;
create policy "Users can view messages in their context"
on public.messages
for select
to authenticated
using (true);  -- All authenticated users can view messages

drop policy if exists "Users can insert their own messages" on public.messages;
create policy "Users can insert their own messages"
on public.messages
for insert
to authenticated
with check (auth.uid() = author_id);

-- Create realtime_channels table for managing broadcast channels
create table if not exists public.realtime_channels (
  id uuid primary key default gen_random_uuid(),
  channel_name text not null unique,
  description text,
  is_public boolean not null default true,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.realtime_channels is 'Manages realtime broadcast channels across all Neothink apps';

-- Create index for efficient channel lookup
create index if not exists idx_realtime_channels_name on public.realtime_channels (channel_name);

-- Enable Row Level Security
alter table public.realtime_channels enable row level security;

-- Create RLS policies for realtime_channels
drop policy if exists "Anyone can view public channels" on public.realtime_channels;
create policy "Anyone can view public channels"
on public.realtime_channels
for select
to authenticated
using (is_public = true or auth.uid() = created_by);

drop policy if exists "Users can create channels" on public.realtime_channels;
create policy "Users can create channels"
on public.realtime_channels
for insert
to authenticated
with check (auth.uid() = created_by);

-- Create function to handle message broadcasting
create or replace function public.broadcast_message(
  p_channel text,
  p_message jsonb
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  -- Perform the broadcast
  perform pg_notify(
    'realtime:' || p_channel,
    json_build_object(
      'type', 'broadcast',
      'event', 'message',
      'payload', p_message
    )::text
  );
end;
$$;

comment on function public.broadcast_message is 'Broadcasts a message to a realtime channel';

-- Create function to get messages with pagination and author info
create or replace function public.get_messages_with_author(
  p_context text,
  p_limit integer default 50,
  p_offset integer default 0
)
returns table (
  id uuid,
  content text,
  context text,
  type text,
  created_at timestamptz,
  author_id uuid,
  author_name text,
  author_avatar text,
  attachments jsonb
)
language plpgsql
security invoker
set search_path = ''
as $$
begin
  return query
  select 
    m.id,
    m.content,
    m.context,
    m.type,
    m.created_at,
    m.author_id,
    p.full_name as author_name,
    p.avatar_url as author_avatar,
    m.attachments
  from public.messages m
  join public.profiles p on m.author_id = p.id
  where m.context = p_context
  order by m.created_at desc
  limit p_limit
  offset p_offset;
end;
$$;

comment on function public.get_messages_with_author is 'Gets messages with author information for a specific context';

-- Create function to handle message insertion with broadcasting
create or replace function public.insert_and_broadcast_message(
  p_author_id uuid,
  p_content text,
  p_context text,
  p_type text default 'chat',
  p_attachments jsonb default null
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_message public.messages;
  v_author public.profiles;
  v_result jsonb;
begin
  -- Insert the message
  insert into public.messages (
    author_id,
    content,
    context,
    type,
    attachments
  )
  values (
    p_author_id,
    p_content,
    p_context,
    p_type,
    p_attachments
  )
  returning * into v_message;
  
  -- Get author information
  select * into v_author
  from public.profiles
  where id = p_author_id;
  
  -- Prepare the broadcast payload
  v_result := jsonb_build_object(
    'id', v_message.id,
    'content', v_message.content,
    'context', v_message.context,
    'type', v_message.type,
    'created_at', v_message.created_at,
    'author', jsonb_build_object(
      'id', v_author.id,
      'name', v_author.full_name,
      'baseAvatar', v_author.avatar_url
    ),
    'attachments', v_message.attachments
  );
  
  -- Broadcast the message
  perform public.broadcast_message(
    'messages-' || p_context,
    v_result
  );
  
  -- Track user activity
  insert into public.user_activity_logs (
    user_id,
    action_type,
    metadata
  )
  values (
    p_author_id,
    'message_sent',
    jsonb_build_object(
      'message_id', v_message.id,
      'context', p_context,
      'content_length', length(p_content),
      'has_attachments', p_attachments is not null
    )
  );
  
  return v_result;
end;
$$;

comment on function public.insert_and_broadcast_message is 'Inserts a message and broadcasts it to the appropriate channel';

-- Enable realtime for messages table
alter publication supabase_realtime add table public.messages;

-- Create trigger to handle realtime broadcasts
create or replace function public.handle_message_broadcast()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_author public.profiles;
  v_payload jsonb;
begin
  -- Get author information
  select * into v_author
  from public.profiles
  where id = NEW.author_id;
  
  -- Prepare the broadcast payload
  v_payload := jsonb_build_object(
    'id', NEW.id,
    'content', NEW.content,
    'context', NEW.context,
    'type', NEW.type,
    'created_at', NEW.created_at,
    'author', jsonb_build_object(
      'id', v_author.id,
      'name', v_author.full_name,
      'baseAvatar', v_author.avatar_url
    ),
    'attachments', NEW.attachments
  );
  
  -- Broadcast the message
  perform pg_notify(
    'realtime:messages-' || NEW.context,
    json_build_object(
      'type', 'broadcast',
      'event', 'message',
      'payload', v_payload
    )::text
  );
  
  return NEW;
end;
$$;

-- Create trigger for message broadcasts
drop trigger if exists trigger_message_broadcast on public.messages;
create trigger trigger_message_broadcast
after insert on public.messages
for each row
execute function public.handle_message_broadcast();
