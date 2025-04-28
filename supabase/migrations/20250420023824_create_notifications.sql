-- Migration: Create notifications table for real-time user/admin notifications
-- Purpose: Enables robust notification delivery and tracking across all Neothink+ apps
-- Author: Cascade AI
-- Date: 2025-04-20T02:38:24 UTC
--
-- This migration creates the 'notifications' table in the 'public' schema, enabling real-time, cross-app notifications for users and admins.
-- It enables Row Level Security (RLS) and applies granular policies for both 'anon' and 'authenticated' roles.
--
-- Table columns:
--   id: Primary key, UUID
--   user_id: UUID of the recipient (nullable for broadcast)
--   type: Notification type (e.g., 'info', 'success', 'warning', 'error')
--   title: Short notification title
--   message: Main notification message
--   link: Optional URL for action
--   is_read: Boolean, whether the notification has been read
--   created_at: Timestamp

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  type text not null,
  title text not null,
  message text not null,
  link text,
  is_read boolean not null default false,
  created_at timestamp with time zone not null default now()
);

-- Enable Row Level Security
alter table public.notifications enable row level security;

-- Policy: Allow SELECT for authenticated users to see their own notifications
create policy "Authenticated users can select their own notifications" on public.notifications
  for select
  to authenticated
  using (user_id = auth.uid());

-- Policy: Allow INSERT for authenticated users (system or backend can insert on behalf)
create policy "Authenticated users can insert notifications" on public.notifications
  for insert
  to authenticated
  with check (user_id = auth.uid());

-- Policy: Allow UPDATE for authenticated users to mark their own notifications as read
create policy "Authenticated users can update their own notifications" on public.notifications
  for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Policy: Allow DELETE for authenticated users to delete their own notifications
create policy "Authenticated users can delete their own notifications" on public.notifications
  for delete
  to authenticated
  using (user_id = auth.uid());

-- Policy: Allow SELECT for anon users if user_id is null (broadcast/public notifications)
create policy "Anon users can select public notifications" on public.notifications
  for select
  to anon
  using (user_id is null);

-- Policy: Allow INSERT for anon users only for public notifications (user_id must be null)
create policy "Anon users can insert public notifications" on public.notifications
  for insert
  to anon
  with check (user_id is null);

-- Policy: Allow UPDATE for anon users only for public notifications
create policy "Anon users can update public notifications" on public.notifications
  for update
  to anon
  using (user_id is null)
  with check (user_id is null);

-- Policy: Allow DELETE for anon users only for public notifications
create policy "Anon users can delete public notifications" on public.notifications
  for delete
  to anon
  using (user_id is null);

-- Index for fast lookup by user and unread status
create index if not exists notifications_user_id_is_read_idx on public.notifications (user_id, is_read);
