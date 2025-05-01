-- Policy: Allow insert for authenticated users on users
-- Extracted from unified migrations

CREATE POLICY "Allow insert for authenticated user" ON public.users
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());
