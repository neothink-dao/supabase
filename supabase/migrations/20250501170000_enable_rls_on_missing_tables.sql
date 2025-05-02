-- Migration: 20250501170000_enable_rls_on_missing_tables.sql
-- Purpose: Enable Row Level Security (RLS) on all tables in the public schema that did not previously have it enabled.
-- Affected: public.schema_version, public.user_concept_progress, public.collaborative_challenges, public.session_notes, public.feedback_hub, public.feedback_ascenders, public.feedback_immortals, public.feedback_neothinkers, public.monorepo_apps, public.session_resources, public.users
-- Notes: This migration brings all tables into alignment with Supabase best practices for security and compliance.

ALTER TABLE public.schema_version ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_concept_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collaborative_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback_hub ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback_ascenders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback_immortals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedback_neothinkers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monorepo_apps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
