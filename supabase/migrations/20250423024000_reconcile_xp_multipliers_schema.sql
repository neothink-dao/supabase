-- Migration: Reconcile xp_multipliers table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for xp_multipliers
-- Affected Table: public.xp_multipliers
-- Created: 2025-04-23 02:40:00 UTC

-- 1. Add missing columns if not present
alter table public.xp_multipliers add column if not exists event_type text not null;
alter table public.xp_multipliers add column if not exists active boolean not null default true;

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.xp_multipliers drop column if exists user_id;
-- alter table public.xp_multipliers drop column if exists reason;
-- alter table public.xp_multipliers drop column if exists valid_from;
-- alter table public.xp_multipliers drop column if exists valid_to;

-- 3. Add comments for documentation
comment on table public.xp_multipliers is 'Tracks XP multipliers for dynamic gamification scaling.';
comment on column public.xp_multipliers.event_type is 'Type of event for which multiplier applies.';
comment on column public.xp_multipliers.multiplier is 'The XP multiplier value.';
comment on column public.xp_multipliers.active is 'Whether this multiplier is currently active.';

-- 4. (Re)Add RLS if not present
alter table public.xp_multipliers enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'xp_multipliers' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.xp_multipliers';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.xp_multipliers for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'xp_multipliers' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.xp_multipliers';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.xp_multipliers for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'xp_multipliers' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.xp_multipliers';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.xp_multipliers for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'xp_multipliers' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.xp_multipliers';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.xp_multipliers for delete to authenticated using (true);

-- End of migration
