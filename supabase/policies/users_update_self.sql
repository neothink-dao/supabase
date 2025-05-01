-- Policy: Allow update for user on their own record
-- Extracted from unified migrations

CREATE POLICY "Allow update for self" ON public.users
FOR UPDATE
TO authenticated
USING (id = auth.uid());
