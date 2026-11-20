-- 007_listings.sql
-- Property listings, photos, amenities

CREATE TYPE listing_type AS ENUM ('have_room', 'need_flatmate');
CREATE TYPE listing_status AS ENUM ('active', 'paused', 'filled');
CREATE TYPE furnishing_type AS ENUM ('fully_furnished', 'semi_furnished', 'unfurnished');
CREATE TYPE room_type AS ENUM ('single', 'shared', 'master', 'hall');

CREATE TABLE listings (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type listing_type NOT NULL,
    title text NOT NULL,
    description text,
    rent numeric(10,2) NOT NULL CHECK (rent > 0),
    deposit numeric(10,2) DEFAULT 0,
    maintenance numeric(10,2) DEFAULT 0,
    furnishing furnishing_type,
    location geography(POINT, 4326),
    locality text NOT NULL,
    city text NOT NULL DEFAULT 'Mumbai',
    address text,
    room_type room_type,
    bhk_type text, -- '1BHK', '2BHK', '3BHK', etc.
    floor_number int,
    total_floors int,
    availability_date date,
    is_sublet boolean NOT NULL DEFAULT false,
    is_short_stay boolean NOT NULL DEFAULT false,
    min_stay_months int,
    quality_score int DEFAULT 0 CHECK (quality_score >= 0 AND quality_score <= 100),
    is_verified boolean NOT NULL DEFAULT false,
    house_rules jsonb DEFAULT '{}'::jsonb,
    current_flatmates_count int DEFAULT 0,
    preferred_gender gender_type,
    preferred_occupation occupation_type,
    preferred_age_min int,
    preferred_age_max int,
    views_count int NOT NULL DEFAULT 0,
    status listing_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_listings_owner ON listings(owner_id);
CREATE INDEX idx_listings_city ON listings(city);
CREATE INDEX idx_listings_locality ON listings(locality);
CREATE INDEX idx_listings_rent ON listings(rent);
CREATE INDEX idx_listings_status ON listings(status);
CREATE INDEX idx_listings_type ON listings(type);
CREATE INDEX idx_listings_location ON listings USING GIST(location);
CREATE INDEX idx_listings_availability ON listings(availability_date);
CREATE INDEX idx_listings_active ON listings(status) WHERE status = 'active';

CREATE TABLE listing_photos (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    listing_id uuid NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
    url text NOT NULL,
    position int NOT NULL DEFAULT 1,
    caption text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_listing_photos_listing ON listing_photos(listing_id);

CREATE TABLE listing_amenities (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    listing_id uuid NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
    amenity text NOT NULL,
    UNIQUE(listing_id, amenity)
);

CREATE INDEX idx_listing_amenities_listing ON listing_amenities(listing_id);

-- Add FK for reports.reported_listing_id
ALTER TABLE reports ADD CONSTRAINT fk_reports_listing
    FOREIGN KEY (reported_listing_id) REFERENCES listings(id) ON DELETE SET NULL;

CREATE TRIGGER listings_updated_at
    BEFORE UPDATE ON listings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
