-- Migration: Create user_token_progress table for gamification, progress tracking, and personalized rewards
-- Purpose: Ensure all user token progress data is tracked in codebase for reproducible, scalable gamification and analytics
-- Affected Table: public.user_token_progress
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 01:50:00 UTC

-- 1. Create user_token_progress table
create table if not exists public.user_token_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  token_type text not null check (token_type in ('LIVE', 'LOVE', 'LIFE', 'LUCK')),
  progress_amount numeric not null default 0,
  last_updated timestamptz not null default now(),
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.user_token_progress enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own token progress)
create policy "Select own token progress (authenticated)" on public.user_token_progress for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can create their own token progress)
create policy "Insert own token progress (authenticated)" on public.user_token_progress for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own token progress)
create policy "Update own token progress (authenticated)" on public.user_token_progress for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own token progress)
create policy "Delete own token progress (authenticated)" on public.user_token_progress for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public token progress only, if desired)
create policy "Select public token progress (anon)" on public.user_token_progress for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists user_token_progress_user_id_idx on public.user_token_progress(user_id);

-- 5. Comments for documentation
comment on table public.user_token_progress is 'Tracks user progress for each gamification token type.';
comment on column public.user_token_progress.token_type is 'Type of gamification token (LIVE, LOVE, LIFE, LUCK).';
comment on column public.user_token_progress.progress_amount is 'Current progress amount for the token.';
comment on column public.user_token_progress.user_id is 'Foreign key to auth.users.';

-- End of migration
