-- Trigger: set_governance_proposals_timestamp
-- Extracted from baseline migration

CREATE OR REPLACE TRIGGER set_governance_proposals_timestamp
BEFORE UPDATE ON public.governance_proposals
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();
