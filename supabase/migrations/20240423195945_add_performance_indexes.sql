-- Add missing database indexes for performance optimization
-- This migration adds indexes to frequently queried columns to improve query performance

-- Header metadata
-- Purpose: Add performance-enhancing indexes to frequently queried columns
-- Affected tables: profiles, platform_access, user_roles, posts, comments, user_activity, onboarding_progress
-- Special considerations: These indexes will improve read performance but may slightly impact write performance

-- Add indexes to profiles table
comment on table public.profiles is 'User profile information';
create index if not exists idx_profiles_user_id on public.profiles (id);
create index if not exists idx_profiles_created_at on public.profiles (created_at);
create index if not exists idx_profiles_display_name on public.profiles (display_name);

-- Add indexes to platform_access table
comment on table public.platform_access is 'User access levels for different platforms';
create index if not exists idx_platform_access_user_id on public.platform_access (user_id);
create index if not exists idx_platform_access_platform_slug on public.platform_access (platform_slug);
create index if not exists idx_platform_access_user_platform on public.platform_access (user_id, platform_slug);
create index if not exists idx_platform_access_joined_at on public.platform_access (joined_at);

-- Add indexes to user_roles table
comment on table public.user_roles is 'User roles for RBAC';
create index if not exists idx_user_roles_user_id on public.user_roles (user_id);
create index if not exists idx_user_roles_role on public.user_roles (role);
create index if not exists idx_user_roles_user_role on public.user_roles (user_id, role);

-- Add indexes to posts table
comment on table public.posts is 'User posts and content';
create index if not exists idx_posts_author_id on public.posts (author_id);
create index if not exists idx_posts_created_at on public.posts (created_at);
create index if not exists idx_posts_updated_at on public.posts (updated_at);
create index if not exists idx_posts_author_created on public.posts (author_id, created_at);

-- Add indexes to comments table
comment on table public.comments is 'Comments on posts';
create index if not exists idx_comments_post_id on public.comments (post_id);
create index if not exists idx_comments_author_id on public.comments (author_id);
create index if not exists idx_comments_created_at on public.comments (created_at);
create index if not exists idx_comments_post_created on public.comments (post_id, created_at);

-- Add indexes to user_activity table
comment on table public.user_activity is 'User activity tracking';
create index if not exists idx_user_activity_user_id on public.user_activity (user_id);
create index if not exists idx_user_activity_activity_type on public.user_activity (activity_type);
create index if not exists idx_user_activity_created_at on public.user_activity (created_at);
create index if not exists idx_user_activity_user_created on public.user_activity (user_id, created_at);

-- Add indexes to onboarding_progress table
comment on table public.onboarding_progress is 'User onboarding progress tracking';
create index if not exists idx_onboarding_progress_user_id on public.onboarding_progress (user_id);
create index if not exists idx_onboarding_progress_platform_slug on public.onboarding_progress (platform_slug);
create index if not exists idx_onboarding_progress_user_platform on public.onboarding_progress (user_id, platform_slug);
create index if not exists idx_onboarding_progress_completed on public.onboarding_progress (completed);

-- Add indexes to onboarding_steps table
comment on table public.onboarding_steps is 'Individual onboarding steps';
create index if not exists idx_onboarding_steps_progress_id on public.onboarding_steps (onboarding_progress_id);
create index if not exists idx_onboarding_steps_step_number on public.onboarding_steps (step_number);
create index if not exists idx_onboarding_steps_completed_at on public.onboarding_steps (completed_at);

-- Add indexes to user_scheduling table
comment on table public.user_scheduling is 'User scheduling preferences';
create index if not exists idx_user_scheduling_user_id on public.user_scheduling (user_id);
create index if not exists idx_user_scheduling_timezone on public.user_scheduling (timezone);

-- Add indexes to appointments table
comment on table public.appointments is 'User appointments';
create index if not exists idx_appointments_start_time on public.appointments (start_time);
create index if not exists idx_appointments_end_time on public.appointments (end_time);
create index if not exists idx_appointments_status on public.appointments (status);
create index if not exists idx_appointments_time_range on public.appointments (start_time, end_time);

-- Add indexes to appointment_attendees table
comment on table public.appointment_attendees is 'Appointment attendees';
create index if not exists idx_appointment_attendees_appointment_id on public.appointment_attendees (appointment_id);
create index if not exists idx_appointment_attendees_user_id on public.appointment_attendees (user_id);
create index if not exists idx_appointment_attendees_status on public.appointment_attendees (status);
