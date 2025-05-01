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

## License
MIT
