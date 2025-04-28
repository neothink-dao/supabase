-- create_sessions_table.sql
-- migration to create the sessions table for scheduling functionality

-- create sessions table
create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  session_type text not null,
  scheduled_at timestamp with time zone not null,
  status text not null default 'scheduled',
  user_name text,
  user_email text,
  notes text,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

-- add comment to the table
comment on table public.sessions is 'Stores user session bookings for various value paths';

-- enable row level security
alter table public.sessions enable row level security;

-- create policies
-- users can view their own sessions
create policy "Users can view their own sessions"
  on public.sessions
  for select
  using (auth.uid() = user_id);

-- users can insert their own sessions
create policy "Users can insert their own sessions"
  on public.sessions
  for insert
  with check (auth.uid() = user_id);

-- users can update their own sessions
create policy "Users can update their own sessions"
  on public.sessions
  for update
  using (auth.uid() = user_id);

-- create index for faster queries
create index sessions_user_id_idx on public.sessions(user_id);
create index sessions_scheduled_at_idx on public.sessions(scheduled_at);
create index sessions_status_idx on public.sessions(status);

-- add realtime support
alter publication supabase_realtime add table public.sessions;
