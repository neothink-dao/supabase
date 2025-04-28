-- Migration: Create user_segments table for advanced user targeting, personalization, and analytics
-- Purpose: Ensure all user segmentation data is tracked in codebase for reproducible, scalable analytics and UX
-- Affected Table: public.user_segments
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 01:35:00 UTC

-- 1. Create user_segments table
create table if not exists public.user_segments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  segment_key text not null, -- e.g. 'onboarding_stage', 'power_user', 'beta_tester'
  segment_value text not null, -- e.g. 'stage_1', 'yes', 'no'
  assigned_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.user_segments enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own segments)
create policy "Select own segments (authenticated)" on public.user_segments for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can create their own segment)
create policy "Insert own segment (authenticated)" on public.user_segments for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own segment)
create policy "Update own segment (authenticated)" on public.user_segments for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own segment)
create policy "Delete own segment (authenticated)" on public.user_segments for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public segments only, if desired)
create policy "Select public segments (anon)" on public.user_segments for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists user_segments_user_id_idx on public.user_segments(user_id);

-- 5. Comments for documentation
comment on table public.user_segments is 'Tracks user segmentation for advanced analytics, onboarding, and personalization.';
comment on column public.user_segments.segment_key is 'Type of segment (e.g. onboarding_stage, beta_tester, etc).';
comment on column public.user_segments.segment_value is 'Value for the segment (e.g. stage_1, yes, no).';
comment on column public.user_segments.user_id is 'Foreign key to auth.users.';

-- End of migration
