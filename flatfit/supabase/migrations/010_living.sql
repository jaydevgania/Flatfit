-- 010_living.sql
-- Flat management: flats, members, expenses, chores, calendar, notices, grocery, inventory

CREATE TYPE flat_member_role AS ENUM ('admin', 'member');
CREATE TYPE expense_category AS ENUM ('rent', 'electricity', 'wifi', 'groceries', 'cook', 'maid', 'other');
CREATE TYPE chore_frequency AS ENUM ('daily', 'weekly', 'monthly');
CREATE TYPE calendar_event_type AS ENUM ('guest', 'party', 'maintenance', 'power_cut', 'other');

CREATE TABLE flats (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    listing_id uuid REFERENCES listings(id) ON DELETE SET NULL,
    address text,
    city text DEFAULT 'Mumbai',
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_flats_listing ON flats(listing_id);

-- Add FK for reviews.flat_id and agreements.flat_id
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_flat
    FOREIGN KEY (flat_id) REFERENCES flats(id) ON DELETE SET NULL;
ALTER TABLE agreements ADD CONSTRAINT fk_agreements_flat
    FOREIGN KEY (flat_id) REFERENCES flats(id) ON DELETE SET NULL;

CREATE TABLE flat_members (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    role flat_member_role NOT NULL DEFAULT 'member',
    joined_at timestamptz NOT NULL DEFAULT now(),
    left_at timestamptz,
    UNIQUE(flat_id, user_id)
);

CREATE INDEX idx_flat_members_flat ON flat_members(flat_id);
CREATE INDEX idx_flat_members_user ON flat_members(user_id);
CREATE INDEX idx_flat_members_active ON flat_members(flat_id) WHERE left_at IS NULL;

CREATE TABLE expenses (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    paid_by uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title text NOT NULL,
    amount numeric(10,2) NOT NULL CHECK (amount > 0),
    category expense_category NOT NULL,
    description text,
    receipt_url text,
    date date NOT NULL DEFAULT CURRENT_DATE,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_expenses_flat ON expenses(flat_id);
CREATE INDEX idx_expenses_paid_by ON expenses(paid_by);
CREATE INDEX idx_expenses_date ON expenses(date);
CREATE INDEX idx_expenses_category ON expenses(category);

CREATE TABLE expense_splits (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    expense_id uuid NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    amount numeric(10,2) NOT NULL CHECK (amount >= 0),
    is_settled boolean NOT NULL DEFAULT false,
    settled_at timestamptz,
    UNIQUE(expense_id, user_id)
);

CREATE INDEX idx_expense_splits_expense ON expense_splits(expense_id);
CREATE INDEX idx_expense_splits_user ON expense_splits(user_id);
CREATE INDEX idx_expense_splits_unsettled ON expense_splits(user_id) WHERE is_settled = false;

CREATE TABLE chores (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    frequency chore_frequency NOT NULL DEFAULT 'weekly',
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_chores_flat ON chores(flat_id);

CREATE TABLE chore_assignments (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    chore_id uuid NOT NULL REFERENCES chores(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    due_date date NOT NULL,
    completed_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_chore_assignments_chore ON chore_assignments(chore_id);
CREATE INDEX idx_chore_assignments_user ON chore_assignments(user_id);
CREATE INDEX idx_chore_assignments_due ON chore_assignments(due_date);
CREATE INDEX idx_chore_assignments_pending ON chore_assignments(user_id, due_date) WHERE completed_at IS NULL;

CREATE TABLE calendar_events (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    type calendar_event_type NOT NULL DEFAULT 'other',
    start_time timestamptz NOT NULL,
    end_time timestamptz,
    is_all_day boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_calendar_events_flat ON calendar_events(flat_id);
CREATE INDEX idx_calendar_events_time ON calendar_events(start_time, end_time);

CREATE TABLE notices (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    content text NOT NULL,
    is_pinned boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_notices_flat ON notices(flat_id);

CREATE TABLE grocery_items (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    name text NOT NULL,
    quantity text,
    added_by uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    is_bought boolean NOT NULL DEFAULT false,
    bought_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_grocery_items_flat ON grocery_items(flat_id);
CREATE INDEX idx_grocery_items_pending ON grocery_items(flat_id) WHERE is_bought = false;

CREATE TABLE house_inventory (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    flat_id uuid NOT NULL REFERENCES flats(id) ON DELETE CASCADE,
    item_name text NOT NULL,
    description text,
    bought_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
    cost numeric(10,2),
    purchase_date date,
    condition text DEFAULT 'good',
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_house_inventory_flat ON house_inventory(flat_id);
