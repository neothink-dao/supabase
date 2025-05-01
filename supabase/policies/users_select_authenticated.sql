-- Policy: Allow select for authenticated users on users
-- Extracted from unified migrations

CREATE POLICY "Allow select for authenticated user" ON public.users
FOR SELECT
TO authenticated
USING (id = auth.uid());
