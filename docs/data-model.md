# Data Model & Entity Relationship Diagram (ERD)

## Overview
This document describes the current data model for the Neothink DAO Supabase project. It includes:
- A high-level ERD (entity relationship diagram)
- Table-by-table explanations (purpose, relationships, key columns)
- Glossary of terms

## ERD
> _[Insert ERD diagram export or dbdiagram.io link here]_  

## Table Summaries

### Table: `public.achievements`
- **Purpose:** Stores achievement definitions for users across different platforms (e.g., badges, points, requirements).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform this achievement applies to
  - `name` (text): Achievement name
  - `description` (text): Achievement description
  - `badge_url` (text): URL for badge image
  - `points` (integer): Points awarded
  - `requirements` (jsonb): JSON structure describing requirements
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Referenced by user progress/achievement tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for gamification, extensible via requirements JSON

### Table: `public.activity_feed`
- **Purpose:** Tracks user activity for feeds (e.g., actions, content interactions, visibility).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User performing the activity
  - `platform` (text): Platform context
  - `activity_type` (text): Type of activity
  - `content_type` (text): Type of content (optional)
  - `content_id` (uuid): Related content (optional)
  - `metadata` (jsonb): Additional activity metadata
  - `visibility` (text): Who can see this activity
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users, content tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Drives feeds, notifications, analytics

### Table: `public.ai_analytics`
- **Purpose:** Stores analytics for AI events (usage, metrics, metadata) per app/user.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `event_type` (text): What event occurred
  - `app_name` (text): App context (restricted values)
  - `user_id` (uuid): User (optional)
  - `metrics` (jsonb): Collected metrics
  - `metadata` (jsonb): Additional info
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`, CHECK on `app_name`
- **Notes:** Used for AI feature tracking and reporting

### Table: `public.ai_configurations`
- **Purpose:** Stores AI model/provider configuration per platform.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform_slug` (text): Platform
  - `default_provider` (text): Default AI provider
  - `default_models` (jsonb): Default models
  - `enabled_features` (jsonb): Features enabled
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Platform tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Allows flexible AI config per platform

### Table: `public.ai_conversations`
- **Purpose:** Tracks user AI conversations (chat, context, message count).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `platform_slug` (text): Platform
  - `title` (text): Conversation title
  - `message_count` (integer): Number of messages
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users, platform tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for AI chat history, analytics

### Table: `public.ai_embeddings`
- **Purpose:** Stores vector embeddings for content (for AI search, recommendations, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_id` (uuid): Related content
  - `content_type` (text): Type of content
  - `embedding` (vector): Vector representation
  - `metadata` (jsonb): Additional metadata
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to content tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for semantic search and AI features

### Table: `public.ai_messages`
- **Purpose:** Stores messages in AI conversations (chat, assistant, system, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `conversation_id` (uuid): Related conversation
  - `role` (text): Role of message (user, assistant, etc.)
  - `content` (text): Message content
  - `token_count` (integer): Token usage (optional)
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to ai_conversations
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`, CHECK on `role`
- **Notes:** Supports AI chat, analytics

### Table: `public.ai_suggestions`
- **Purpose:** Stores AI-generated suggestions for users/content.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User (optional)
  - `app_name` (text): App context (restricted values)
  - `content_id` (uuid): Related content (optional)
  - `content_type` (text): Type of content
  - `suggestion_type` (text): Type of suggestion
  - `content` (text): Suggestion text
  - `confidence` (double): Confidence score (0-1)
  - `is_applied` (boolean): Was suggestion applied?
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to users, content tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`, CHECK on `app_name`, CHECK on `confidence`
- **Notes:** Used for AI-driven UX and recommendations

### Table: `public.ai_usage_metrics`
- **Purpose:** Tracks AI usage metrics per user/platform.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `platform_slug` (text): Platform
  - `request_count` (integer): Number of requests
  - `token_usage` (jsonb): Token usage breakdown
  - `cost` (double): Cost incurred
  - `last_used_at` (timestamp): Last usage
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for billing, analytics, quotas

### Table: `public.ai_vector_collection_mappings`
- **Purpose:** Maps documents to vector collections for AI search.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `collection_id` (uuid): Vector collection
  - `document_id` (uuid): Document
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to ai_vector_collections, ai_vector_documents
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for organizing semantic search datasets

### Table: `public.ai_vector_collections`
- **Purpose:** Stores collections of vector embeddings for organizing semantic/AI search datasets.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Collection name
  - `description` (text): Description
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Referenced by ai_vector_collection_mappings
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for grouping AI/semantic search datasets

### Table: `public.ai_vector_documents`
- **Purpose:** Stores documents with vector embeddings for AI/semantic search.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content` (text): Document content
  - `metadata` (jsonb): Metadata
  - `embedding` (vector): Vector representation
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used in ai_vector_collection_mappings
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables semantic/AI search over documents

### Table: `public.analytics_events`
- **Purpose:** Stores analytics events (user actions, platform events, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `platform` (text): Platform context
  - `event_name` (text): Name of event
  - `properties` (jsonb): Event properties
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for analytics, tracking, reporting

### Table: `public.analytics_metrics`
- **Purpose:** Stores analytics metrics (key/value pairs, dimensions, timestamps).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `metric_key` (text): Metric name
  - `metric_value` (numeric): Value
  - `dimension_values` (jsonb): Dimension breakdown
  - `measured_at` (timestamp): When measured
  - `created_at` (timestamp): Audit column
- **Relationships:** Used for analytics dashboards
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for flexible analytics reporting

### Table: `public.analytics_reports`
- **Purpose:** Stores analytics reports (type, parameters, data, creator).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `report_type` (text): Type of report
  - `parameters` (jsonb): Report parameters
  - `report_data` (jsonb): Report results
  - `created_by` (uuid): Creator
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for analytics dashboards and exports

### Table: `public.analytics_summaries`
- **Purpose:** Stores summary analytics for platforms, periods, and metrics.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `summary_type` (text): Type of summary
  - `time_period` (text): Period type (e.g., week, month)
  - `start_date`, `end_date` (date): Date range
  - `metrics` (jsonb): Aggregated metrics
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used for analytics dashboards
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for reporting, analytics

### Table: `public.ascenders_profiles`
- **Purpose:** Stores profile data specific to Ascenders platform users.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `level` (integer): User level
  - `preferences` (jsonb): User preferences
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Extends user profiles for Ascenders-specific features

### Table: `public.audit_logs`
- **Purpose:** Stores audit logs for user actions and entity changes.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `action` (text): Action performed
  - `entity_type` (text): Entity type
  - `entity_id` (uuid): Entity
  - `old_data`, `new_data` (jsonb): Change data
  - `ip_address`, `user_agent` (text): Request info
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** For compliance, audit, and security

### Table: `public.auth_logs`
- **Purpose:** Tracks authentication events and metadata.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `action` (text): Auth action
  - `platform` (text): Platform context
  - `path` (text): Path accessed
  - `ip_address`, `user_agent` (text): Request info
  - `created_at` (timestamp): Audit column
  - `details` (jsonb): Additional info
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for login security, monitoring

### Table: `public.badge_events`
- **Purpose:** Tracks events related to badge awards and actions.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `badge_id` (uuid): Badge
  - `event_type` (text): Type of event
  - `metadata` (jsonb): Event metadata
  - `created_at` (timestamp): Audit column
  - `simulation_run_id` (text): Simulation context
- **Relationships:** FK to users, badges
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for gamification, analytics

### Table: `public.badges`
- **Purpose:** Defines badge types, criteria, and NFT support for platform gamification.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Badge name
  - `description` (text): Description
  - `role` (text): Associated role
  - `criteria` (jsonb): Award criteria
  - `nft_url` (text): NFT image/asset URL
  - `created_at` (timestamp): Audit column
- **Relationships:** Referenced by badge_events
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports NFT/crypto badge rewards

### Table: `public.census_snapshots`
- **Purpose:** Stores periodic snapshots of population, assets, and activity for a given scope (e.g., DAO, platform).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `scope` (text): Scope type
  - `scope_id` (uuid): Scope reference
  - `population` (integer): Population count
  - `assets` (numeric): Asset value
  - `activity_count` (integer): Activity count
  - `snapshot_at` (timestamp): Snapshot time
  - `metadata` (jsonb): Additional data
  - `simulation_run_id` (text): Simulation context
- **Relationships:** Used in analytics and reporting
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for historical analytics and simulations

### Table: `public.chat_history`
- **Purpose:** Stores chat messages and embeddings for AI/chatbot interactions across apps.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `app_name` (text): App context (hub, ascenders, etc.)
  - `message` (text): Message content
  - `role` (text): Message role (user, assistant)
  - `embedding` (vector): Vector embedding
  - `metadata` (jsonb): Additional metadata
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; checks on `app_name`, `role`
- **Notes:** Used for chatbots, AI analytics, semantic search

### Table: `public.chat_messages`
- **Purpose:** Stores individual chat messages within conversations, supporting multi-role (user, assistant, system, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `conversation_id` (uuid): Conversation reference
  - `user_id` (uuid): User (nullable for system messages)
  - `role` (text): Message role (user, assistant, system)
  - `content` (text): Message content
  - `metadata` (jsonb): Additional data
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to conversations, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `role`
- **Notes:** Supports chat UI, AI, and system messaging

### Table: `public.chat_participants`
- **Purpose:** Maps users to chat rooms for group and direct chat membership.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `room_id` (uuid): Chat room reference
  - `user_id` (uuid): User
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to chat_rooms, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for access control and membership in chat

### Table: `public.chat_rooms`
- **Purpose:** Stores chat room metadata for group and direct chats.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Room name (optional)
  - `is_group` (boolean): Is group chat
  - `platform` (text): Platform context
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used by chat_participants, chat_messages
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports group chat and platform-specific rooms

### Table: `public.collaboration_bonuses`
- **Purpose:** Tracks bonuses awarded to users for group actions and collaboration.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `group_action_id` (uuid): Group action reference
  - `user_id` (uuid): User awarded
  - `bonus_amount` (numeric): Bonus amount
  - `awarded_at` (timestamp): Award date
- **Relationships:** FK to group actions, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Incentivizes collaboration and group achievements

### Table: `public.collaborative_challenges`
- **Purpose:** Stores collaborative challenges for users/groups with participation and progress tracking.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Challenge title
  - `description` (text): Challenge description
  - `instructions` (text): Participation instructions
  - `created_by` (uuid): Creator
  - `created_at` (timestamp): Creation date
  - `start_date`, `end_date` (timestamp): Challenge window
  - `max_participants` (integer): Max allowed
  - `current_participants` (integer): Current count
  - `status` (text): Challenge status
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for group events, gamification, and community engagement

### Table: `public.communications`
- **Purpose:** Stores direct messages and notifications between users.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `sender_id` (uuid): Sender user
  - `receiver_id` (uuid): Receiver user
  - `content` (text): Message content
  - `context` (varchar): Message context/category
  - `created_at` (timestamp): Sent time
  - `read_at` (timestamp): Read time
  - `attachments` (jsonb): File or media attachments
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for in-app messaging and notifications

### Table: `public.community_features`
- **Purpose:** Defines features available to communities, including access and platform scope.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Feature name
  - `description` (text): Description
  - `platform` (text): Platform context
  - `type` (text): Feature type
  - `access_level` (text): Access required
  - `enabled` (boolean): Feature enabled
  - `created_at` (timestamp): Audit column
- **Relationships:** Used by community modules
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Feature flagging and modularity for communities

### Table: `public.concept_relationships`
- **Purpose:** Stores relationships between concepts, including type and strength.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `source_concept_id` (uuid): Source concept
  - `target_concept_id` (uuid): Target concept
  - `relationship_type` (text): Type of relationship
  - `relationship_strength` (integer): Strength of relationship
  - `explanation` (text): Explanation of relationship
- **Relationships:** FK to concepts
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for knowledge graphs, semantic linking

### Table: `public.concepts`
- **Purpose:** Stores concepts for knowledge management, learning, and semantic linking.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Concept title
  - `description` (text): Description
  - `category` (text): Category
  - `importance_level` (integer): Importance
  - `prerequisite_concepts` (text[]): Prerequisites
  - `related_concepts` (text[]): Related concepts
  - `application_examples` (text[]): Examples
  - `created_at` (timestamp): Audit column
  - `tenant_slug` (text): Tenant/organization
  - `author_id` (uuid): Author
- **Relationships:** FK to users, tenants
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for courses, knowledge graphs, and learning paths

### Table: `public.content`
- **Purpose:** Stores content pages, articles, and structured content for the platform.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Content title
  - `slug` (text): URL slug
  - `content` (text): Main content body
  - `platform` (text): Platform context
  - `route`, `subroute` (text): Routing info
  - `content_data` (jsonb): Structured content data
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used by content categories, navigation, etc.
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for CMS, documentation, and dynamic pages

### Table: `public.content_categories`
- **Purpose:** Stores categories for organizing content and navigation.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Category name
  - `slug` (text): URL slug
  - `description` (text): Description
  - `created_at` (timestamp): Audit column
- **Relationships:** Used by content, navigation
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables content grouping, filtering, and navigation

### Table: `public.content_content_tags`
- **Purpose:** Join table mapping content items to tags for categorization and filtering.
- **Key Columns:**
  - `content_id` (uuid): Content reference
  - `tag_id` (uuid): Tag reference
- **Relationships:** FK to content, tags
- **RLS:** [To be documented in policies.md]
- **Indexes:** Composite PK (content_id, tag_id)
- **Notes:** Enables many-to-many tagging of content

### Table: `public.content_dependencies`
- **Purpose:** Tracks dependencies between content items for sequencing and unlocking.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content
  - `content_id` (uuid): Content reference
  - `depends_on_type` (text): Dependent content type
  - `depends_on_id` (uuid): Dependent content reference
  - `dependency_type` (text): Type of dependency
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to content
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for module sequencing, prerequisites, and gating

### Table: `public.content_modules`
- **Purpose:** Stores modules for structured content delivery, such as courses or lessons.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `title` (text): Module title
  - `description` (text): Description
  - `order_index` (integer): Ordering
  - `is_published` (boolean): Published flag
  - `metadata` (jsonb): Additional data
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used by content, navigation, learning paths
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables modular, flexible content structures

### Table: `public.content_schedule`
- **Purpose:** Schedules content for publishing/unpublishing on the platform.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content
  - `content_id` (uuid): Content reference
  - `platform` (text): Platform context
  - `publish_at` (timestamp): Scheduled publish time
  - `unpublish_at` (timestamp): Scheduled unpublish time
  - `created_by` (uuid): Creator
  - `created_at`, `updated_at` (timestamp): Audit columns
  - `status` (text): Schedule status
- **Relationships:** FK to content, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables timed content releases and expirations

### Table: `public.content_similarity`
- **Purpose:** Stores similarity scores between content items for recommendations and discovery.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content
  - `content_id` (uuid): Content reference
  - `similar_content_type` (text): Similar content type
  - `similar_content_id` (uuid): Similar content reference
  - `similarity_score` (numeric): Score
  - `similarity_factors` (jsonb): Factors contributing to similarity
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to content
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for recommendations, related content, and search

### Table: `public.content_tags`
- **Purpose:** Stores tags for categorizing and filtering content.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Tag name
  - `slug` (text): URL slug
  - `created_at` (timestamp): Audit column
- **Relationships:** Used by content, content_content_tags
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables flexible tagging and search

### Table: `public.content_versions`
- **Purpose:** Tracks versions of content for editing, review, and publishing workflows.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content
  - `content_id` (uuid): Content reference
  - `version_number` (integer): Version
  - `title` (text): Version title
  - `content` (text): Version content
  - `description` (text): Description
  - `metadata` (jsonb): Additional data
  - `created_by` (uuid): Author
  - `created_at` (timestamp): Created
  - `status` (text): Status (draft, published, etc.)
  - `review_notes` (text): Notes from review
  - `reviewed_by` (uuid): Reviewer
  - `reviewed_at` (timestamp): Review date
- **Relationships:** FK to content, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables editorial workflow, versioning, and audit

### Table: `public.content_workflow`
- **Purpose:** Manages workflow status, assignment, and review for content items.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content
  - `content_id` (uuid): Content reference
  - `platform` (text): Platform context
  - `current_status` (text): Workflow status
  - `assigned_to` (uuid): Assigned user
  - `review_notes` (text): Review notes
  - `due_date` (timestamp): Due date
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to content, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports editorial, review, and publishing workflows

### Table: `public.content_workflow_history`
- **Purpose:** Tracks status changes and history for content workflow items.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `workflow_id` (uuid): Workflow reference
  - `previous_status` (text): Previous status
  - `new_status` (text): New status
  - `changed_by` (uuid): User who changed status
  - `notes` (text): Change notes
  - `created_at` (timestamp): Change time
- **Relationships:** FK to content_workflow, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables audit trail for workflow and publishing

### Table: `public.contextual_identities`
- **Purpose:** Stores user identities/nicknames per context (workspace, group, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `context` (varchar): Context (e.g., workspace)
  - `display_name` (varchar): Display name
  - `avatar_url` (text): Avatar image
  - `bio` (text): Bio/description
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables flexible identities for multi-context platforms

### Table: `public.conversations`
- **Purpose:** Tracks user conversations for chat and AI features across apps.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `app_name` (text): App context (hub, ascenders, etc.)
  - `title` (text): Conversation title
  - `metadata` (jsonb): Additional metadata
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `app_name`
- **Notes:** Used for chat, AI, and conversation history

### Table: `public.courses`
- **Purpose:** Stores course definitions for learning, training, or onboarding content.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Course title
  - `description` (text): Description
  - `platform` (text): Platform context
  - `section` (text): Section/category
  - `cover_image` (text): Cover image URL
  - `duration_minutes` (integer): Duration
  - `level` (text): Difficulty/level
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used by modules, enrollments, etc.
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for e-learning, onboarding, and certification

### Table: `public.crowdfunding`
- **Purpose:** Tracks crowdfunding contributions for proposals and teams.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `team_id` (uuid): Team reference
  - `proposal_id` (uuid): Proposal reference
  - `user_id` (uuid): Contributor
  - `amount` (numeric): Contribution amount
  - `contributed_at` (timestamp): Contribution time
- **Relationships:** FK to teams, proposals, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports funding, transparency, and rewards

### Table: `public.csrf_tokens`
- **Purpose:** Stores CSRF tokens for user sessions to prevent cross-site request forgery.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `token_hash` (text): Hashed token
  - `user_id` (uuid): User (nullable for guest tokens)
  - `user_agent` (text): User agent
  - `expires_at` (timestamp): Expiry
  - `created_at` (timestamp): Creation time
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for session security and CSRF prevention

### Table: `public.data_transfer_logs`
- **Purpose:** Logs data import/export operations for audit and compliance.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `operation_type` (varchar): Import/export
  - `file_name` (varchar): File name
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports data governance and tracking

### Table: `public.discussion_posts`
- **Purpose:** Stores posts for threaded discussions, forums, or topics.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `topic_id` (uuid): Discussion topic reference
  - `parent_post_id` (uuid): Parent post for replies
  - `user_id` (uuid): Author
  - `content` (text): Post content
  - `created_at` (timestamp): Created
  - `upvotes`, `downvotes` (integer): Voting
  - `related_concepts` (text[]): Linked concepts
  - `tenant_slug` (text): Tenant/organization
- **Relationships:** FK to topics, users, concepts
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables threaded discussions, voting, and knowledge linking

### Table: `public.discussion_topics`
- **Purpose:** Stores topics for discussions, forums, or knowledge sharing.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Topic title
  - `description` (text): Description
  - `created_by` (uuid): Creator
  - `created_at` (timestamp): Created
- **Relationships:** FK to users; referenced by posts
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Organizes discussion threads and forums

### Table: `public.documentation`
- **Purpose:** Stores documentation pages and content for the platform.
- **Key Columns:**
  - `id` (integer, PK): Unique identifier
  - `title` (text): Page title
  - `content` (text): Page content
  - `created_at` (timestamp): Created
- **Relationships:** Used by navigation, search
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for in-app and public documentation

### Table: `public.email_events`
- **Purpose:** Tracks email events such as delivery, opens, clicks, and bounces.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `email_type` (text): Type of email
  - `event_type` (text): Event (open, click, etc.)
  - `metadata` (jsonb): Event metadata
  - `created_at` (timestamp): Event time
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for analytics, deliverability, and compliance

### Table: `public.email_templates`
- **Purpose:** Stores reusable email templates for transactional and marketing emails.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Template name
  - `subject` (text): Email subject
  - `html_content` (text): HTML body
- **Relationships:** Used by email events, campaigns
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables consistent, branded communications

### Table: `public.error_logs`
- **Purpose:** Captures error logs for monitoring, debugging, and compliance.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `error_type` (text): Type/category
  - `error_message` (text): Error message
  - `stack_trace` (text): Stack trace
  - `context` (jsonb): Additional context
  - `timestamp` (timestamp): When error occurred
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables error monitoring, alerting, and audit

### Table: `public.event_attendees`
- **Purpose:** Tracks users attending events, including RSVP and participation status.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `event_id` (uuid): Event reference
  - `user_id` (uuid): User
  - `status` (text): RSVP/attendance status
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to events, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports event management, invitations, and analytics

### Table: `public.event_registrations`
- **Purpose:** Tracks user registrations for events.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `event_id` (uuid): Event
  - `registered_at` (timestamp): Registration time
- **Relationships:** FK to users, events
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Used for event signups, capacity tracking, and analytics

### Table: `public.events`
- **Purpose:** Stores event definitions, metadata, and scheduling.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Event title
  - `description` (text): Description
  - `host_id` (uuid): Host user
- **Relationships:** FK to users (host), referenced by attendees, registrations
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables event management, invitations, and scheduling

### Table: `public.feature_flags`
- **Purpose:** Stores feature flag configurations for platform and app features.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `feature_key` (text): Feature key
  - `is_enabled` (boolean): Feature enabled
  - `config` (jsonb): Additional config
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables feature toggling, A/B testing, and gradual rollout

### Table: `public.feedback`
- **Purpose:** Stores user feedback for apps and platform features.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User (nullable for anonymous)
  - `app_name` (text): App context
  - `content` (text): Feedback content
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports product improvement and user engagement

### Table: `public.feedback_ascenders`
- **Purpose:** Stores feedback specific to the Ascenders app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User (nullable)
  - `app_name` (text): App context (should be 'ascenders')
  - `content` (text): Feedback content
  - `sentiment` (double precision): Sentiment score
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Partitioned for app-specific feedback analytics

### Table: `public.feedback_hub`
- **Purpose:** Stores feedback specific to the Hub app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User (nullable)
  - `app_name` (text): App context (should be 'hub')
  - `content` (text): Feedback content
  - `sentiment` (double precision): Sentiment score
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Partitioned for app-specific feedback analytics

### Table: `public.feedback_immortals`
- **Purpose:** Stores feedback specific to the Immortals app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User (nullable)
  - `app_name` (text): App context (should be 'immortals')
  - `content` (text): Feedback content
  - `sentiment` (double precision): Sentiment score
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Partitioned for app-specific feedback analytics

### Table: `public.feedback_neothinkers`
- **Purpose:** Stores feedback specific to the Neothinkers app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User (nullable)
  - `app_name` (text): App context (should be 'neothinkers')
  - `content` (text): Feedback content
  - `sentiment` (double precision): Sentiment score
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Partitioned for app-specific feedback analytics

### Table: `public.fibonacci_token_rewards`
- **Purpose:** Tracks token rewards based on Fibonacci logic for user actions and simulations.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `action_id` (uuid): Action reference
  - `team_id` (uuid): Team reference
  - `tokens_awarded` (numeric): Tokens awarded
  - `reward_type` (text): Type of reward
  - `awarded_at` (timestamp): Award date
  - `simulation_run_id` (text): Simulation run
- **Relationships:** FK to users, actions, teams
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports gamification, simulation, and reward analytics

### Table: `public.file_uploads`
- **Purpose:** Tracks user file uploads and metadata for resources across the platform.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `url` (text): File URL
  - `pathname` (text): Pathname
  - `content_type` (text): MIME type
  - `size` (integer): File size
  - `provider` (text): Storage provider
  - `title` (text): Title
  - `description` (text): Description
  - `resource_type` (text): Linked resource type
  - `resource_id` (text): Linked resource ID
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users; links to other resources
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `provider`
- **Notes:** Supports uploads, attachments, and storage integrations

### Table: `public.flow_templates`
- **Purpose:** Stores workflow or automation templates as reusable JSON structures.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Template name
  - `description` (text): Description
  - `template_data` (jsonb): Template structure/data
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables workflow automation and process standardization

### Table: `public.gamification_events`
- **Purpose:** Tracks gamification events, token awards, and simulation runs.
- **Key Columns:**
  - `id` (bigint, PK): Unique identifier
  - `user_id` (uuid): User
  - `persona` (text): Persona context
  - `site` (text): Site/platform
  - `event_type` (text): Event type
  - `token_type` (text): Token category (LIVE/LOVE/LIFE/LUCK)
  - `amount` (numeric): Amount awarded
  - `metadata` (jsonb): Additional metadata
  - `created_at` (timestamp): Event time
  - `simulation_run_id` (text): Simulation run
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; checks on `amount`, `token_type`
- **Notes:** Enables gamification, analytics, and reward logic

### Table: `public.governance_proposals`
- **Purpose:** Stores governance proposals submitted by users for voting and review.
- **Key Columns:**
  - `proposal_id` (uuid, PK): Unique identifier
  - `user_id` (uuid): Proposer
  - `title` (varchar): Proposal title
  - `description` (text): Proposal details
  - `stake` (integer): Staked tokens
  - `status` (text): Proposal status (default 'pending')
  - `council_term` (integer): Council term
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `proposal_id`; check on `stake`
- **Notes:** Enables decentralized governance and decision making

### Table: `public.group_actions`
- **Purpose:** Logs actions performed by teams/groups for audit and analytics.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `team_id` (uuid): Team reference
  - `action_type` (text): Action type
  - `performed_by` (uuid): User who performed action
  - `metadata` (jsonb): Additional data
  - `performed_at` (timestamp): Action time
- **Relationships:** FK to teams, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports group activity tracking and transparency

### Table: `public.health_integrations`
- **Purpose:** Stores external health app integrations and tokens for users.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `provider` (varchar): Integration provider
  - `provider_user_id` (varchar): External user ID
  - `access_token` (text): OAuth access token
  - `refresh_token` (text): OAuth refresh token
  - `token_expires_at` (timestamp): Token expiry
  - `is_active` (boolean): Active status
  - `metadata` (jsonb): Additional data
  - `last_sync` (timestamp): Last sync time
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables health data sync, OAuth, and provider integrations

### Table: `public.health_metrics`
- **Purpose:** Stores user health metrics from integrations and manual entry.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `integration_id` (uuid): Health integration reference
  - `metric_type` (varchar): Type of metric (e.g., steps, heart rate)
  - `value` (numeric): Metric value
  - `unit` (varchar): Unit of measurement
  - `timestamp` (timestamp): Time recorded
  - `source` (varchar): Data source
  - `metadata` (jsonb): Additional data
  - `created_at` (timestamp): Audit column
- **Relationships:** FK to users, integrations
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables health analytics, reporting, and integrations

### Table: `public.hub_profiles`
- **Purpose:** Stores user profile preferences for the Hub app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `preferences` (jsonb): User preferences
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports personalized experience in the Hub app

### Table: `public.immortals_profiles`
- **Purpose:** Stores user profile and preferences for the Immortals app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `level` (integer): User level
  - `preferences` (jsonb): User preferences
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports gamified experience and personalization in Immortals

### Table: `public.integration_settings`
- **Purpose:** Stores user settings for integration sync and reporting.
- **Key Columns:**
  - `user_id` (uuid, PK): User
  - `auto_sync` (boolean): Auto-sync enabled
  - `sync_frequency` (varchar): Sync frequency (hourly, daily, weekly, manual)
  - `notify_on_sync` (boolean): Notify on sync
  - `include_in_reports` (boolean): Include data in reports
  - `last_updated` (timestamp): Last updated
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `user_id`; check on `sync_frequency`
- **Notes:** Supports granular user control of integrations

### Table: `public.invite_codes`
- **Purpose:** Stores invite codes for onboarding, referrals, and gated access.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `code` (text): Invite code
  - `created_by` (uuid): Creator
  - `max_uses` (integer): Maximum allowed uses
  - `uses` (integer): Uses so far
  - `expires_at` (timestamp): Expiry date
  - `created_at` (timestamp): Creation time
  - `active` (boolean): Is code active
- **Relationships:** FK to users (creator)
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables controlled access, campaigns, and referrals

### Table: `public.journal_entries`
- **Purpose:** Stores user journal entries for reflection, notes, and tracking.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `created_at` (timestamp): Created
  - `title` (text): Entry title
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports journaling, self-tracking, and personal analytics

### Table: `public.learning_path_items`
- **Purpose:** Stores items (modules, content, etc.) in a learning path sequence.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `path_id` (uuid): Learning path reference
  - `content_type` (text): Type of content
  - `content_id` (uuid): Content reference
  - `order_index` (integer): Ordering
  - `is_required` (boolean): Is required for completion
  - `metadata` (jsonb): Additional metadata
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to learning paths, content
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports curriculum, onboarding, and guided learning

### Table: `public.learning_paths`
- **Purpose:** Stores learning paths/curricula for guided education and onboarding.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `path_name` (text): Path name
  - `description` (text): Description
  - `difficulty_level` (text): Difficulty level
  - `prerequisites` (jsonb): Prerequisites
  - `metadata` (jsonb): Additional metadata
  - `created_at` (timestamp): Created
- **Relationships:** Referenced by learning_path_items
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables structured learning, onboarding, and upskilling

### Table: `public.learning_progress`
- **Purpose:** Tracks user progress on learning content and modules.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `content_type` (text): Content type
  - `content_id` (uuid): Content reference
  - `status` (text): Progress status
  - `progress_percentage` (integer): Percentage complete
  - `started_at` (timestamp): Start time
  - `completed_at` (timestamp): Completion time
  - `last_interaction_at` (timestamp): Last interaction
  - `metadata` (jsonb): Additional metadata
- **Relationships:** FK to users, content
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables personalized learning analytics and reporting

### Table: `public.learning_recommendations`
- **Purpose:** Stores personalized content recommendations for users.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `content_type` (text): Type of recommended content
  - `content_id` (uuid): Content reference
  - `relevance_score` (numeric): Recommendation score
  - `recommendation_reason` (text): Explanation
  - `created_at` (timestamp): Created
  - `expires_at` (timestamp): Expiry
- **Relationships:** FK to users, content
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables AI-driven learning and adaptive content

### Table: `public.lessons`
- **Purpose:** Stores lesson content within modules for courses and learning paths.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `module_id` (uuid): Module reference
  - `title` (text): Lesson title
  - `content` (text): Lesson content
  - `order_index` (integer): Ordering
  - `is_published` (boolean): Published status
  - `metadata` (jsonb): Additional metadata
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to modules
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports modular learning and content sequencing

### Table: `public.login_attempts`
- **Purpose:** Tracks login attempts for security, rate limiting, and analytics.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `email` (text): Email address
  - `ip_address` (text): IP address
  - `attempt_count` (integer): Number of attempts
  - `last_attempt_at` (timestamp): Last attempt time
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables brute-force protection and login analytics

### Table: `public.mark_hamilton_content`
- **Purpose:** Stores curated content related to Mark Hamilton for platform features.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Content title
  - `content_type` (text): Type/category
  - `content_data` (jsonb): Content body/data
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports special content modules and thematic features

### Table: `public.messages`
- **Purpose:** Stores chat messages for rooms, direct messages, and group chats.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `room_id` (uuid): Room reference
  - `sender_id` (uuid): Sender user
  - `content` (text): Message content
  - `is_read` (boolean): Read status
  - `created_at` (timestamp): Sent time
  - `token_tag` (text): Token type (optional, LUCK/LIVE/LOVE/LIFE)
  - `reward_processed` (boolean): Reward status
  - `room_type` (text): Room type
- **Relationships:** FK to rooms, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `token_tag`
- **Notes:** Supports chat, notifications, and tokenized interactions

### Table: `public.modules`
- **Purpose:** Stores course modules, which group lessons for structured learning.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `course_id` (uuid): Course reference
  - `title` (text): Module title
  - `description` (text): Module description
  - `sequence_order` (integer): Order in course
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to courses; referenced by lessons
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables curriculum structure and lesson grouping

### Table: `public.monorepo_apps`
- **Purpose:** Stores metadata and configuration for apps in a monorepo architecture.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `app_name` (varchar): App name
  - `app_slug` (varchar): App slug
  - `description` (text): Description
  - `vercel_project_id` (varchar): Vercel project ID
  - `vercel_project_url` (varchar): Vercel project URL
  - `config` (jsonb): App config
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables management of multiple apps in a single codebase

### Table: `public.neothinkers_profiles`
- **Purpose:** Stores user profile and preferences for the Neothinkers app.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `level` (integer): User level
  - `preferences` (jsonb): User preferences
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports gamified experience and personalization in Neothinkers

### Table: `public.notification_preferences`
- **Purpose:** Stores user notification preferences for email, push, and in-app alerts.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User
  - `platform` (text): Platform context
  - `email_enabled` (boolean): Email notifications enabled
  - `push_enabled` (boolean): Push notifications enabled
  - `in_app_enabled` (boolean): In-app notifications enabled
  - `preferences` (jsonb): Additional preferences
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports granular, multi-channel notification management

### Table: `public.notification_templates`
- **Purpose:** Stores templates for notifications, supporting multiple platforms and message types.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `template_key` (text): Template key/identifier
  - `title_template` (text): Title template
  - `body_template` (text): Body template
  - `metadata` (jsonb): Additional metadata
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables dynamic, localized, and reusable notification content

### Table: `public.notifications`
- **Purpose:** Stores notifications sent to users, supporting multi-platform delivery and prioritization.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): Target user
  - `platform` (text): Platform context
  - `title` (text): Notification title
  - `body` (text): Notification body
  - `metadata` (jsonb): Additional metadata
  - `is_read` (boolean): Read status
  - `created_at`, `updated_at` (timestamp): Audit columns
  - `type` (text): Notification type
  - `priority` (text): Priority (low/medium/high/urgent)
  - `target_platforms` (text[]): Platforms to send to
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `priority`
- **Notes:** Enables targeted, prioritized, and multi-channel notifications

### Table: `public.participation`
- **Purpose:** Tracks user participation in platform activities for engagement and rewards.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `platform` (text): Platform context
  - `activity_type` (text): Type of activity
  - `points` (integer): Points earned
  - `metadata` (jsonb): Additional data
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports gamification, analytics, and user rewards

### Table: `public.performance_metrics`
- **Purpose:** Stores performance metrics for users, features, or system health.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `metric_name` (text): Name of metric
  - `metric_value` (numeric): Value
  - `metric_unit` (text): Unit (optional)
  - `timestamp` (timestamp): Recorded time
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables monitoring and analytics for optimization

### Table: `public.permissions`
- **Purpose:** Stores permission definitions for access control and role management.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Permission name
  - `slug` (text): Unique slug
  - `description` (text): Description
  - `category` (text): Category/group
  - `scope` (text): Scope of permission
  - `created_at` (timestamp): Creation time
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; unique on `slug`
- **Notes:** Enables RBAC and fine-grained access policies

### Table: `public.platform_access`
- **Purpose:** Tracks which platforms each user has access to within the ecosystem.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `platform_slug` (text): Platform identifier
  - `granted_at` (timestamp): Access granted time
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables multi-platform access control and auditing

### Table: `public.platform_customization`
- **Purpose:** Stores UI and feature customizations for each platform and component.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform identifier
  - `component_key` (text): UI/component key
  - `customization` (jsonb): Customization data
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables white-labeling and platform-specific UI/feature adjustments

### Table: `public.platform_settings`
- **Purpose:** Stores platform-wide settings and configuration as JSON.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform identifier
  - `settings` (jsonb): Settings/configuration
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Centralizes configuration for platform management

### Table: `public.platform_state`
- **Purpose:** Stores per-user, per-platform state and settings as key-value pairs.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `platform` (text): Platform identifier
  - `key` (text): State key
  - `value` (jsonb): State value
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables persistent, user-specific platform state

### Table: `public.popular_searches`
- **Purpose:** Tracks popular search queries and their frequency for analytics and UX.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `query` (text): Search query
  - `total_searches` (integer): Total number of searches
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `query`
- **Notes:** Supports trending search analytics and suggestions

### Table: `public.post_comments`
- **Purpose:** Stores comments on discussion posts for community engagement.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `post_id` (uuid): Parent post reference
  - `author_id` (uuid): Comment author
  - `content` (text): Comment content
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to posts, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables threaded discussions and social interaction

### Table: `public.post_likes`
- **Purpose:** Tracks which users have liked which posts for engagement metrics.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `post_id` (uuid): Post reference
  - `user_id` (uuid): User reference
  - `created_at` (timestamp): Like time
- **Relationships:** FK to posts, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; unique on (`post_id`, `user_id`)
- **Notes:** Enables like counts and user engagement tracking

### Table: `public.post_reactions`
- **Purpose:** Tracks user reactions (like/love/celebrate/insightful) to posts for richer engagement.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `post_id` (uuid): Post reference
  - `user_id` (uuid): User reference
  - `reaction_type` (text): Reaction type (like/love/celebrate/insightful)
  - `created_at` (timestamp): Reaction time
- **Relationships:** FK to posts, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `reaction_type`
- **Notes:** Enables nuanced social feedback and analytics

### Table: `public.posts`
- **Purpose:** Stores discussion posts for forums, announcements, and social feeds.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `author_id` (uuid): Author user
  - `content` (text): Post content
  - `platform` (text): Platform context
  - `section` (text): Section/category
  - `is_pinned` (boolean): Pin status
  - `engagement_count` (integer): Engagement metric
  - `created_at`, `updated_at` (timestamp): Audit columns
  - `token_tag` (text): Token type (optional, LUCK/LIVE/LOVE/LIFE)
  - `reward_processed` (boolean): Reward status
  - `visibility` (text): Visibility (default: public)
- **Relationships:** FK to users; referenced by comments, likes, reactions
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `token_tag`
- **Notes:** Enables community discussion, announcements, and tokenized rewards

### Table: `public.profiles`
- **Purpose:** Stores user profile information for authentication, personalization, and display.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier (matches auth user)
  - `email` (text): User email
  - `full_name` (text): Full name
  - `avatar_url` (text): Avatar/profile image URL
  - `bio` (text): User bio
  - `created_at` (timestamp): Profile creation time
- **Relationships:** 1:1 with auth.users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; unique on `email`
- **Notes:** Central profile for user identity and personalization

#### Additional Profile Columns
- `updated_at` (timestamp): Last update
- `is_ascender`, `is_neothinker`, `is_immortal`, `is_guardian` (boolean): Membership flags
- `guardian_since` (timestamp): Guardian start
- `subscription_status`, `subscription_tier` (text): Subscription info
- `subscription_period_start`, `subscription_period_end` (timestamp): Subscription period
- `platforms`, `subscribed_platforms` (text[]): Platform access
- `role` (text): User role (default: user)
- `value_paths` (text[]): Value path IDs (prosperity, happiness, longevity)
- `has_scheduled_session` (boolean): Scheduled session flag
- `first_name` (text): For greetings
- `onboarding_progress` (text[]): Onboarding steps
- `onboarding_current_step` (text): Current onboarding step
- `onboarding_completed` (boolean): Onboarding complete
- `onboarding_completed_at` (timestamp): Onboarding completion time

### Table: `public.proposals`
- **Purpose:** Stores governance or project proposals, including creator and team association.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `team_id` (uuid): Team reference
  - `created_by` (uuid): Creator user
  - `title` (text): Proposal title
  - `description` (text): Proposal description
  - `status` (text): Proposal status (e.g., pending, approved, rejected)
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to teams, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables collaborative decision-making and governance workflows

### Table: `public.teams`
- **Purpose:** Stores team definitions, including members, roles, and permissions.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Team name
  - `description` (text): Team description
  - `created_by` (uuid): Creator user
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users (creator); referenced by team_members
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables team management, collaboration, and access control

### Table: `public.team_members`
- **Purpose:** Maps users to teams with roles and permissions.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `team_id` (uuid): Team reference
  - `user_id` (uuid): User
  - `role` (text): Role within the team
  - `permissions` (jsonb): Permissions granted
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to teams, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables team membership, roles, and access control

### Table: `public.team_memberships`
- **Purpose:** Links users to teams, recording their membership and join date within the team.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `team_id` (uuid): Team reference
  - `user_id` (uuid): User reference
  - `joined_at` (timestamp): Membership start date
- **Relationships:** FK to teams, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `team_id`, `user_id`
- **Notes:** Enables team membership, collaboration, and permissions

### Table: `public.users`
- **Purpose:** Stores user authentication and profile information.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `email` (text): User email
  - `password_hash` (text): Hashed password
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** 1:1 with profiles; referenced by many tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; unique on `email`
- **Notes:** Central user authentication and identity

### Table: `public.rate_limits`
- **Purpose:** Tracks API or action rate limits for identifiers (users, IPs, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `identifier` (text): Identifier (user, IP, etc.)
  - `count` (integer): Number of actions in window
  - `window_start` (timestamp): Start of rate window
  - `window_seconds` (integer): Window duration (seconds)
  - `created_at` (timestamp): Record creation
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `identifier`
- **Notes:** Enables API rate limiting and abuse prevention

---

### Table: `public.referral_bonuses`
- **Purpose:** Tracks bonuses awarded for user referrals.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `referrer_id` (uuid): Referring user
  - `referred_id` (uuid): Referred user
  - `bonus_amount` (numeric): Bonus amount
  - `awarded_at` (timestamp): Award time
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports referral incentives and rewards

---

### Table: `public.referrals`
- **Purpose:** Tracks user referrals for XP and rewards.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `referrer_id` (uuid): Referring user
  - `referred_id` (uuid): Referred user
  - `created_at` (timestamp): Referral creation
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports referral tracking, XP, and reward logic

---

### Table: `public.resources`
- **Purpose:** Stores educational, support, and platform resources (links, docs, guides, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `platform` (text): Platform context
  - `title` (text): Resource title
  - `description` (text): Description
  - `resource_type` (text): Type (link, doc, etc.)
  - `url` (text): Resource URL
  - `content` (text): Resource content
  - `is_published` (boolean): Published status
  - `metadata` (jsonb): Additional metadata
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables resource libraries, documentation, and support content

---

### Table: `public.role_capabilities`
- **Purpose:** Stores feature-level access flags for roles within a tenant (multi-tenant RBAC).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `tenant_id` (uuid): Tenant reference
  - `role_slug` (text): Role identifier
  - `feature_name` (text): Feature name
  - `can_view`, `can_create`, `can_edit`, `can_delete`, `can_approve` (boolean): Access flags
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to tenants (if present)
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on (`tenant_id`, `role_slug`, `feature_name`)
- **Notes:** Enables granular, feature-based permissions per role and tenant

### Table: `public.role_permissions`
- **Purpose:** Maps roles to permissions for RBAC.
- **Key Columns:**
  - `role_id` (uuid): Role reference
  - `permission_id` (uuid): Permission reference
  - `created_at` (timestamp): Mapping creation
- **Relationships:** FK to roles, permissions
- **RLS:** [To be documented in policies.md]
- **Indexes:** Composite PK (`role_id`, `permission_id`)
- **Notes:** Supports many-to-many role-permission mapping

---

### Table: `public.room_participants`
- **Purpose:** Tracks users participating in chat rooms, with roles and join time.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `room_id` (uuid): Room reference
  - `user_id` (uuid): User reference
  - `joined_at` (timestamp): Join time
  - `role` (text): Role (owner/moderator/member)
- **Relationships:** FK to rooms, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `role`
- **Notes:** Enables chat membership, moderation, and permissions

### Table: `public.rooms`
- **Purpose:** Stores chat room definitions for group and direct messaging.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Room name
  - `description` (text): Room description
  - `room_type` (text): Type (group/direct/etc.)
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** Used by room_participants, messages
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports group chat and platform-specific rooms

---

### Table: `public.scheduled_sessions`
- **Purpose:** Stores scheduled coaching or value path sessions for users.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `session_date` (text): Date of session
  - `session_time` (text): Time of session
  - `value_paths` (text[]): Value paths for session
  - `status` (text): Session status (default: scheduled)
  - `notes` (text): Additional notes
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables scheduling, tracking, and management of sessions

---

### Table: `public.schema_version`
- **Purpose:** Tracks the current schema version and migration application time.
- **Key Columns:**
  - `version` (integer): Schema version number
  - `applied_at` (timestamp): When this version was applied
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `version`
- **Notes:** Supports migration tracking and schema management

---

### Table: `public.search_analytics`
- **Purpose:** Tracks user search queries, filters, and engagement for analytics.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference (nullable)
  - `query` (text): Search query
  - `filters` (jsonb): Applied filters
  - `results_count` (integer): Number of results
  - `selected_result` (jsonb): Selected result (if any)
  - `session_id` (uuid): Session reference
  - `platform` (text): Platform context
  - `created_at` (timestamp): Search time
- **Relationships:** FK to users (optional)
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables search analytics, UX improvements, and personalization

### Table: `public.search_suggestions`
- **Purpose:** Stores suggested search terms and their weights for autocomplete and guidance.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `trigger_term` (text): Term that triggers suggestion
  - `suggestion` (text): Suggested search
  - `weight` (numeric): Suggestion weight
  - `created_at` (timestamp): Record creation
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `trigger_term`
- **Notes:** Improves search UX with dynamic suggestions

---

### Table: `public.search_vectors`
- **Purpose:** Stores precomputed search vectors for full-text search and semantic search.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content (table/entity)
  - `content_id` (uuid): Reference to content
  - `title` (text): Title for search
  - `description` (text): Description
  - `content` (text): Content body
  - `tags` (text[]): Tags for search
  - `metadata` (jsonb): Additional metadata
  - `search_vector` (tsvector): Full-text search vector
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** References content in other tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `search_vector`
- **Notes:** Powers fast, relevant search and semantic queries

---

### Table: `public.security_events`
- **Purpose:** Logs security-related events for auditing, monitoring, and incident response.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `event_type` (text): Type of event (e.g., login, access, error)
  - `severity` (text): Severity level
  - `user_id` (uuid): User reference (nullable)
  - `ip_address` (text): IP address
  - `user_agent` (text): User agent string
  - `request_path` (text): Request path
  - `request_method` (text): HTTP method
  - `platform_slug` (text): Platform context
  - `context` (jsonb): Contextual data
  - `details` (jsonb): Additional details
  - `created_at` (timestamp): Event time
- **Relationships:** FK to users (optional)
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `event_type`, `severity`, `created_at`
- **Notes:** Enables security auditing, threat detection, and compliance

---

### Table: `public.security_logs`
- **Purpose:** Stores detailed security logs for monitoring, compliance, and incident response.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `event_type` (text): Event type
  - `severity` (text): Severity (low/medium/high/critical)
  - `context` (jsonb): Context data
  - `details` (jsonb): Additional details
  - `ip_address` (text): IP address
  - `user_agent` (text): User agent
  - `user_id` (uuid): User reference (nullable)
  - `platform` (text): Platform context
  - `timestamp`, `created_at` (timestamp): Event times
- **Relationships:** FK to users (optional)
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; check on `severity`
- **Notes:** Enables security event tracking, audits, and compliance

---

### Table: `public.session_notes`
- **Purpose:** Stores notes taken during or about a session (coaching, meeting, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `session_id` (uuid): Session reference
  - `author_id` (uuid): Author user
  - `content` (text): Note content
  - `is_private` (boolean): Private note flag
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to sessions, users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables session documentation, feedback, and privacy controls

### Table: `public.session_resources`
- **Purpose:** Stores resources linked or used in a session (files, links, etc.).
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `session_id` (uuid): Session reference
  - `resource_id` (uuid): Resource reference
  - `resource_type` (text): Type of resource
  - `created_at` (timestamp): Linked time
- **Relationships:** FK to sessions, resources
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Tracks learning/support materials per session

---

### Table: `public.sessions`
- **Purpose:** Stores scheduled sessions, including user, strategist, and meeting details.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `strategist_id` (uuid): Strategist/coach reference
  - `start_time`, `end_time` (timestamp): Session times
  - `zoom_meeting_id` (varchar): Zoom meeting ID
  - `zoom_join_url` (text): Zoom join URL
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users (user, strategist)
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables scheduling, tracking, and online session management

---

### Table: `public.shared_content`
- **Purpose:** Stores shared content (articles, guides, etc.) for publishing and collaboration.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `title` (text): Content title
  - `slug` (text): Unique slug
  - `description` (text): Description
  - `content` (jsonb): Content body
  - `category_id` (uuid): Category reference
  - `author_id` (uuid): Author user
  - `is_published` (boolean): Published status
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users, categories
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; unique on `slug`
- **Notes:** Enables collaborative publishing and knowledge sharing

---

### Table: `public.simulation_runs`
- **Purpose:** Stores records of user-initiated simulations, including parameters and results.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `scenario_name` (text): Scenario name
  - `parameters` (jsonb): Simulation parameters
  - `result_summary` (jsonb): Summary of results
  - `detailed_results` (jsonb): Detailed results
  - `status` (text): Run status (default: completed)
  - `started_at`, `finished_at` (timestamp): Timing
  - `notes` (text): Additional notes
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables scenario testing, analytics, and user feedback

---

### Table: `public.site_settings`
- **Purpose:** Stores site-wide configuration and reward settings for gamification and incentives.
- **Key Columns:**
  - `site` (text): Site identifier
  - `base_reward` (numeric): Base reward amount
  - `collab_bonus` (numeric): Collaboration bonus
  - `streak_bonus` (numeric): Streak bonus
  - `diminishing_threshold` (numeric): Threshold for diminishing returns
  - `conversion_rates` (jsonb): Conversion rates for points/tokens
  - `created_at` (timestamp): Record creation
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `site`
- **Notes:** Centralizes reward logic and site configuration

---

### Table: `public.skill_requirements`
- **Purpose:** Defines skill requirements for content (courses, tasks, etc.) to enable gating and progression.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `content_type` (text): Type of content (e.g., course, task)
  - `content_id` (uuid): Content reference
  - `skill_name` (text): Required skill
  - `required_level` (integer): Minimum required level
  - `created_at` (timestamp): Record creation
- **Relationships:** FK to content tables
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports adaptive learning and skill-based access

### Table: `public.social_interactions`
- **Purpose:** Tracks user interactions (likes, comments, shares, etc.) with activities and content.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `activity_id` (uuid): Activity/content reference
  - `interaction_type` (text): Type of interaction
  - `comment_text` (text): Comment content (if any)
  - `metadata` (jsonb): Additional metadata
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users, activities
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `interaction_type`
- **Notes:** Enables social features, engagement analytics, and moderation

### Table: `public.strategists`
- **Purpose:** Stores strategist/coach profiles, specialties, and availability for coaching features.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `name` (text): Strategist name
  - `email` (text): Strategist email
  - `avatar_url` (text): Profile image
  - `bio` (text): Bio/description
  - `specialties` (text[]): Areas of expertise
  - `max_sessions_per_day` (integer): Daily session limit
  - `active` (boolean): Is active
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Supports coach discovery, scheduling, and profile management

---

### Table: `public.supplements`
- **Purpose:** Stores supplement definitions, descriptions, and benefits for wellness or health features.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `name` (text): Supplement name
  - `description` (text): Supplement description
  - `benefits` (text): Benefits summary
  - `created_at`, `updated_at` (timestamp): Audit columns
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`
- **Notes:** Enables supplement catalog, recommendations, and tracking

### Table: `public.suspicious_activities`
- **Purpose:** Logs suspicious or potentially malicious user activities for security monitoring.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `user_id` (uuid): User reference
  - `activity_type` (text): Type of suspicious activity
  - `severity` (text): Severity level
  - `ip_address` (text): IP address
  - `user_agent` (text): User agent string
  - `location_data` (jsonb): Location/context data
  - `details` (jsonb): Additional details
  - `created_at` (timestamp): Event time
- **Relationships:** FK to users
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `activity_type`, `severity`, `created_at`
- **Notes:** Supports security auditing, threat detection, and compliance

---

### Table: `public.system_alerts`
- **Purpose:** Stores system alerts, notifications, and incident tracking for platform health and operations.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `alert_type` (text): Type of alert
  - `message` (text): Alert message
  - `severity` (text): Severity level
  - `created_at` (timestamp): Alert creation time
  - `resolved_at` (timestamp): Resolution time
  - `resolution_notes` (text): Notes on resolution
  - `notification_sent` (boolean): Notification status
  - `context` (jsonb): Additional context
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `alert_type`, `severity`, `created_at`
- **Notes:** Enables monitoring, incident response, and alerting workflows

---

### Table: `public.system_health_checks`
- **Purpose:** Tracks automated health checks for system components and services.
- **Key Columns:**
  - `id` (uuid, PK): Unique identifier
  - `check_name` (text): Name of the health check
  - `status` (text): Current status
  - `last_check_time` (timestamp): Last check timestamp
  - `next_check_time` (timestamp): Next scheduled check
  - `check_duration` (interval): Duration of the check
  - `details` (jsonb): Additional details
  - `severity` (text): Severity of status
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `check_name`, `status`, `severity`
- **Notes:** Enables uptime monitoring, alerting, and diagnostics

---

### Table: `public.system_metrics`
- **Purpose:** Stores system metrics and health data for monitoring and analytics.
- **Key Columns:**
  - `id` (integer, PK): Unique identifier (auto-incremented)
  - `metric_name` (text): Name of the metric
  - `metric_value` (jsonb): Metric value(s)
  - `updated_at` (timestamp): Last update time
- **Relationships:** None
- **RLS:** [To be documented in policies.md]
- **Indexes:** PK on `id`; index on `metric_name`
- **Notes:** Enables platform health dashboards and operational analytics

---
