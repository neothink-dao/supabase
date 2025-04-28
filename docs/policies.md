# Supabase Row Level Security (RLS) Policies Documentation

This document lists and explains all RLS policies for each table in the database. Each policy entry includes:
- Policy name
- Table
- Operation (select/insert/update/delete)
- Role(s)
- Policy logic
- Purpose/notes

---

## Example Policy Entry

### Policy: "Admin can access all AI configurations"
- **Table:** public.ai_configurations
- **Operation:** All (select/insert/update/delete)
- **Role(s):** admin
- **Policy logic:** `((auth.jwt() ->> 'role') = 'admin')`
- **Purpose/notes:** Grants admins full access to AI configuration records.

---

## Documented Policies

### Policy: "Admin can manage vector collections"
- **Table:** public.ai_vector_collections
- **Operation:** All
- **Role(s):** admin
- **Policy logic:** `((auth.jwt() ->> 'role') = 'admin')`
- **Purpose/notes:** Admins manage all vector collections.

### Policy: "Admin can manage vector mappings"
- **Table:** public.ai_vector_collection_mappings
- **Operation:** All
- **Role(s):** admin
- **Policy logic:** `((auth.jwt() ->> 'role') = 'admin')`
- **Purpose/notes:** Admins manage all vector mappings.

### Policy: "Administrators can manage tenant domains"
- **Table:** public.tenant_domains
- **Operation:** All
- **Role(s):** authenticated (with guardian profile)
- **Policy logic:** `((auth.role() = 'authenticated') AND (SELECT profiles.is_guardian ...))`
- **Purpose/notes:** Only tenant admins/guardians can manage domains.

### Policy: "Administrators can manage tenant subscriptions"
- **Table:** public.tenant_subscriptions
- **Operation:** All
- **Role(s):** authenticated (with guardian profile)
- **Policy logic:** `((auth.role() = 'authenticated') AND (SELECT profiles.is_guardian ...))`
- **Purpose/notes:** Only tenant admins/guardians can manage subscriptions.

### Policy: "Administrators can manage tenant users"
- **Table:** public.tenant_users
- **Operation:** All
- **Role(s):** authenticated (with guardian profile)
- **Policy logic:** `((auth.role() = 'authenticated') AND (SELECT profiles.is_guardian ...))`
- **Purpose/notes:** Only tenant admins/guardians can manage users.

### Policy: "Administrators can manage tenants"
- **Table:** public.tenants
- **Operation:** All
- **Role(s):** authenticated (with guardian profile)
- **Policy logic:** `((auth.role() = 'authenticated') AND (SELECT profiles.is_guardian ...))`
- **Purpose/notes:** Only tenant admins/guardians can manage tenants.

### Policy: "Admins can create events"
- **Table:** public.events
- **Operation:** Insert
- **Role(s):** admin
- **Policy logic:** `EXISTS (SELECT 1 ...)`
- **Purpose/notes:** Only admins can create events.

### Policy: "Admins can manage shared content"
- **Table:** public.shared_content
- **Operation:** All
- **Role(s):** service_role, supabase_admin, guardian
- **Policy logic:** `((auth.role() = 'service_role') OR (auth.role() = 'supabase_admin') OR (SELECT profiles.is_guardian ...))`
- **Purpose/notes:** Admins and guardians manage shared content.

### Policy: "Admins can manage topics"
- **Table:** public.discussion_topics
- **Operation:** All
- **Role(s):** admin
- **Policy logic:** `EXISTS (SELECT 1 ...)`
- **Purpose/notes:** Only admins can manage topics.

### Policy: "Admins can select all analytics events"
- **Table:** public.analytics_events
- **Operation:** Select
- **Role(s):** service_role
- **Policy logic:** `true`
- **Purpose/notes:** Service roles can select all analytics events.

### Policy: "Admins can update events"
- **Table:** public.events
- **Operation:** Update
- **Role(s):** admin
- **Policy logic:** `EXISTS (SELECT 1 ...)`
- **Purpose/notes:** Only admins can update events.

### Policy: "Admins can view all simulation runs"
- **Table:** public.simulation_runs
- **Operation:** Select
- **Role(s):** service_role, authenticated
- **Policy logic:** `((auth.role() = 'service_role') OR (auth.role() = 'authenticated'))`
- **Purpose/notes:** Service roles and authenticated users can view simulation runs.

### Policy: "Allow admin full access via profiles"
- **Table:** public.feedback
- **Operation:** All
- **Role(s):** admin
- **Policy logic:** `EXISTS (SELECT 1 ...)`
- **Purpose/notes:** Admins have full access to feedback via profile linkage.

### Policy: "Allow anonymous users to read email templates"
- **Table:** public.email_templates
- **Operation:** Select
- **Role(s):** anon
- **Policy logic:** `true`
- **Purpose/notes:** Anonymous users can read email templates.

### Policy: "Allow authenticated users to read email templates"
- **Table:** public.email_templates
- **Operation:** Select
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Authenticated users can read email templates.

### Policy: "Allow delete for creator"
- **Table:** public.proposals
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `(created_by = auth.uid())`
- **Purpose/notes:** Only the creator of a proposal can delete it.

### Policy: "Allow delete for self"
- **Table:** public.team_memberships
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `(user_id = auth.uid())`
- **Purpose/notes:** Users can remove themselves from team memberships.

### Policy: "Allow delete for team creator"
- **Table:** public.teams
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `(created_by = auth.uid())`
- **Purpose/notes:** Only the creator of a team can delete it.

### Policy: "Allow insert for authenticated" (team_memberships)
- **Table:** public.team_memberships
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `(auth.role() = 'authenticated')`
- **Purpose/notes:** Any authenticated user can join a team.

### Policy: "Allow insert for authenticated" (teams)
- **Table:** public.teams
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `(auth.role() = 'authenticated')`
- **Purpose/notes:** Any authenticated user can create a team.

### Policy: "Allow insert for authenticated" (proposals)
- **Table:** public.proposals
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `(auth.role() = 'authenticated')`
- **Purpose/notes:** Any authenticated user can create a proposal.

### Policy: "Allow insert for authenticated" (user_actions)
- **Table:** public.user_actions
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `(auth.uid() = user_id)`
- **Purpose/notes:** Users can only insert actions for themselves.

### Policy: "Allow insert for authenticated" (user_badges)
- **Table:** public.user_badges
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `(auth.uid() = user_id)`
- **Purpose/notes:** Users can only insert badges for themselves.

### Policy: "Allow insert for authenticated" (user_profiles)
- **Table:** public.user_profiles
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can create a user profile.

### Policy: "Allow insert for authenticated" (user_segments)
- **Table:** public.user_segments
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can create a user segment.

### Policy: "Allow insert for authenticated" (user_sessions)
- **Table:** public.user_sessions
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can create a user session.

### Policy: "Allow insert for authenticated" (user_skills)
- **Table:** public.user_skills
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can add a skill.

### Policy: "Allow insert for authenticated" (votes)
- **Table:** public.votes
- **Operation:** Insert
- **Role(s):** authenticated
- **Policy logic:** `(auth.role() = 'authenticated')`
- **Purpose/notes:** Any authenticated user can vote.

### Policy: "Allow delete for authenticated" (user_actions)
- **Table:** public.user_actions
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `(auth.uid() = user_id)`
- **Purpose/notes:** Users can delete their own actions.

### Policy: "Allow delete for authenticated" (user_profiles)
- **Table:** public.user_profiles
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can delete their own profile.

### Policy: "Allow delete for authenticated" (user_segments)
- **Table:** public.user_segments
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can delete their own segment.

### Policy: "Allow delete for authenticated" (user_sessions)
- **Table:** public.user_sessions
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can delete their own session.

### Policy: "Allow delete for authenticated" (user_skills)
- **Table:** public.user_skills
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can delete their own skill.

### Policy: "Allow delete for authenticated" (xp_multipliers)
- **Table:** public.xp_multipliers
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can delete their own XP multiplier.

### Policy: "Allow delete for authenticated" (zoom_attendance)
- **Table:** public.zoom_attendance
- **Operation:** Delete
- **Role(s):** authenticated
- **Policy logic:** `true`
- **Purpose/notes:** Any authenticated user can delete their own zoom attendance.

---

# (RLS policy documentation complete for user, team, proposal, and system tables. Review and extend as needed for new tables or changes.)
