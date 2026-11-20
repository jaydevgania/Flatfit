-- 006_chat.sql
-- Conversations, messages, blocked users, and reports

CREATE TYPE conversation_type AS ENUM ('direct', 'group');
CREATE TYPE message_type AS ENUM ('text', 'image', 'voice', 'system');
CREATE TYPE report_status AS ENUM ('pending', 'reviewed', 'resolved');

CREATE TABLE conversations (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    type conversation_type NOT NULL DEFAULT 'direct',
    title text, -- for group chats
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE conversation_members (
    conversation_id uuid NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    joined_at timestamptz NOT NULL DEFAULT now(),
    last_read_at timestamptz,
    is_muted boolean NOT NULL DEFAULT false,
    PRIMARY KEY (conversation_id, user_id)
);

CREATE INDEX idx_conversation_members_user ON conversation_members(user_id);
CREATE INDEX idx_conversation_members_conv ON conversation_members(conversation_id);

CREATE TABLE messages (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id uuid NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    content text,
    type message_type NOT NULL DEFAULT 'text',
    metadata jsonb, -- for image URLs, voice duration, etc.
    is_deleted boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);
CREATE INDEX idx_messages_sender ON messages(sender_id);

CREATE TABLE blocked_users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    blocker_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    blocked_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    reason text,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(blocker_id, blocked_id),
    CHECK (blocker_id != blocked_id)
);

CREATE INDEX idx_blocked_blocker ON blocked_users(blocker_id);
CREATE INDEX idx_blocked_blocked ON blocked_users(blocked_id);

CREATE TABLE reports (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    reported_user_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
    reported_listing_id uuid, -- FK added after listings table
    reported_message_id uuid REFERENCES messages(id) ON DELETE SET NULL,
    reason text NOT NULL,
    description text,
    evidence_urls text[] DEFAULT '{}',
    status report_status NOT NULL DEFAULT 'pending',
    resolution text,
    resolved_by uuid,
    resolved_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_reports_reporter ON reports(reporter_id);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_reported_user ON reports(reported_user_id);
