# Contributing to Neothink DAO Supabase

Thank you for helping make this project robust, secure, and well-documented!

## Contribution Guidelines

- All changes to the database (tables, functions, policies, etc.) must be made via SQL migration files in `supabase/migrations/`.
- Use timestamped, descriptive filenames for migrations (e.g., `20250427084100_create_users_table.sql`).
- Every SQL file must include thorough comments:
  - Purpose, business logic, security, and access patterns
  - User/admin perspective, where relevant
- All edge functions must be in `supabase/functions/` and follow Deno 2.1+ best practices.
- All documentation (including ERDs, table/function/policy explanations) goes in `docs/`.
- Enable RLS and document every policy. Add indexes for columns used in policies.
- Use `SECURITY INVOKER` and `search_path=''` by default in functions.
- Prefer `IMMUTABLE` or `STABLE` for functions unless side effects are required.
- Do not expose secrets. Use environment variables for configuration.
- Follow accessibility and security best practices.

## Workflow

1. Fork the repo and create a feature branch.
2. Add or update migration files, edge functions, or docs as needed.
3. Create a pull request with a clear description.
4. All code is reviewed for clarity, security, and documentation before merging.

See `README.md` and `docs/` for more details.
