-- Migration: Reconcile user_token_progress table schema with production
-- Purpose: Bring codebase migration in sync with live DB structure for user_token_progress
-- Affected Table: public.user_token_progress
-- Created: 2025-04-23 02:30:00 UTC

-- 1. Add missing columns if not present
alter table public.user_token_progress add column if not exists total_earned bigint;
alter table public.user_token_progress add column if not exists transaction_count bigint;
alter table public.user_token_progress add column if not exists last_earned timestamptz;
alter table public.user_token_progress add column if not exists luck_balance integer;
alter table public.user_token_progress add column if not exists live_balance integer;
alter table public.user_token_progress add column if not exists love_balance integer;
alter table public.user_token_progress add column if not exists life_balance integer;

-- 2. Drop columns not in production schema (manual review required before uncommenting)
-- alter table public.user_token_progress drop column if exists id;
-- alter table public.user_token_progress drop column if exists progress_amount;
-- alter table public.user_token_progress drop column if exists created_at;
-- alter table public.user_token_progress drop column if exists last_updated;

-- 3. Add comments for documentation
comment on table public.user_token_progress is 'Tracks user token progress and balances for all gamification tokens.';
comment on column public.user_token_progress.total_earned is 'Total tokens earned by user.';
comment on column public.user_token_progress.transaction_count is 'Number of token transactions.';
comment on column public.user_token_progress.last_earned is 'Timestamp of last token earned.';
comment on column public.user_token_progress.luck_balance is 'Current LUCK token balance.';
comment on column public.user_token_progress.live_balance is 'Current LIVE token balance.';
comment on column public.user_token_progress.love_balance is 'Current LOVE token balance.';
comment on column public.user_token_progress.life_balance is 'Current LIFE token balance.';

-- 4. (Re)Add RLS if not present
alter table public.user_token_progress enable row level security;

-- 5. (Re)Add minimal RLS policies for safety (customize as needed)
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_token_progress' AND policyname = 'Allow select for authenticated') THEN
    EXECUTE 'drop policy "Allow select for authenticated" on public.user_token_progress';
  END IF;
END $$;
create policy "Allow select for authenticated" on public.user_token_progress for select to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_token_progress' AND policyname = 'Allow insert for authenticated') THEN
    EXECUTE 'drop policy "Allow insert for authenticated" on public.user_token_progress';
  END IF;
END $$;
create policy "Allow insert for authenticated" on public.user_token_progress for insert to authenticated with check (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_token_progress' AND policyname = 'Allow update for authenticated') THEN
    EXECUTE 'drop policy "Allow update for authenticated" on public.user_token_progress';
  END IF;
END $$;
create policy "Allow update for authenticated" on public.user_token_progress for update to authenticated using (true);

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'user_token_progress' AND policyname = 'Allow delete for authenticated') THEN
    EXECUTE 'drop policy "Allow delete for authenticated" on public.user_token_progress';
  END IF;
END $$;
create policy "Allow delete for authenticated" on public.user_token_progress for delete to authenticated using (true);

-- End of migration
