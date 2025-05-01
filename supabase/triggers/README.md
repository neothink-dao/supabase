# Supabase Database Triggers

This folder contains all database triggers, one per file, with clear documentation and naming conventions.

## Best Practices
- Each trigger is version-controlled and documented.
- Naming convention: `table_event_action.sql` or descriptive trigger name.
- Each file contains a `CREATE TRIGGER` statement, and a comment header.
- Triggers reference modular functions in `/supabase/functions/`.
- All triggers follow Supabase and MCP best practices for portability and CI/CD.

## References
- [Supabase Declarative Schemas](https://supabase.com/blog/declarative-schemas)
- [Supabase MCP Server](https://supabase.com/blog/mcp-server)

## Example
```sql
-- Trigger: notify_new_message_trigger
CREATE OR REPLACE TRIGGER notify_new_message_trigger
AFTER INSERT ON public.chat_messages
FOR EACH ROW
EXECUTE FUNCTION public.notify_new_message();
```
