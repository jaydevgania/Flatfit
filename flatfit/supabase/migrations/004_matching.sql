-- 004_matching.sql
-- Precomputed matches, match scores, and interest expressions

CREATE TYPE interest_status AS ENUM ('pending', 'accepted', 'declined');

CREATE TABLE precomputed_matches (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_a uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    user_b uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    score int NOT NULL CHECK (score >= 0 AND score <= 100),
    compatible_topics text[] DEFAULT '{}',
    watch_out_topics text[] DEFAULT '{}',
    computed_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_a, user_b),
    CHECK (user_a < user_b) -- canonical ordering: smaller UUID first
);

CREATE INDEX idx_matches_user_a ON precomputed_matches(user_a);
CREATE INDEX idx_matches_user_b ON precomputed_matches(user_b);
CREATE INDEX idx_matches_score ON precomputed_matches(score DESC);
CREATE INDEX idx_matches_computed_at ON precomputed_matches(computed_at);
CREATE INDEX idx_matches_composite ON precomputed_matches(user_a, user_b);

CREATE TABLE interests (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_user uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    to_user uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    note text,
    status interest_status NOT NULL DEFAULT 'pending',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(from_user, to_user),
    CHECK (from_user != to_user)
);

CREATE INDEX idx_interests_from ON interests(from_user);
CREATE INDEX idx_interests_to ON interests(to_user);
CREATE INDEX idx_interests_status ON interests(status);
CREATE INDEX idx_interests_composite ON interests(from_user, to_user);

CREATE TRIGGER interests_updated_at
    BEFORE UPDATE ON interests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
