-- 012_services.sql
-- Service partners, bookings, and reviews

CREATE TYPE service_category AS ENUM (
    'movers', 'furniture_rental', 'cleaning', 'laundry',
    'maid', 'cook', 'repairs', 'wifi_setup', 'insurance'
);
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');

CREATE TABLE service_partners (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    category service_category NOT NULL,
    description text,
    city text NOT NULL DEFAULT 'Mumbai',
    localities text[] DEFAULT '{}',
    rating numeric(2,1) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
    total_reviews int NOT NULL DEFAULT 0,
    contact_phone text,
    contact_email text,
    website text,
    logo_url text,
    is_active boolean NOT NULL DEFAULT true,
    commission_pct numeric(4,2) DEFAULT 10.00,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_service_partners_category ON service_partners(category);
CREATE INDEX idx_service_partners_city ON service_partners(city);
CREATE INDEX idx_service_partners_rating ON service_partners(rating DESC);

CREATE TABLE service_bookings (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    partner_id uuid NOT NULL REFERENCES service_partners(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    flat_id uuid REFERENCES flats(id) ON DELETE SET NULL,
    status booking_status NOT NULL DEFAULT 'pending',
    amount numeric(10,2),
    commission numeric(10,2),
    scheduled_at timestamptz,
    notes text,
    booked_at timestamptz NOT NULL DEFAULT now(),
    completed_at timestamptz
);

CREATE INDEX idx_service_bookings_partner ON service_bookings(partner_id);
CREATE INDEX idx_service_bookings_user ON service_bookings(user_id);
CREATE INDEX idx_service_bookings_status ON service_bookings(status);

CREATE TABLE service_reviews (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id uuid NOT NULL REFERENCES service_bookings(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    partner_id uuid NOT NULL REFERENCES service_partners(id) ON DELETE CASCADE,
    rating int NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_service_reviews_partner ON service_reviews(partner_id);
CREATE INDEX idx_service_reviews_booking ON service_reviews(booking_id);
