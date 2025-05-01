# Supabase RLS Policies

This folder contains all Row Level Security (RLS) policies for the database, organized as one SQL file per table-operation-role (e.g., `users_select_authenticated.sql`).

## Best Practices
- Each policy is documented and version-controlled.
- Naming convention: `table_operation_role.sql` (e.g., `users_select_anon.sql`, `posts_delete_creator.sql`).
- Use `auth.uid()` for user checks, and reference roles explicitly.
- Add indexes to columns used in policies for performance.
- Each file contains a `CREATE POLICY` statement and a comment explaining the policy purpose.
- All policies are granular (one per operation/role) and follow Supabase and MCP best practices.

## References
- [Supabase Declarative Schemas](https://supabase.com/blog/declarative-schemas)
- [Supabase RLS Docs](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase MCP Server](https://supabase.com/blog/mcp-server)

## Example
```sql
-- Allow authenticated users to select their own user record
CREATE POLICY "Allow select for authenticated user" ON public.users
FOR SELECT
TO authenticated
USING (id = auth.uid());
```
