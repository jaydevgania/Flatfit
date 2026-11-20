-- 015_notifications.sql
-- Notifications and notification preferences

CREATE TYPE notification_channel AS ENUM ('push', 'whatsapp', 'sms', 'email');

CREATE TABLE notifications (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title text NOT NULL,
    body text NOT NULL,
    type text NOT NULL, -- match_found, interest_received, message, expense_added, chore_due, listing_alert, system
    data jsonb DEFAULT '{}'::jsonb,
    -- data: { "match_id": "...", "user_id": "...", "listing_id": "..." }
    action_url text,
    is_read boolean NOT NULL DEFAULT false,
    read_at timestamptz,
    channel notification_channel DEFAULT 'push',
    sent_at timestamptz,
    delivered_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE is_read = false;
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);

CREATE TABLE notification_preferences (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    channel notification_channel NOT NULL,
    enabled boolean NOT NULL DEFAULT true,
    -- Granular preferences
    match_alerts boolean NOT NULL DEFAULT true,
    message_alerts boolean NOT NULL DEFAULT true,
    expense_alerts boolean NOT NULL DEFAULT true,
    chore_alerts boolean NOT NULL DEFAULT true,
    listing_alerts boolean NOT NULL DEFAULT true,
    marketing boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_id, channel)
);

CREATE INDEX idx_notification_preferences_user ON notification_preferences(user_id);

-- Device tokens for push notifications
CREATE TABLE push_tokens (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    token text NOT NULL,
    platform text NOT NULL DEFAULT 'android', -- android, ios, web
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_id, token)
);

CREATE INDEX idx_push_tokens_user ON push_tokens(user_id);

CREATE TRIGGER notification_preferences_updated_at
    BEFORE UPDATE ON notification_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
