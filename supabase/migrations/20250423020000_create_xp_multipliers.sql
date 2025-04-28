-- Migration: Create xp_multipliers table for dynamic XP scaling and advanced gamification
-- Purpose: Ensure all XP multiplier data is tracked in codebase for reproducible, scalable gamification and analytics
-- Affected Table: public.xp_multipliers
-- Special Considerations: RLS enabled, granular policies for select/insert/update/delete, covers both anon and authenticated roles
-- Created: 2025-04-23 02:00:00 UTC

-- 1. Create xp_multipliers table
create table if not exists public.xp_multipliers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  multiplier numeric not null default 1.0,
  reason text, -- e.g. 'event', 'bonus', 'admin_adjustment'
  valid_from timestamptz not null default now(),
  valid_to timestamptz,
  created_at timestamptz not null default now()
);

-- 2. Enable Row Level Security (RLS)
alter table public.xp_multipliers enable row level security;

-- 3. RLS Policies
-- Policy: Allow select for authenticated users (can view their own multipliers)
create policy "Select own multipliers (authenticated)" on public.xp_multipliers for select to authenticated using (auth.uid() = user_id);
-- Policy: Allow insert for authenticated users (can create their own multiplier)
create policy "Insert own multiplier (authenticated)" on public.xp_multipliers for insert to authenticated with check (auth.uid() = user_id);
-- Policy: Allow update for authenticated users (can update their own multiplier)
create policy "Update own multiplier (authenticated)" on public.xp_multipliers for update to authenticated using (auth.uid() = user_id);
-- Policy: Allow delete for authenticated users (can delete their own multiplier)
create policy "Delete own multiplier (authenticated)" on public.xp_multipliers for delete to authenticated using (auth.uid() = user_id);
-- Policy: Allow select for anon users (public multipliers only, if desired)
create policy "Select public multipliers (anon)" on public.xp_multipliers for select to anon using (true);

-- 4. Index for fast lookup by user_id
create index if not exists xp_multipliers_user_id_idx on public.xp_multipliers(user_id);

-- 5. Comments for documentation
comment on table public.xp_multipliers is 'Tracks XP multipliers for dynamic gamification scaling.';
comment on column public.xp_multipliers.multiplier is 'The XP multiplier value.';
comment on column public.xp_multipliers.reason is 'Reason for the multiplier (event, bonus, admin, etc).';
comment on column public.xp_multipliers.user_id is 'Foreign key to auth.users.';

-- End of migration
