# Supabase Database Functions Documentation

This document provides structured, best-practices documentation for all Postgres functions in the Neothink DAO Supabase database. Each function entry includes signature, purpose, security, volatility, error handling, and notes.

---

## User & Tenant Management

### `public.add_user_to_tenant(_user_id uuid, _tenant_slug text, _role text DEFAULT 'member') RETURNS boolean`
- **Purpose:** Adds a user to a tenant with a specific role. Used for multi-tenant onboarding and role assignment.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Error Handling:** Returns false on failure (e.g., user or tenant not found).
- **Notes:** Used in onboarding and tenant admin flows.

### `public.advance_user_week(p_user_id uuid, p_platform text) RETURNS boolean`
- **Purpose:** Advances a user's progress by one week on a given platform. Used for gamification and progression.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Error Handling:** Returns false on failure.
- **Notes:** Updates user progress, triggers events.

---

## Token & Reward Functions

### `public.award_message_tokens() RETURNS trigger`
- **Purpose:** Awards tokens to users when they send eligible messages. Used as a trigger on chat messages.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** To be attached as an AFTER INSERT trigger on chat messages.

### `public.award_post_tokens() RETURNS trigger`
- **Purpose:** Awards tokens to users when they create eligible posts. Used as a trigger on posts.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** To be attached as an AFTER INSERT trigger on posts.

### `public.award_tokens(p_user_id uuid, p_token_type text, p_amount integer, p_source_type text, p_source_id uuid) RETURNS void`
- **Purpose:** Awards a specific amount and type of tokens to a user, recording the source.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Used by triggers and admin actions. Updates balances and logs events.

### `public.award_zoom_attendance_tokens(attendee_id uuid, meeting_name text, token_type text DEFAULT 'LUCK', token_amount integer DEFAULT 25) RETURNS void`
- **Purpose:** Awards tokens for Zoom meeting attendance.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Called by Zoom event handlers or attendance flows.

---

## Notification & Broadcast Functions

### `public.broadcast_post() RETURNS trigger`
- **Purpose:** Broadcasts a new post event to subscribers, e.g., for real-time feeds.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Attach as trigger on posts table.

### `public.broadcast_room_message() RETURNS trigger`
- **Purpose:** Broadcasts a new room message event to subscribers.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Attach as trigger on room messages table.

---

## Validation & Utility Functions

### `public.can_earn_tokens(p_user_id uuid, p_token_type text, p_source_type text) RETURNS boolean`
- **Purpose:** Checks if a user is eligible to earn a specific type of token from a given source.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used by triggers and reward logic to prevent duplicate or ineligible awards.

### `public.check_email_exists(email text) RETURNS boolean`
- **Purpose:** Checks if an email address exists in the user table.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for registration and invitation flows.

### `public.check_platform_access(user_id uuid, platform_slug text) RETURNS boolean`
- **Purpose:** Checks if a user has access to a specific platform.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for access control and gating.

### `public.check_profile_exists(user_id uuid) RETURNS boolean`
- **Purpose:** Checks if a user profile exists for a given user_id.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for onboarding and profile validation.

### `public.check_rate_limit(p_identifier text, p_max_requests integer DEFAULT 100, p_window_seconds integer DEFAULT 60) RETURNS boolean`
- **Purpose:** Checks if an identifier (user, IP, etc.) is within allowed rate limits.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Used by API endpoints and actions to prevent abuse.

### `public.check_skill_requirements(p_user_id uuid, p_content_type text, p_content_id uuid) RETURNS TABLE(skill_name text, required_level integer, user_level integer, meets_requirement boolean)`
- **Purpose:** Returns whether a user meets skill requirements for a content item.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for adaptive learning and content gating.

### `public.check_user_exists(user_email text) RETURNS boolean`
- **Purpose:** Checks if a user exists by email.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for invitations and onboarding.

### `public.check_user_role(_user_id uuid, _role_slug text) RETURNS boolean`
- **Purpose:** Checks if a user has a specific role.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for RBAC and permission checks.

---

## Cleanup & Maintenance Functions

### `public.clean_chat_history() RETURNS trigger`
- **Purpose:** Cleans up old chat messages based on retention policy.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Attach as trigger on chat message tables.

### `public.cleanup_expired_tokens() RETURNS void`
- **Purpose:** Removes expired tokens from the token table.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Scheduled or manually invoked for housekeeping.

### `public.cleanup_old_notifications() RETURNS void`
- **Purpose:** Deletes old notifications beyond retention period.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Scheduled or manually invoked for housekeeping.

### `public.cleanup_old_rate_limits() RETURNS trigger`
- **Purpose:** Cleans up old rate limit records.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Attach as trigger on rate limits table.

### `public.cleanup_old_security_events() RETURNS trigger`
- **Purpose:** Cleans up old security event logs.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Attach as trigger on security events table.

---

## Analytics & Content Functions

### `public.get_activity_interactions(p_activity_id uuid, p_limit integer DEFAULT 20, p_offset integer DEFAULT 0) RETURNS TABLE(interaction_id uuid, user_id uuid, interaction_type text, comment_text text, created_at timestamp with time zone)`
- **Purpose:** Returns a paginated list of interactions for a given activity.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for analytics and activity feeds.

### `public.get_available_rooms(user_uuid uuid) RETURNS TABLE(id uuid, name text, description text, room_type text, created_at timestamp with time zone, created_by uuid, is_accessible boolean)`
- **Purpose:** Returns rooms available to a user.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for chat and collaboration UIs.

### `public.get_content_dependencies(p_content_type text, p_content_id uuid) RETURNS TABLE(dependency_id uuid, depends_on_type text, depends_on_id uuid, dependency_type text)`
- **Purpose:** Lists dependencies for a given content item.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for content management and publishing logic.

### `public.get_content_engagement_metrics(p_platform text) RETURNS TABLE(module_id uuid, module_title text, unique_users bigint, completions bigint, avg_completion_time_seconds double precision)`
- **Purpose:** Returns engagement metrics for content modules on a platform.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for analytics dashboards.

### `public.get_dependent_content(p_content_type text, p_content_id uuid) RETURNS TABLE(content_type text, content_id uuid, dependency_type text)`
- **Purpose:** Lists content items that depend on a given item.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for dependency analysis and publishing.

### `public.get_discover_posts(page_size integer DEFAULT 10, page_number integer DEFAULT 1, filter_token_tag text DEFAULT NULL) RETURNS TABLE(id uuid, content text, author_id uuid, platform text, section text, is_pinned boolean, engagement_count integer, created_at timestamp with time zone, token_tag text, full_name text, avatar_url text)`
- **Purpose:** Returns discoverable posts for feeds, with filtering and pagination.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for content discovery and feeds.

---

## Analytics, Recommendation, and Platform Utility Functions

### `public.get_enabled_features(p_platform text) RETURNS TABLE(feature_key text, config jsonb)`
- **Purpose:** Returns enabled features and their configs for a platform.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for feature flags and dynamic UI.

### `public.get_learning_recommendations(p_user_id uuid, p_limit integer DEFAULT 10) RETURNS TABLE(content_type text, content_id uuid, relevance_score numeric, recommendation_reason text)`
- **Purpose:** Returns learning content recommendations for a user.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for personalized learning and engagement.

### `public.get_next_lesson(user_id uuid, platform_name text) RETURNS TABLE(module_id uuid, module_title text, lesson_id uuid, lesson_title text)`
- **Purpose:** Returns the next lesson for a user on a platform.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for onboarding and learning progress.

### `public.get_pending_schedules(p_platform text) RETURNS TABLE(content_type text, content_id uuid, publish_at timestamp with time zone, unpublish_at timestamp with time zone, created_by uuid)`
- **Purpose:** Returns content items pending scheduled publish/unpublish.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for content scheduling and moderation.

### `public.get_personalized_recommendations(p_user_id uuid, p_platform text, p_limit integer DEFAULT 10) RETURNS TABLE(content_type text, content_id uuid, relevance_score numeric, recommendation_type text, factors jsonb)`
- **Purpose:** Returns personalized recommendations for a user.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for feeds, dashboards, and engagement.

### `public.get_platform_content(p_platform text, include_unpublished boolean DEFAULT false) RETURNS TABLE(module_id uuid, module_title text, module_description text, module_is_published boolean, module_created_at timestamp with time zone, module_updated_at timestamp with time zone, lesson_id uuid, lesson_title text, lesson_is_published boolean, lesson_order_index integer)`
- **Purpose:** Returns all content for a platform, with optional unpublished items.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for content management and publishing.

### `public.get_platform_customizations(p_platform text) RETURNS TABLE(component_key text, customization jsonb)`
- **Purpose:** Returns UI customizations for a platform.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for theming and platform branding.

### `public.get_platform_metrics(p_platform text, p_start_date timestamp with time zone, p_end_date timestamp with time zone) RETURNS TABLE(metric_key text, metric_value numeric, dimension_values jsonb, measured_at timestamp with time zone)`
- **Purpose:** Returns platform metrics for analytics.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for dashboards and admin analytics.

### `public.get_platform_redirect_url(platform_name text, redirect_type text) RETURNS text`
- **Purpose:** Returns a redirect URL for a platform and type.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for login, onboarding, and navigation.

### `public.get_platform_settings(p_platform text) RETURNS jsonb`
- **Purpose:** Returns settings/config for a platform.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for configuration and feature flags.

---

## Utility, Admin, and Special-Purpose Functions

### `public.get_similar_content(p_content_type text, p_content_id uuid, p_limit integer DEFAULT 5) RETURNS TABLE(similar_content_type text, similar_content_id uuid, similarity_score numeric, similarity_factors jsonb)`
- **Purpose:** Returns similar content items based on embeddings or metadata.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for recommendations and discovery.

### `public.get_user_profile(user_id uuid) RETURNS TABLE(email text, full_name text, avatar_url text, bio text, created_at timestamp with time zone)`
- **Purpose:** Returns profile information for a user.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for profile pages and onboarding.

### `public.generate_embedding(content text) RETURNS public.vector`
- **Purpose:** Generates an embedding vector for given content.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** IMMUTABLE
- **Notes:** Used for semantic search and recommendations.

### `public.generate_tenant_api_key(_tenant_id uuid, _name text, _scopes text[] DEFAULT NULL) RETURNS jsonb`
- **Purpose:** Generates an API key for a tenant, with optional scopes.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Used for platform integrations and automation.

### `public.get_user_roles(user_id uuid) RETURNS TABLE(role_slug text, tenant_id uuid, platform text)`
- **Purpose:** Returns all roles for a user across tenants and platforms.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** STABLE
- **Notes:** Used for RBAC and permission management.

### `public.flag_inactive_users() RETURNS void`
- **Purpose:** Flags users as inactive based on activity criteria.
- **Security:** SECURITY INVOKER; `search_path = ''`
- **Volatility:** VOLATILE
- **Notes:** Used for lifecycle management and analytics.

---
