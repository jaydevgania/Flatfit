-- 005_discovery.sql
-- Saved searches, shortlists, groups, and group members

CREATE TABLE saved_searches (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name text,
    filters jsonb NOT NULL DEFAULT '{}'::jsonb,
    alert_enabled boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_saved_searches_user ON saved_searches(user_id);

CREATE TABLE shortlists (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    shortlisted_user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_id, shortlisted_user_id),
    CHECK (user_id != shortlisted_user_id)
);

CREATE INDEX idx_shortlists_user ON shortlists(user_id);
CREATE INDEX idx_shortlists_shortlisted ON shortlists(shortlisted_user_id);

-- Groups for 2-4 friends looking together
CREATE TABLE groups (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    created_by uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    max_members int NOT NULL DEFAULT 4 CHECK (max_members >= 2 AND max_members <= 4),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_groups_created_by ON groups(created_by);

CREATE TABLE group_members (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_id uuid NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    joined_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(group_id, user_id)
);

CREATE INDEX idx_group_members_group ON group_members(group_id);
CREATE INDEX idx_group_members_user ON group_members(user_id);

CREATE TRIGGER saved_searches_updated_at
    BEFORE UPDATE ON saved_searches
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
