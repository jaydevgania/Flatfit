-- 014_b2b.sql
-- Corporate accounts, college accounts, operator accounts, broker accounts

CREATE TABLE corporate_accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_name text NOT NULL,
    contact_email text NOT NULL,
    contact_phone text,
    plan text NOT NULL DEFAULT 'basic', -- basic, premium, enterprise
    logo_url text,
    employee_count int DEFAULT 0,
    max_employees int DEFAULT 100,
    domains text[] DEFAULT '{}', -- allowed email domains for auto-verification
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_corporate_accounts_company ON corporate_accounts(company_name);
CREATE INDEX idx_corporate_accounts_active ON corporate_accounts(is_active) WHERE is_active = true;

CREATE TABLE college_accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    institution_name text NOT NULL,
    contact_email text NOT NULL,
    contact_phone text,
    plan text NOT NULL DEFAULT 'basic',
    logo_url text,
    student_count int DEFAULT 0,
    max_students int DEFAULT 500,
    domains text[] DEFAULT '{}', -- .edu domains
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_college_accounts_institution ON college_accounts(institution_name);

CREATE TYPE operator_type AS ENUM ('pg', 'coliving');

CREATE TABLE operator_accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    type operator_type NOT NULL,
    contact_email text,
    contact_phone text,
    properties_count int NOT NULL DEFAULT 0,
    cities text[] DEFAULT '{}',
    commission_pct numeric(4,2) DEFAULT 5.00,
    is_verified boolean NOT NULL DEFAULT false,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_operator_accounts_type ON operator_accounts(type);
CREATE INDEX idx_operator_accounts_active ON operator_accounts(is_active) WHERE is_active = true;

CREATE TABLE broker_accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    contact_email text,
    contact_phone text NOT NULL,
    rera_number text, -- Real Estate Regulatory Authority registration
    cities text[] DEFAULT '{}',
    listings_count int NOT NULL DEFAULT 0,
    max_listings int DEFAULT 50,
    commission_pct numeric(4,2) DEFAULT 8.33, -- standard 1-month brokerage
    is_verified boolean NOT NULL DEFAULT false,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_broker_accounts_active ON broker_accounts(is_active) WHERE is_active = true;

CREATE TRIGGER corporate_accounts_updated_at
    BEFORE UPDATE ON corporate_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER college_accounts_updated_at
    BEFORE UPDATE ON college_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER operator_accounts_updated_at
    BEFORE UPDATE ON operator_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER broker_accounts_updated_at
    BEFORE UPDATE ON broker_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
