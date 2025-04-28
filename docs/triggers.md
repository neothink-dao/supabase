# Supabase Database Triggers Documentation

This document provides structured documentation for all Postgres triggers in the Neothink DAO Supabase database. Each trigger entry includes:
- Trigger name
- Table
- Event (insert/update/delete)
- Timing (before/after)
- Function invoked
- Purpose/notes

---

## Example Trigger Entry

### Trigger: `cleanup_old_security_events_trigger`
- **Table:** public.security_events
- **Event:** BEFORE INSERT
- **Function:** public.cleanup_old_security_events()
- **Purpose/notes:** Cleans up old security event logs before inserting a new event.

---

## Documented Triggers

### Trigger: `content_update_notify`
- **Table:** public.content
- **Event:** AFTER INSERT OR UPDATE
- **Function:** public.notify_content_update()
- **Purpose/notes:** Notifies subscribers or systems of content changes.

### Trigger: `delete_old_chat_history_trigger`
- **Table:** public.chat_history
- **Event:** BEFORE INSERT
- **Function:** public.delete_old_chat_history()
- **Purpose/notes:** Cleans up old chat messages before inserting new ones.

### Trigger: `ensure_token_balance_trigger`
- **Table:** public.token_balances
- **Event:** BEFORE INSERT
- **Function:** public.ensure_token_balance()
- **Purpose/notes:** Ensures token balances are valid before insert.

### Trigger: `messages_notify_trigger`
- **Table:** public.messages
- **Event:** AFTER INSERT OR UPDATE
- **Function:** public.handle_message_changes()
- **Purpose/notes:** Notifies systems or users of message changes.

### Trigger: `notify_new_message_trigger`
- **Table:** public.chat_messages
- **Event:** AFTER INSERT
- **Function:** public.notify_new_message()
- **Purpose/notes:** Notifies users of new chat messages.

### Trigger: `on_profile_created`
- **Table:** public.profiles
- **Event:** AFTER INSERT
- **Function:** public.handle_new_user()
- **Purpose/notes:** Handles onboarding logic for new users.

### Trigger: `on_profile_platform_change`
- **Table:** public.profiles
- **Event:** AFTER UPDATE OF platforms
- **Function:** public.handle_profile_platform_changes()
- **Purpose/notes:** Handles changes in user platform assignments.

### Trigger: `posts_notify_trigger`
- **Table:** public.posts
- **Event:** AFTER INSERT OR DELETE OR UPDATE
- **Function:** public.handle_post_changes()
- **Purpose/notes:** Notifies systems or users of post changes.

### Trigger: `set_governance_proposals_timestamp`
- **Table:** public.governance_proposals
- **Event:** BEFORE UPDATE
- **Function:** public.update_updated_at_column()
- **Purpose/notes:** Updates the updated_at timestamp on proposal changes.

### Trigger: `set_tokens_timestamp`
- **Table:** public.tokens
- **Event:** BEFORE UPDATE
- **Function:** public.update_updated_at_column()
- **Purpose/notes:** Updates the updated_at timestamp on token changes.

### Trigger: `set_updated_at`
- **Table:** public.feedback
- **Event:** BEFORE UPDATE
- **Function:** public.handle_updated_at()
- **Purpose/notes:** Updates the updated_at timestamp on feedback changes.

### Trigger: `set_updated_at_timestamp` (content_modules)
- **Table:** public.content_modules
- **Event:** BEFORE UPDATE
- **Function:** public.handle_updated_at()
- **Purpose/notes:** Updates the updated_at timestamp on content module changes.

### Trigger: `set_updated_at_timestamp` (lessons)
- **Table:** public.lessons
- **Event:** BEFORE UPDATE
- **Function:** public.handle_updated_at()
- **Purpose/notes:** Updates the updated_at timestamp on lesson changes.

### Trigger: `set_updated_at_timestamp` (profiles)
- **Table:** public.profiles
- **Event:** BEFORE UPDATE
- **Function:** public.handle_updated_at()
- **Purpose/notes:** Updates the updated_at timestamp on profile changes.

### Trigger: `set_updated_at_timestamp` (resources)
- **Table:** public.resources
- **Event:** BEFORE UPDATE
- **Function:** public.handle_updated_at()
- **Purpose/notes:** Updates the updated_at timestamp on resource changes.

### Trigger: `set_updated_at_timestamp` (user_profiles)
- **Table:** public.user_profiles
- **Event:** BEFORE UPDATE
- **Function:** public.handle_updated_at()
- **Purpose/notes:** Updates the updated_at timestamp on user profile changes.

### Trigger: `set_user_gamification_stats_timestamp`
- **Table:** public.user_gamification_stats
- **Event:** BEFORE UPDATE
- **Function:** public.update_updated_at_column()
- **Purpose/notes:** Updates the updated_at timestamp on user gamification stats.

### Trigger: `trg_broadcast_post`
- **Table:** public.posts
- **Event:** AFTER INSERT
- **Function:** public.broadcast_post()
- **Purpose/notes:** Broadcasts new post events to subscribers.

### Trigger: `trg_broadcast_room_message`
- **Table:** public.messages
- **Event:** AFTER INSERT
- **Function:** public.broadcast_room_message()
- **Purpose/notes:** Broadcasts new room message events to subscribers.

### Trigger: `trg_messages_award_tokens`
- **Table:** public.messages
- **Event:** BEFORE INSERT OR UPDATE OF token_tag
- **Function:** public.award_message_tokens()
- **Purpose/notes:** Awards tokens for eligible messages.

### Trigger: `trg_notify_token_earnings`
- **Table:** public.token_balances
- **Event:** AFTER UPDATE OF luck_balance, live_balance, love_balance, life_balance
- **Function:** public.notify_token_earnings()
- **Purpose/notes:** Notifies users of token earnings.

### Trigger: `trg_posts_award_tokens`
- **Table:** public.posts
- **Event:** BEFORE INSERT OR UPDATE OF token_tag
- **Function:** public.award_post_tokens()
- **Purpose/notes:** Awards tokens for eligible posts.

### Trigger: `trg_posts_notify`
- **Table:** public.posts
- **Event:** AFTER INSERT OR UPDATE
- **Function:** public.handle_new_post()
- **Purpose/notes:** Notifies systems or users of new/updated posts.

### Trigger: `trg_refresh_token_statistics`
- **Table:** public.posts
- **Event:** AFTER INSERT OR DELETE OR UPDATE (statement)
- **Function:** public.refresh_token_statistics()
- **Purpose/notes:** Refreshes token statistics after post changes.

### Trigger: `trg_token_balances_notify`
- **Table:** public.token_balances
- **Event:** AFTER UPDATE
- **Function:** public.handle_token_update()
- **Purpose/notes:** Handles updates to token balances.

### Trigger: `trigger_delete_old_chat_history`
- **Table:** public.chat_history
- **Event:** AFTER INSERT (conditional)
- **Function:** public.delete_old_chat_history()
- **Purpose/notes:** Deletes old chat history periodically after insert.

### Trigger: `trigger_governance_proposal_approval`
- **Table:** public.governance_proposals
- **Event:** BEFORE UPDATE OF status
- **Function:** public.handle_governance_proposal_update()
- **Purpose/notes:** Handles proposal approval logic.

### Trigger: `trigger_new_post`
- **Table:** public.posts
- **Event:** AFTER INSERT
- **Function:** public.handle_new_post()
- **Purpose/notes:** Handles logic for new posts.

### Trigger: `trigger_update_session_metrics`
- **Table:** public.sessions
- **Event:** AFTER INSERT OR DELETE OR UPDATE (statement)
- **Function:** public.update_session_metrics()
- **Purpose/notes:** Updates session metrics after changes.

### Trigger: `trigger_update_user_counts`
- **Table:** public.user_profiles
- **Event:** AFTER INSERT OR DELETE OR UPDATE (statement)
- **Function:** public.update_user_counts()
- **Purpose/notes:** Updates user counts after profile changes.

### Trigger: `update_conversation_timestamp_trigger`
- **Table:** public.chat_messages
- **Event:** AFTER INSERT
- **Function:** public.update_conversation_timestamp()
- **Purpose/notes:** Updates conversation timestamp after new message.

### Trigger: `update_email_templates_updated_at`
- **Table:** public.email_templates
- **Event:** BEFORE UPDATE
- **Function:** public.update_updated_at_column()
- **Purpose/notes:** Updates updated_at on email template changes.

### Trigger: `update_platform_state_updated_at`
- **Table:** public.platform_state
- **Event:** BEFORE UPDATE
- **Function:** public.update_modified_column()
- **Purpose/notes:** Updates modified column on platform state changes.

### Trigger: `update_user_notification_preferences_updated_at`
- **Table:** public.user_notification_preferences
- **Event:** BEFORE UPDATE
- **Function:** public.update_updated_at_column()
- **Purpose/notes:** Updates updated_at on notification preference changes.

---

# (All triggers documented. Review and extend as needed for new tables or changes.)
