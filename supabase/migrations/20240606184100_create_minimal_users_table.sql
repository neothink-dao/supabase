-- Migration: Create minimal public.users table for foreign key dependencies
-- Created: 2025-04-22 18:41 UTC
-- Purpose: Ensure all migrations referencing public.users(id) can succeed, especially for gamification_events and other features.
-- Affected Tables: public.users
-- Special Considerations: This table is a minimal stub. If you later manage users via Supabase Auth or another system, adjust accordingly.

create table if not exists public.users (
  id uuid primary key,
  created_at timestamptz not null default now()
);

-- Enable Row Level Security (RLS) for best practice
alter table public.users enable row level security;

-- RLS Policy: Allow select for authenticated users (adjust as needed)
create policy "Allow select for authenticated users" on public.users
  for select
  to authenticated
  using (true);

-- RLS Policy: Allow insert for authenticated users (adjust as needed)
create policy "Allow insert for authenticated users" on public.users
  for insert
  to authenticated
  with check (true);

-- RLS Policy: Allow update for authenticated users (adjust as needed)
create policy "Allow update for authenticated users" on public.users
  for update
  to authenticated
  using (true);

-- RLS Policy: Allow delete for authenticated users (adjust as needed)
create policy "Allow delete for authenticated users" on public.users
  for delete
  to authenticated
  using (true);

-- NOTE: Adjust RLS policies for your production needs. This is permissive for development.
