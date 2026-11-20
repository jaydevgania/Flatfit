-- 001_extensions.sql
-- Enable required PostgreSQL extensions for FlatFit

-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;

-- PostGIS for geographic queries (location-based matching)
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA extensions;

-- Trigram matching for fuzzy text search
CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA extensions;
