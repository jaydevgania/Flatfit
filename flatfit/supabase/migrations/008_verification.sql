-- 008_verification.sql
-- User verifications, trust scores, reviews

CREATE TYPE verification_type AS ENUM ('phone', 'kyc', 'employer_email', 'college_email', 'linkedin');
CREATE TYPE verification_status AS ENUM ('pending', 'verified', 'failed');

CREATE TABLE verifications (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type verification_type NOT NULL,
    status verification_status NOT NULL DEFAULT 'pending',
    provider_ref text,
    data jsonb, -- provider-specific data
    verified_at timestamptz,
    expires_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_id, type)
);

CREATE INDEX idx_verifications_user ON verifications(user_id);
CREATE INDEX idx_verifications_status ON verifications(status);

CREATE TABLE trust_scores (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
    score int NOT NULL DEFAULT 0 CHECK (score >= 0 AND score <= 100),
    factors jsonb NOT NULL DEFAULT '{}'::jsonb,
    -- factors: { "profile_complete": 20, "phone_verified": 15, "kyc_done": 25, "reviews_avg": 20, "response_rate": 10, "time_on_platform": 10 }
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_trust_scores_user ON trust_scores(user_id);
CREATE INDEX idx_trust_scores_score ON trust_scores(score DESC);

CREATE TABLE reviews (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    reviewer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    reviewee_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    flat_id uuid, -- FK added after flats table
    rating int CHECK (rating >= 1 AND rating <= 5),
    comment text,
    tags text[] DEFAULT '{}', -- e.g. 'great_with_chores', 'pays_on_time', 'respectful', 'noisy'
    private_feedback text,
    stay_duration_months int,
    is_anonymous boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (reviewer_id != reviewee_id)
);

CREATE INDEX idx_reviews_reviewer ON reviews(reviewer_id);
CREATE INDEX idx_reviews_reviewee ON reviews(reviewee_id);
CREATE INDEX idx_reviews_tags ON reviews USING GIN(tags);

CREATE TRIGGER trust_scores_updated_at
    BEFORE UPDATE ON trust_scores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
