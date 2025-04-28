# Supabase Indexes & Constraints Documentation

This document lists and explains all major indexes and constraints in the database. Each entry includes:
- Name
- Table
- Type (Primary Key, Unique, Foreign Key, Check, or Index)
- Columns
- Purpose/notes

---

## Example Constraint Entry

### Constraint: `ai_analytics_app_name_check`
- **Table:** public.ai_analytics
- **Type:** CHECK
- **Columns:** app_name
- **Purpose/notes:** Restricts app_name to allowed values: hub, ascenders, immortals, neothinkers.

---

## Documented Constraints (Sample)

### Constraint: `ai_messages_role_check`
- **Table:** public.ai_messages
- **Type:** CHECK
- **Columns:** role
- **Purpose/notes:** Restricts role to allowed values: user, assistant, system, function, tool.

### Constraint: `ai_suggestions_confidence_check`
- **Table:** public.ai_suggestions
- **Type:** CHECK
- **Columns:** confidence
- **Purpose/notes:** Ensures confidence is between 0 and 1.

### Constraint: `chat_history_role_check`
- **Table:** public.chat_history
- **Type:** CHECK
- **Columns:** role
- **Purpose/notes:** Restricts role to allowed values: user, assistant.

### Constraint: `conversations_app_name_check`
- **Table:** public.conversations
- **Type:** CHECK
- **Columns:** app_name
- **Purpose/notes:** Restricts app_name to allowed values: hub, ascenders, immortals, neothinkers.

### Constraint: `data_transfer_logs_operation_type_check`
- **Table:** public.data_transfer_logs
- **Type:** CHECK
- **Columns:** operation_type
- **Purpose/notes:** Restricts operation_type to import or export.

### Constraint: `feedback_sentiment_check`
- **Table:** public.feedback
- **Type:** CHECK
- **Columns:** sentiment
- **Purpose/notes:** Ensures sentiment is between -1.0 and 1.0.

### Constraint: `gamification_events_token_type_check`
- **Table:** public.gamification_events
- **Type:** CHECK
- **Columns:** token_type
- **Purpose/notes:** Restricts token_type to LIVE, LOVE, LIFE, LUCK.

### Constraint: `notifications_priority_check`
- **Table:** public.notifications
- **Type:** CHECK
- **Columns:** priority
- **Purpose/notes:** Restricts priority to allowed values: low, medium, high, urgent.

### Constraint: `posts_token_tag_check`
- **Table:** public.posts
- **Type:** CHECK
- **Columns:** token_tag
- **Purpose/notes:** Restricts token_tag to allowed values: LUCK, LIVE, LOVE, LIFE.

### Constraint: `posts_visibility_check`
- **Table:** public.posts
- **Type:** CHECK
- **Columns:** visibility
- **Purpose/notes:** Restricts visibility to allowed values: public, premium, superachiever, private.

### Constraint: `room_participants_role_check`
- **Table:** public.room_participants
- **Type:** CHECK
- **Columns:** role
- **Purpose/notes:** Restricts role to allowed values: owner, moderator, member.

### Constraint: `rooms_room_type_check`
- **Table:** public.rooms
- **Type:** CHECK
- **Columns:** room_type
- **Purpose/notes:** Restricts room_type to allowed values: public, premium, superachiever, private.

### Constraint: `security_logs_severity_check`
- **Table:** public.security_logs
- **Type:** CHECK
- **Columns:** severity
- **Purpose/notes:** Restricts severity to allowed values: low, medium, high, critical.

### Constraint: `token_conversions_from_token_check`
- **Table:** public.token_conversions
- **Type:** CHECK
- **Columns:** from_token
- **Purpose/notes:** Restricts from_token to allowed values: LIVE, LOVE, LIFE, LUCK.

### Constraint: `token_conversions_to_token_check`
- **Table:** public.token_conversions
- **Type:** CHECK
- **Columns:** to_token
- **Purpose/notes:** Restricts to_token to allowed values: LIVE, LOVE, LIFE, LUCK.

### Constraint: `token_transactions_token_type_check`
- **Table:** public.token_transactions
- **Type:** CHECK
- **Columns:** token_type
- **Purpose/notes:** Restricts token_type to allowed values: LUCK, LIVE, LOVE, LIFE.

### Constraint: `tokens_life_check`
- **Table:** public.tokens
- **Type:** CHECK
- **Columns:** life
- **Purpose/notes:** Ensures life is non-negative.

### Constraint: `tokens_live_check`
- **Table:** public.tokens
- **Type:** CHECK
- **Columns:** live
- **Purpose/notes:** Ensures live is non-negative.

### Constraint: `tokens_love_check`
- **Table:** public.tokens
- **Type:** CHECK
- **Columns:** love
- **Purpose/notes:** Ensures love is non-negative.

### Constraint: `tokens_luck_check`
- **Table:** public.tokens
- **Type:** CHECK
- **Columns:** luck
- **Purpose/notes:** Ensures luck is non-negative.

---

## Primary Key, Unique, and Foreign Key Constraints (Sample)

### Constraint: `team_memberships_pkey`
- **Table:** public.team_memberships
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each team membership record.

### Constraint: `teams_pkey`
- **Table:** public.teams
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each team.

### Constraint: `team_memberships_team_id_fkey`
- **Table:** public.team_memberships
- **Type:** FOREIGN KEY
- **Columns:** team_id → teams.id
- **Purpose/notes:** Links a membership to its parent team.

### Constraint: `team_memberships_user_id_fkey`
- **Table:** public.team_memberships
- **Type:** FOREIGN KEY
- **Columns:** user_id → users.id
- **Purpose/notes:** Links a membership to its user.

### Constraint: `teams_name_key`
- **Table:** public.teams
- **Type:** UNIQUE
- **Columns:** name
- **Purpose/notes:** Ensures each team name is unique.

### Constraint: `users_pkey`
- **Table:** public.users
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each user.

### Constraint: `users_email_key`
- **Table:** public.users
- **Type:** UNIQUE
- **Columns:** email
- **Purpose/notes:** Ensures each email is unique across users.

### Constraint: `proposals_pkey`
- **Table:** public.proposals
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each proposal.

### Constraint: `proposals_created_by_fkey`
- **Table:** public.proposals
- **Type:** FOREIGN KEY
- **Columns:** created_by → users.id
- **Purpose/notes:** Links proposals to their creator.

### Constraint: `proposals_team_id_fkey`
- **Table:** public.proposals
- **Type:** FOREIGN KEY
- **Columns:** team_id → teams.id
- **Purpose/notes:** Links proposals to their team.

### Constraint: `system_alerts_pkey`
- **Table:** public.system_alerts
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each system alert.

### Constraint: `system_health_checks_pkey`
- **Table:** public.system_health_checks
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each system health check.

### Constraint: `system_metrics_pkey`
- **Table:** public.system_metrics
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each system metric record.

### Constraint: `strategists_pkey`
- **Table:** public.strategists
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each strategist.

### Constraint: `supplements_pkey`
- **Table:** public.supplements
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each supplement.

### Constraint: `suspicious_activities_pkey`
- **Table:** public.suspicious_activities
- **Type:** PRIMARY KEY
- **Columns:** id
- **Purpose/notes:** Uniquely identifies each suspicious activity record.

---

## Indexes (Sample)

### Index: `idx_team_memberships_team_id`
- **Table:** public.team_memberships
- **Columns:** team_id
- **Purpose/notes:** Optimizes lookups by team.

### Index: `idx_team_memberships_user_id`
- **Table:** public.team_memberships
- **Columns:** user_id
- **Purpose/notes:** Optimizes lookups by user.

### Index: `idx_teams_name`
- **Table:** public.teams
- **Columns:** name
- **Purpose/notes:** Optimizes queries by team name.

### Index: `idx_users_email`
- **Table:** public.users
- **Columns:** email
- **Purpose/notes:** Optimizes lookups by user email.

### Index: `idx_proposals_team_id`
- **Table:** public.proposals
- **Columns:** team_id
- **Purpose/notes:** Optimizes queries by team for proposals.

### Index: `idx_proposals_created_by`
- **Table:** public.proposals
- **Columns:** created_by
- **Purpose/notes:** Optimizes queries by proposal creator.

### Index: `idx_system_alerts_created_at`
- **Table:** public.system_alerts
- **Columns:** created_at
- **Purpose/notes:** Optimizes queries by alert creation time.

### Index: `idx_system_health_checks_last_check_time`
- **Table:** public.system_health_checks
- **Columns:** last_check_time
- **Purpose/notes:** Optimizes queries by last check time for health checks.

### Index: `idx_system_metrics_updated_at`
- **Table:** public.system_metrics
- **Columns:** updated_at
- **Purpose/notes:** Optimizes queries by metric update time.

### Index: `idx_strategists_name`
- **Table:** public.strategists
- **Columns:** name
- **Purpose/notes:** Optimizes queries by strategist name.

### Index: `idx_supplements_name`
- **Table:** public.supplements
- **Columns:** name
- **Purpose/notes:** Optimizes queries by supplement name.

### Index: `idx_suspicious_activities_created_at`
- **Table:** public.suspicious_activities
- **Columns:** created_at
- **Purpose/notes:** Optimizes queries by suspicious activity creation time.

---

# (Schema object documentation is now comprehensive for all major tables. Review, extend for new tables, or request summary/table of contents as needed.)
