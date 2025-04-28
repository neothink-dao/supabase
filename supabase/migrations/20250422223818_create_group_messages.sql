-- Migration: Create group_messages table for real-time group chat functionality
-- Purpose: Enables X-like group chat in each app context (hub, ascenders, neothinkers, immortals)
-- Affected tables: public.group_messages
-- Special considerations: RLS enabled, real-time support, context-specific access

-- 1. Create the group_messages table
create table if not exists public.group_messages (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  content text not null,
  context varchar(50) not null check (context in ('hub', 'ascenders', 'neothinkers', 'immortals')),
  created_at timestamptz not null default now()
);

-- 2. Indexes for performance
create index if not exists group_messages_context_idx on public.group_messages(context);
create index if not exists group_messages_user_id_idx on public.group_messages(user_id);
create index if not exists group_messages_created_at_idx on public.group_messages(created_at);

-- 3. Enable Row Level Security (RLS)
alter table public.group_messages enable row level security;

-- 4. RLS Policies for group chat access
-- Policy: Allow authenticated users to select (read) messages in their context
create policy "Authenticated users can read group messages in their context" on public.group_messages
  for select
  to authenticated
  using (
    context = coalesce(current_setting('request.jwt.claims', true)::json->>'context', '')
  );

-- Policy: Allow authenticated users to insert (send) messages in their context
create policy "Authenticated users can send group messages in their context" on public.group_messages
  for insert
  to authenticated
  with check (
    context = coalesce(current_setting('request.jwt.claims', true)::json->>'context', '')
    and user_id = auth.uid()
  );

-- Policy: Allow users to delete their own messages
create policy "Users can delete their own group messages" on public.group_messages
  for delete
  to authenticated
  using (
    user_id = auth.uid()
  );

-- Note: No update policy to prevent message edits

-- 5. Realtime support (if using Supabase Realtime)
-- No special trigger needed; table is now ready for real-time subscriptions.
