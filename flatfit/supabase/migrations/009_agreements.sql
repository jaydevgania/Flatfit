-- 009_agreements.sql
-- Flat agreements, clauses, signatures, and move-in checklists

CREATE TYPE agreement_status AS ENUM ('draft', 'active', 'terminated');

CREATE TABLE agreements (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid, -- FK added after flats table
    title text NOT NULL,
    description text,
    clauses jsonb NOT NULL DEFAULT '[]'::jsonb,
    -- clauses: [{ "title": "Rent split", "description": "Equal 3-way split", "amount": 10000 }, ...]
    rent_amount numeric(10,2),
    deposit_amount numeric(10,2),
    notice_period_days int DEFAULT 30,
    start_date date,
    end_date date,
    status agreement_status NOT NULL DEFAULT 'draft',
    created_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_agreements_flat ON agreements(flat_id);
CREATE INDEX idx_agreements_status ON agreements(status);

CREATE TABLE agreement_signatures (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    agreement_id uuid NOT NULL REFERENCES agreements(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    signed_at timestamptz NOT NULL DEFAULT now(),
    ip_address inet,
    UNIQUE(agreement_id, user_id)
);

CREATE INDEX idx_agreement_signatures_agreement ON agreement_signatures(agreement_id);
CREATE INDEX idx_agreement_signatures_user ON agreement_signatures(user_id);

CREATE TABLE move_in_checklists (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    agreement_id uuid NOT NULL REFERENCES agreements(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    item text NOT NULL,
    is_completed boolean NOT NULL DEFAULT false,
    completed_at timestamptz,
    due_date date,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_move_in_checklists_agreement ON move_in_checklists(agreement_id);

CREATE TRIGGER agreements_updated_at
    BEFORE UPDATE ON agreements
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
