-- Migration: Track user_token_progress view definition for reproducibility
-- Purpose: Ensure the user_token_progress view is tracked in codebase for analytics and gamification
-- Affected Object: public.user_token_progress (view)
-- Created: 2025-04-23 02:35:00 UTC

-- 1. Create or replace the user_token_progress view
create or replace view public.user_token_progress as
 SELECT t.user_id,
    t.token_type,
    sum(t.amount) AS total_earned,
    count(*) AS transaction_count,
    max(t.created_at) AS last_earned,
    b.luck_balance,
    b.live_balance,
    b.love_balance,
    b.life_balance
   FROM (token_transactions t
     JOIN token_balances b ON ((t.user_id = b.user_id)))
  GROUP BY t.user_id, t.token_type, b.luck_balance, b.live_balance, b.love_balance, b.life_balance;

-- 2. Comments for documentation
comment on view public.user_token_progress is 'Aggregates user token progress, balances, and analytics for all gamification tokens.';

-- End of migration
