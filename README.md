# Supabase for Neothink DAO

## Supabase Baseline Migration (neothink)

This repo is the canonical source of truth for the [neothink Supabase project](https://app.supabase.com/project/dlmpxgzxdtqxyzsmpaxx).

- **Baseline migration:** `supabase/supabase/migrations/20250501164000_baseline.sql` (generated 2025-05-01)
- All previous migrations have been removed; only this baseline is tracked.
- All future migrations must be modular, timestamped, and declarative.

### Migration Workflow (Best Practice)

1. Make schema changes locally or in the Supabase dashboard.
2. Use `supabase db diff` to generate a new migration, or author a migration manually in `migrations/`.
3. Apply with `supabase db push`.
4. Commit and PR all migration files.

### Supabase Project Linking

- Project Ref: `dlmpxgzxdtqxyzsmpaxx`
- Organization: `vercel_icfg_D0rjqr9um8t994YH9IDUTQnu`

### Best Practices
- All migrations and policies are declarative and version-controlled.
- RLS is enabled and granular for all tables.
- Use Edge Functions (Deno 2.1+), Realtime Broadcast, Data API, and the Supabase UI Library as needed.
- See [Supabase best practices](https://supabase.com/blog/declarative-schemas) for more.

---

**This repo now accurately reflects the current state of the remote Supabase database. All future development should follow the practices above.**

This repository contains the **declarative, version-controlled Supabase database schema, migrations, functions, triggers, policies, and documentation** for the Neothink DAO platform.

## Key Features
- All schema and migrations are managed via SQL files in `supabase/migrations/`.
- Edge functions (Deno 2.1+) are in `supabase/functions/`.
- Documentation for users and admins is in `docs/`.
- Follows Supabase and open-source best practices for structure, security, and maintainability.
- MCP/CI/CD ready for automated deployments and edge function management.

## Supabase Schema Drift Detection (CI/CD)

This repo includes a GitHub Actions workflow (`.github/workflows/supabase-schema-drift.yml`) that automatically checks for schema drift between the repo and the live Supabase database on every PR and push to `main`.

- **How it works:**
  - On every push or PR, the workflow runs `supabase db diff --linked` against your live project.
  - If there are any uncommitted schema changes, the workflow will fail, preventing drift.
  - Secrets required: `SUPABASE_DB_PASSWORD`, `SUPABASE_PROJECT_REF` (add these in your repo settings).

## Policy & Security Model

- **Row Level Security (RLS):** Enabled on all tables by default for maximum security.
- **Default Policies:** All tables have a default-deny policy and a permissive `service_role` policy.
- **User Policies:** For tables with a `user_id` column, authenticated users can only access their own rows (SELECT, INSERT, UPDATE, DELETE).
- **Admin Policies:** Service/admin roles retain full access for management and support. (Add more granular admin policies as needed.)

## Edge Functions & Automation

- All Edge Functions use Deno 2.1+, are modular, and leverage environment variables for secrets.
- Use Edge Functions for automation, notifications, and delightful user experiences.

## Realtime & Event-Driven UX

- Realtime is enabled for collaborative and notification-driven tables (e.g., chat, notifications).
- Use Realtime Broadcast for ephemeral UI updates.

## Accessibility & Performance

- All APIs and UIs are designed for accessibility (ARIA, keyboard, mobile-friendly).
- Indexes are added for all columns used in policies and frequent queries.

## Onboarding & Documentation

- All migrations are timestamped, modular, and idempotent where possible.
- This README, migration comments, and code comments document all custom business logic, policies, and workflows.

## Getting Started
See [docs/](docs/) for full documentation and onboarding instructions.

---

**Supabase Project ID:** `dlmpxgzxdtqxyzsmpaxx`  
**Supabase Org ID:** `vercel_icfg_D0rjqr9um8t994YH9IDUTQnu`

---

## Directory Structure

- `supabase/migrations/` — SQL migrations, one file per change (timestamped, descriptive names)
- `supabase/functions/` — Edge functions (Deno)
- `docs/` — User/admin documentation
- `CONTRIBUTING.md` — Contribution guidelines

---

## Next Steps

- Review and customize policies for your business logic and roles.
- Add more granular admin and public access policies as needed.
- Expand Edge Functions and Realtime features for even more delightful automation and engagement.

## License
MIT
