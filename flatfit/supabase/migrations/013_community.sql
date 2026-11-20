-- 013_community.sql
-- City guides, events, RSVPs, referrals, ambassadors

CREATE TABLE city_guides (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    city text NOT NULL DEFAULT 'Mumbai',
    locality text NOT NULL,
    content jsonb NOT NULL DEFAULT '{}'::jsonb,
    -- content: { "description": "...", "highlights": [...], "nearby": [...], "transport": [...] }
    budget_range text, -- e.g. '10000-20000'
    vibe text, -- e.g. 'lively', 'quiet', 'student-friendly'
    commute_info jsonb DEFAULT '{}'::jsonb,
    -- commute_info: { "metro": "5 min walk", "bus": "multiple routes", "train": "Andheri station 10 min" }
    safety_rating int CHECK (safety_rating >= 1 AND safety_rating <= 5),
    cover_image_url text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_city_guides_city ON city_guides(city);
CREATE INDEX idx_city_guides_locality ON city_guides(locality);

CREATE TABLE events (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    city text NOT NULL DEFAULT 'Mumbai',
    title text NOT NULL,
    description text,
    date timestamptz NOT NULL,
    end_date timestamptz,
    location text,
    location_point geography(POINT, 4326),
    type text NOT NULL DEFAULT 'meetup', -- meetup, workshop, house_party, networking
    cover_image_url text,
    max_attendees int,
    is_free boolean NOT NULL DEFAULT true,
    fee numeric(10,2),
    organizer_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
    status text NOT NULL DEFAULT 'upcoming', -- upcoming, ongoing, completed, cancelled
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_events_city ON events(city);
CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_events_type ON events(type);
CREATE INDEX idx_events_location ON events USING GIST(location_point);
CREATE INDEX idx_events_status ON events(status);

CREATE TABLE event_rsvps (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    status text NOT NULL DEFAULT 'going', -- going, interested, not_going
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(event_id, user_id)
);

CREATE INDEX idx_event_rsvps_event ON event_rsvps(event_id);
CREATE INDEX idx_event_rsvps_user ON event_rsvps(user_id);

CREATE TYPE referral_status AS ENUM ('pending', 'signed_up', 'rewarded', 'expired');

CREATE TABLE referrals (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    referrer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    referee_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
    code text NOT NULL UNIQUE,
    status referral_status NOT NULL DEFAULT 'pending',
    reward_amount numeric(10,2) DEFAULT 0,
    reward_type text DEFAULT 'credit', -- credit, cashback, subscription_extension
    created_at timestamptz NOT NULL DEFAULT now(),
    redeemed_at timestamptz
);

CREATE INDEX idx_referrals_referrer ON referrals(referrer_id);
CREATE INDEX idx_referrals_code ON referrals(code);
CREATE INDEX idx_referrals_referee ON referrals(referee_id);

CREATE TYPE ambassador_type AS ENUM ('college', 'company');

CREATE TABLE ambassadors (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type ambassador_type NOT NULL,
    institution text NOT NULL,
    code text NOT NULL UNIQUE,
    referral_count int NOT NULL DEFAULT 0,
    commission_earned numeric(10,2) NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_ambassadors_user ON ambassadors(user_id);
CREATE INDEX idx_ambassadors_code ON ambassadors(code);
CREATE INDEX idx_ambassadors_type ON ambassadors(type);

CREATE TRIGGER city_guides_updated_at
    BEFORE UPDATE ON city_guides
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
