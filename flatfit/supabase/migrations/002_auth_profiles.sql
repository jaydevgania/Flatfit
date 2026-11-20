-- 002_auth_profiles.sql
-- User profiles, photos, and voice intros

-- Enum types
CREATE TYPE housing_goal AS ENUM ('need_room', 'have_room', 'looking_together');
CREATE TYPE occupation_type AS ENUM ('working', 'student', 'freelancer');
CREATE TYPE gender_type AS ENUM ('male', 'female', 'non_binary', 'prefer_not_to_say');

CREATE TABLE profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name text NOT NULL,
    age int CHECK (age >= 18 AND age <= 99),
    gender gender_type,
    occupation occupation_type,
    company_or_college text,
    city text NOT NULL DEFAULT 'Mumbai',
    locality text,
    bio text,
    housing_goal housing_goal NOT NULL DEFAULT 'need_room',
    budget_min numeric(10,2) CHECK (budget_min >= 0),
    budget_max numeric(10,2) CHECK (budget_max >= budget_min),
    preferred_localities text[] DEFAULT '{}',
    location geography(POINT, 4326),
    move_in_date date,
    stay_duration text, -- e.g. '6 months', '1 year', 'flexible'
    gender_preference gender_type, -- preferred flatmate gender
    age_preference_min int,
    age_preference_max int,
    profile_completion int NOT NULL DEFAULT 0 CHECK (profile_completion >= 0 AND profile_completion <= 100),
    is_active boolean NOT NULL DEFAULT true,
    last_active_at timestamptz DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Indexes for profile discovery
CREATE INDEX idx_profiles_city ON profiles(city);
CREATE INDEX idx_profiles_housing_goal ON profiles(housing_goal);
CREATE INDEX idx_profiles_budget_min ON profiles(budget_min);
CREATE INDEX idx_profiles_budget_max ON profiles(budget_max);
CREATE INDEX idx_profiles_move_in_date ON profiles(move_in_date);
CREATE INDEX idx_profiles_location ON profiles USING GIST(location);
CREATE INDEX idx_profiles_preferred_localities ON profiles USING GIN(preferred_localities);
CREATE INDEX idx_profiles_is_active ON profiles(is_active) WHERE is_active = true;
CREATE INDEX idx_profiles_occupation ON profiles(occupation);

-- Profile photos (up to 5 per user)
CREATE TABLE profile_photos (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    url text NOT NULL,
    position int NOT NULL CHECK (position >= 1 AND position <= 5),
    is_primary boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(profile_id, position)
);

CREATE INDEX idx_profile_photos_profile ON profile_photos(profile_id);

-- Voice introductions
CREATE TABLE voice_intros (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    url text NOT NULL,
    duration_seconds int CHECK (duration_seconds > 0 AND duration_seconds <= 120),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_voice_intros_profile ON voice_intros(profile_id);

-- Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
