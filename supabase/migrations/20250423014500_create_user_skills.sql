-- Migration: Create user_skills table for skill tracking, endorsements, and personalized recommendations
-- Purpose: Ensure all user skill data is tracked in codebase for reproducible, scalable analytics and UX
-- Affected Table: public.user_skills
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 01:45:00 UTC

-- 1. Create user_skills table
create table if not exists public.user_skills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  skill_name text not null,
  proficiency_level text, -- e.g. 'beginner', 'intermediate', 'expert'
  endorsed_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.user_skills enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own skills)
create policy "Select own skills (authenticated)" on public.user_skills for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can add their own skills)
create policy "Insert own skill (authenticated)" on public.user_skills for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own skills)
create policy "Update own skill (authenticated)" on public.user_skills for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own skills)
create policy "Delete own skill (authenticated)" on public.user_skills for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public skills only, if desired)
create policy "Select public skills (anon)" on public.user_skills for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists user_skills_user_id_idx on public.user_skills(user_id);

-- 5. Comments for documentation
comment on table public.user_skills is 'Tracks user skills for endorsements, recommendations, and personalization.';
comment on column public.user_skills.skill_name is 'Name of the skill.';
comment on column public.user_skills.proficiency_level is 'User-reported proficiency.';
comment on column public.user_skills.endorsed_by is 'User ID of endorser.';
comment on column public.user_skills.user_id is 'Foreign key to auth.users.';

-- End of migration
