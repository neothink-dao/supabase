-- Policy: Allow delete for admin users on users
-- Extracted from unified migrations

CREATE POLICY "Admin can delete user" ON public.users
FOR DELETE
TO authenticated
USING (EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'admin'));
