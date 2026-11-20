-- 016_admin.sql
-- Admin users, moderation queue, disputes, audit logs, analytics events

CREATE TYPE admin_role AS ENUM ('superadmin', 'moderator', 'support');
CREATE TYPE moderation_content_type AS ENUM ('photo', 'text', 'listing', 'report');
CREATE TYPE moderation_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE dispute_type AS ENUM ('deposit', 'notice_period', 'damage', 'harassment', 'other');
CREATE TYPE dispute_status AS ENUM ('open', 'in_progress', 'resolved', 'escalated');

CREATE TABLE admin_users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    email text NOT NULL UNIQUE,
    full_name text,
    role admin_role NOT NULL DEFAULT 'support',
    permissions jsonb DEFAULT '[]'::jsonb,
    is_active boolean NOT NULL DEFAULT true,
    last_login_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_admin_users_role ON admin_users(role);
CREATE INDEX idx_admin_users_email ON admin_users(email);

CREATE TABLE moderation_queue (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    type moderation_content_type NOT NULL,
    content_ref text NOT NULL, -- reference to the content (URL, ID, etc.)
    content_preview text,
    reported_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
    report_id uuid REFERENCES reports(id) ON DELETE SET NULL,
    status moderation_status NOT NULL DEFAULT 'pending',
    priority int NOT NULL DEFAULT 0, -- higher = more urgent
    reviewed_by uuid REFERENCES admin_users(id) ON DELETE SET NULL,
    review_notes text,
    reviewed_at timestamptz,
    auto_flagged boolean NOT NULL DEFAULT false,
    auto_flag_reason text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_moderation_queue_status ON moderation_queue(status);
CREATE INDEX idx_moderation_queue_type ON moderation_queue(type);
CREATE INDEX idx_moderation_queue_priority ON moderation_queue(priority DESC) WHERE status = 'pending';

CREATE TABLE disputes (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    raised_by uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    against_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    flat_id uuid REFERENCES flats(id) ON DELETE SET NULL,
    type dispute_type NOT NULL,
    description text NOT NULL,
    evidence_urls text[] DEFAULT '{}',
    amount_disputed numeric(10,2),
    status dispute_status NOT NULL DEFAULT 'open',
    resolution text,
    resolved_by uuid REFERENCES admin_users(id) ON DELETE SET NULL,
    resolved_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (raised_by != against_id)
);

CREATE INDEX idx_disputes_raised_by ON disputes(raised_by);
CREATE INDEX idx_disputes_against ON disputes(against_id);
CREATE INDEX idx_disputes_status ON disputes(status);
CREATE INDEX idx_disputes_flat ON disputes(flat_id);

CREATE TABLE audit_logs (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid, -- can be null for system actions
    admin_id uuid REFERENCES admin_users(id) ON DELETE SET NULL,
    action text NOT NULL, -- e.g. 'profile.update', 'listing.create', 'payment.process'
    entity_type text NOT NULL, -- e.g. 'profile', 'listing', 'payment'
    entity_id text, -- UUID or other ID
    old_data jsonb,
    new_data jsonb,
    metadata jsonb DEFAULT '{}'::jsonb,
    ip_address inet,
    user_agent text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

CREATE TABLE analytics_events (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
    session_id text,
    event_name text NOT NULL, -- e.g. 'profile_viewed', 'listing_clicked', 'match_opened', 'interest_sent'
    event_category text, -- engagement, conversion, retention, monetization
    properties jsonb DEFAULT '{}'::jsonb,
    -- properties: { "source": "discover", "listing_id": "...", "match_score": 85 }
    platform text, -- android, ios, web
    app_version text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_analytics_events_user ON analytics_events(user_id);
CREATE INDEX idx_analytics_events_name ON analytics_events(event_name);
CREATE INDEX idx_analytics_events_category ON analytics_events(event_category);
CREATE INDEX idx_analytics_events_created ON analytics_events(created_at DESC);

CREATE TRIGGER disputes_updated_at
    BEFORE UPDATE ON disputes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
