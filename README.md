# Supabase for Neothink DAO

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
