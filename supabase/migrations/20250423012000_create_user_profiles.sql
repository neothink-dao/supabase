-- Migration: Create user_profiles table for user onboarding, personalization, and profile management
-- Purpose: Ensure all user profile data is tracked in codebase for reproducible, scalable onboarding and UX
-- Affected Table: public.user_profiles
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 01:20:00 UTC

-- 1. Create user_profiles table
create table if not exists public.user_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  display_name text not null,
  bio text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.user_profiles enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own profile)
create policy "Select own profile (authenticated)" on public.user_profiles for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can create their own profile)
create policy "Insert own profile (authenticated)" on public.user_profiles for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own profile)
create policy "Update own profile (authenticated)" on public.user_profiles for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own profile)
create policy "Delete own profile (authenticated)" on public.user_profiles for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public profiles only, if desired)
create policy "Select public profiles (anon)" on public.user_profiles for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists user_profiles_user_id_idx on public.user_profiles(user_id);

-- 5. Comments for documentation
comment on table public.user_profiles is 'Stores user profile data for onboarding, personalization, and engagement.';
comment on column public.user_profiles.display_name is 'User-chosen display name.';
comment on column public.user_profiles.bio is 'User bio or about section.';
comment on column public.user_profiles.avatar_url is 'URL to user avatar image.';
comment on column public.user_profiles.user_id is 'Foreign key to auth.users.';

-- End of migration
