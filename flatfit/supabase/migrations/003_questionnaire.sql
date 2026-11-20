-- 003_questionnaire.sql
-- Compatibility questionnaire: questions and user answers

CREATE TYPE question_topic AS ENUM (
    'sleep', 'cleanliness', 'food', 'cooking', 'smoking', 'drinking',
    'guests', 'noise', 'pets', 'wfh', 'bills', 'rent_punctuality',
    'introvert_extrovert', 'conflict'
);

CREATE TYPE answer_importance AS ENUM ('deal_breaker', 'important', 'nice_to_have');

CREATE TABLE questions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic question_topic NOT NULL,
    question_text text NOT NULL,
    question_text_hi text, -- Hindi translation
    options jsonb NOT NULL DEFAULT '[]'::jsonb,
    display_order int NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_questions_topic ON questions(topic);
CREATE INDEX idx_questions_display_order ON questions(display_order);

CREATE TABLE user_answers (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    question_id uuid NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    answer text NOT NULL,
    importance answer_importance NOT NULL DEFAULT 'nice_to_have',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE(user_id, question_id)
);

CREATE INDEX idx_user_answers_user ON user_answers(user_id);
CREATE INDEX idx_user_answers_question ON user_answers(question_id);
CREATE INDEX idx_user_answers_importance ON user_answers(importance);

CREATE TRIGGER user_answers_updated_at
    BEFORE UPDATE ON user_answers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
