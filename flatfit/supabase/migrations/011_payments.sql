-- 011_payments.sql
-- Payments, subscriptions, feature flags

CREATE TYPE payment_type AS ENUM ('subscription', 'service', 'listing_fee', 'rent_collection');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE subscription_plan AS ENUM ('free', 'plus');

CREATE TABLE payments (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    amount numeric(10,2) NOT NULL CHECK (amount > 0),
    currency text NOT NULL DEFAULT 'INR',
    type payment_type NOT NULL,
    status payment_status NOT NULL DEFAULT 'pending',
    provider text DEFAULT 'razorpay',
    provider_ref text, -- Razorpay payment_id
    provider_order_id text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_type ON payments(type);
CREATE INDEX idx_payments_provider_ref ON payments(provider_ref);

CREATE TABLE subscriptions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    plan subscription_plan NOT NULL DEFAULT 'free',
    starts_at timestamptz NOT NULL DEFAULT now(),
    ends_at timestamptz,
    is_active boolean NOT NULL DEFAULT true,
    payment_id uuid REFERENCES payments(id) ON DELETE SET NULL,
    auto_renew boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_active ON subscriptions(user_id) WHERE is_active = true;
CREATE INDEX idx_subscriptions_plan ON subscriptions(plan);

CREATE TABLE feature_flags (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL UNIQUE,
    description text,
    is_enabled boolean NOT NULL DEFAULT false,
    target_users jsonb DEFAULT 'null'::jsonb, -- null = all, or ["user-id-1", "user-id-2"]
    target_plans text[] DEFAULT '{}', -- ['plus'] or ['free', 'plus']
    rollout_percentage int DEFAULT 100 CHECK (rollout_percentage >= 0 AND rollout_percentage <= 100),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER payments_updated_at
    BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER feature_flags_updated_at
    BEFORE UPDATE ON feature_flags
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
