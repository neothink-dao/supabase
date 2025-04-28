-- Migration: Auth Email Templates and User Preferences
-- Description: Sets up tables and functions for managing email templates and user notification preferences
-- Author: Neothink Team
-- Date: 2025-04-23

-- Enable the pgcrypto extension for UUID generation if not already enabled
create extension if not exists pgcrypto;

-- Create email_templates table to store customizable email templates
create table if not exists public.email_templates (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  subject text not null,
  html_content text not null,
  text_content text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Add comment to the email_templates table
comment on table public.email_templates is 'Stores customizable email templates for the application';

-- Enable Row Level Security on the email_templates table
alter table public.email_templates enable row level security;

-- Create RLS policy for anon users (read-only access to email_templates)
create policy "Allow anonymous users to read email templates"
  on public.email_templates
  for select
  to anon
  using (true);

-- Create RLS policy for authenticated users (read-only access to email_templates)
create policy "Allow authenticated users to read email templates"
  on public.email_templates
  for select
  to authenticated
  using (true);

-- Create user_notification_preferences table to store user preferences for emails
create table if not exists public.user_notification_preferences (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  marketing_emails boolean not null default true,
  product_updates boolean not null default true,
  security_alerts boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id)
);

-- Add comment to the user_notification_preferences table
comment on table public.user_notification_preferences is 'Stores user preferences for email notifications';

-- Enable Row Level Security on the user_notification_preferences table
alter table public.user_notification_preferences enable row level security;

-- Create RLS policy for authenticated users (read own notification preferences)
create policy "Users can read their own notification preferences"
  on public.user_notification_preferences
  for select
  to authenticated
  using (auth.uid() = user_id);

-- Create RLS policy for authenticated users (insert own notification preferences)
create policy "Users can insert their own notification preferences"
  on public.user_notification_preferences
  for insert
  to authenticated
  with check (auth.uid() = user_id);

-- Create RLS policy for authenticated users (update own notification preferences)
create policy "Users can update their own notification preferences"
  on public.user_notification_preferences
  for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Create function to get user notification preferences
create or replace function public.get_user_notification_preferences()
returns json
language plpgsql
security invoker
set search_path = ''
as $$
declare
  preferences json;
begin
  select json_build_object(
    'marketing_emails', p.marketing_emails,
    'product_updates', p.product_updates,
    'security_alerts', p.security_alerts
  ) into preferences
  from public.user_notification_preferences p
  where p.user_id = auth.uid();
  
  -- If no preferences exist, return default values
  if preferences is null then
    preferences := json_build_object(
      'marketing_emails', true,
      'product_updates', true,
      'security_alerts', true
    );
  end if;
  
  return preferences;
end;
$$;

-- Create function to update user notification preferences
create or replace function public.update_user_notification_preferences(
  p_marketing_emails boolean,
  p_product_updates boolean,
  p_security_alerts boolean
)
returns json
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
  v_preferences json;
begin
  -- Check if the user is authenticated
  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;
  
  -- Insert or update the user's notification preferences
  insert into public.user_notification_preferences (
    user_id,
    marketing_emails,
    product_updates,
    security_alerts
  )
  values (
    v_user_id,
    p_marketing_emails,
    p_product_updates,
    p_security_alerts
  )
  on conflict (user_id)
  do update set
    marketing_emails = p_marketing_emails,
    product_updates = p_product_updates,
    security_alerts = p_security_alerts,
    updated_at = now();
  
  -- Return the updated preferences
  select json_build_object(
    'marketing_emails', p.marketing_emails,
    'product_updates', p.product_updates,
    'security_alerts', p.security_alerts
  ) into v_preferences
  from public.user_notification_preferences p
  where p.user_id = v_user_id;
  
  return v_preferences;
end;
$$;

-- Create function to track email events (opens, clicks, etc.)
create or replace function public.track_email_event(
  p_user_id uuid,
  p_email_type text,
  p_event_type text,
  p_metadata jsonb default null
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  -- Insert the email event into the email_events table
  insert into public.email_events (
    user_id,
    email_type,
    event_type,
    metadata
  )
  values (
    p_user_id,
    p_email_type,
    p_event_type,
    p_metadata
  );
end;
$$;

-- Create email_events table to track email events
create table if not exists public.email_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  email_type text not null,
  event_type text not null,
  metadata jsonb,
  created_at timestamptz not null default now()
);

-- Add comment to the email_events table
comment on table public.email_events is 'Tracks email events such as opens, clicks, etc.';

-- Enable Row Level Security on the email_events table
alter table public.email_events enable row level security;

-- Create RLS policy for authenticated users (read own email events)
create policy "Users can read their own email events"
  on public.email_events
  for select
  to authenticated
  using (auth.uid() = user_id);

-- Create RLS policy for authenticated users (insert own email events)
create policy "Users can insert their own email events"
  on public.email_events
  for insert
  to authenticated
  with check (auth.uid() = user_id);

-- Create trigger to update the updated_at column
create or replace function public.update_updated_at_column()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Create trigger for email_templates table
create trigger update_email_templates_updated_at
before update on public.email_templates
for each row
execute function public.update_updated_at_column();

-- Create trigger for user_notification_preferences table
create trigger update_user_notification_preferences_updated_at
before update on public.user_notification_preferences
for each row
execute function public.update_updated_at_column();

-- Insert default email templates
insert into public.email_templates (name, subject, html_content, text_content)
values
  ('welcome', 'Welcome to Neothink!', '<h1>Welcome to Neothink!</h1><p>We''re excited to have you join our community.</p>', 'Welcome to Neothink! We''re excited to have you join our community.'),
  ('password_reset', 'Reset your Neothink password', '<h1>Reset your password</h1><p>Click the link below to reset your password.</p>', 'Reset your password. Click the link below to reset your password.'),
  ('magic_link', 'Your Neothink sign-in link', '<h1>Sign in to Neothink</h1><p>Click the link below to sign in to your account.</p>', 'Sign in to Neothink. Click the link below to sign in to your account.'),
  ('email_confirmation', 'Confirm your email for Neothink', '<h1>Confirm your email</h1><p>Click the link below to confirm your email address.</p>', 'Confirm your email. Click the link below to confirm your email address.')
on conflict (name)
do nothing;
