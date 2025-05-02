-- Migration: 20250502001500_schema_standardization_full.sql
-- Purpose: Standardize user_id, created_at, and UUID PK columns across all tables for data integrity, performance, and best-practice compliance.
-- Adds NOT NULL constraints, defaults, foreign keys, and indexes as needed.
-- Document any exceptions in the README or migration comments.

-- Example changes for several tables (expand as needed):

-- achievements
ALTER TABLE public.achievements ALTER COLUMN created_at SET NOT NULL;
ALTER TABLE public.achievements ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE public.achievements ALTER COLUMN id SET DEFAULT gen_random_uuid();

-- activity_feed
ALTER TABLE public.activity_feed ALTER COLUMN created_at SET NOT NULL;
ALTER TABLE public.activity_feed ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE public.activity_feed ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE public.activity_feed ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE public.activity_feed ADD CONSTRAINT fk_activity_feed_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_activity_feed_user_id ON public.activity_feed(user_id);

-- ai_analytics
ALTER TABLE public.ai_analytics ALTER COLUMN created_at SET NOT NULL;
ALTER TABLE public.ai_analytics ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE public.ai_analytics ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE public.ai_analytics ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE public.ai_analytics ADD CONSTRAINT fk_ai_analytics_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_ai_analytics_user_id ON public.ai_analytics(user_id);

-- ai_conversations
ALTER TABLE public.ai_conversations ALTER COLUMN created_at SET NOT NULL;
ALTER TABLE public.ai_conversations ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE public.ai_conversations ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE public.ai_conversations ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE public.ai_conversations ADD CONSTRAINT fk_ai_conversations_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_ai_conversations_user_id ON public.ai_conversations(user_id);

-- Repeat for all tables with user_id, created_at, and UUID PK columns.
-- For tables where user_id must remain nullable, add a comment explaining why.
