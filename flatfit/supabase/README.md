# FlatFit Supabase Backend Architecture

FlatFit is a compatibility-first flatmate matching and living management platform designed specifically for young professionals and students in urban India (e.g., Mumbai, Bengaluru, Delhi NCR, Pune).

This repository contains the complete Supabase backend specification, PostgreSQL migrations, Row Level Security (RLS) policies, Edge Functions (Deno/TypeScript), and comprehensive demo seed data.

---

## 📁 Directory Structure

```
flatfit/supabase/
├── migrations/
│   ├── 001_extensions.sql          -- uuid-ossp, postgis, pg_trgm
│   ├── 002_auth_profiles.sql       -- profiles, profile_photos, voice_intros
│   ├── 003_questionnaire.sql       -- questions, user_answers (importance: deal_breaker/important/nice_to_have)
│   ├── 004_matching.sql            -- precomputed_matches, interests
│   ├── 005_discovery.sql           -- saved_searches, shortlists, groups, group_members
│   ├── 006_chat.sql                -- conversations, conversation_members, messages, blocked_users, reports
│   ├── 007_listings.sql            -- listings, listing_photos, listing_amenities
│   ├── 008_verification.sql        -- verifications, trust_scores, reviews
│   ├── 009_agreements.sql          -- agreements, agreement_signatures, move_in_checklists
│   ├── 010_living.sql              -- flats, flat_members, expenses, expense_splits, chores, chore_assignments, calendar_events, notices, grocery_items, house_inventory
│   ├── 011_payments.sql            -- payments, subscriptions, feature_flags
│   ├── 012_services.sql            -- service_partners, service_bookings, service_reviews
│   ├── 013_community.sql           -- city_guides, events, event_rsvps, referrals, ambassadors
│   ├── 014_b2b.sql                 -- corporate_accounts, college_accounts, operator_accounts, broker_accounts
│   ├── 015_notifications.sql       -- notifications, notification_preferences, push_tokens
│   ├── 016_admin.sql               -- admin_users, moderation_queue, disputes, audit_logs, analytics_events
│   └── 017_rls_policies.sql        -- Strict Row Level Security policies for all tables
├── edge-functions/
│   ├── compute-matches/index.ts    -- Compatibility engine background job (hard filters + weighted scoring)
│   ├── send-notification/index.ts  -- Push / WhatsApp / SMS / Email multi-provider dispatcher
│   ├── verify-kyc/index.ts         -- Mock KYC verification (Aadhaar / PAN / Passport) + Trust Score updater
│   ├── process-payment/index.ts    -- Mock Razorpay order creation and verification + Subscription activation
│   ├── ai-service/index.ts         -- Provider-agnostic LLM interface (Gemini / OpenAI / Heuristic fallback)
│   ├── listing-quality/index.ts    -- Automated listing score calculator (0-100)
│   └── analytics/index.ts          -- Funnel event tracking ingestion
├── seed/
│   ├── generate_seed.py            -- Deterministic Python seed generator
│   └── seed.sql                    -- 50 Mumbai demo users, 15 listings, sample flat 'Sunshine 301', etc.
└── README.md                       -- Database schema documentation & operational runbook
```

---

## 🗄️ Entity-Relationship (ER) Overview

### 1. Identity & Profiles
- **`profiles`**: Extends `auth.users(id)` 1-to-1. Contains bio, age, gender, occupation, location coordinates (`geography(POINT, 4326)`), budget range (`budget_min`, `budget_max`), preferred localities, and housing goal (`need_room`, `have_room`, `looking_together`).
- **`profile_photos`**: 1-to-many from `profiles`. Up to 5 ranked photos per user.
- **`voice_intros`**: Audio introduction snippet (up to 120s) for authentic personal discovery.
- **`verifications`**: Multi-factor trust verification records (Phone, KYC, LinkedIn, College Email, Employer Domain).
- **`trust_scores`**: Calculated 0-100 score dynamically compiled from verified credentials, response times, and peer reviews.

### 2. Compatibility & Matching Engine
- **`questions`**: Standardized lifestyle questions across 14 critical flatmate topics:
  `sleep`, `cleanliness`, `food`, `cooking`, `smoking`, `drinking`, `guests`, `noise`, `pets`, `wfh`, `bills`, `rent_punctuality`, `introvert_extrovert`, `conflict`. Includes bilingual Hindi (`question_text_hi`) and English copy.
- **`user_answers`**: Answers per user, weighted by importance:
  - `deal_breaker`: Any clash triggers an instant match reject.
  - `important`: High weight (15 points) in compatibility score.
  - `nice_to_have`: Normal weight (5 points).
- **`precomputed_matches`**: Canonical pairwise scores `(user_a, user_b)` where `user_a < user_b`, precomputed via background job or on profile updates.
- **`interests`**: Directed match connection request (`from_user -> to_user`) with statuses `pending`, `accepted`, `declined`.

### 3. Property Listings & Discovery
- **`listings`**: Rooms or full flats posted by flatmates (`type: have_room`) or searchers (`type: need_flatmate`). Includes PostGIS geo-points, locality, rent, deposit, maintenance, furnishing type, and house rules (`jsonb`).
- **`listing_photos` & `listing_amenities`**: Media and amenities (WiFi, AC, Cook, Maid, Gym, etc.).
- **`saved_searches` & `shortlists`**: User search preferences and bookmarking.

### 4. Living Management (Shared Apartment Space)
- **`flats`**: A shared residence containing co-tenants.
- **`flat_members`**: Co-tenants mapped to flats with roles (`admin` or `member`).
- **`expenses` & `expense_splits`**: Expense tracker with categories (`rent`, `electricity`, `wifi`, `groceries`, `cook`, `maid`, `other`), receipts, and member-level settlement tracking.
- **`chores` & `chore_assignments`**: Recurring chores (daily, weekly, monthly) with rotation and due dates.
- **`calendar_events`**: Flat calendar for guests staying over, parties, power cuts, and maintenance visits.
- **`notices`**: Pinned internal bulletin notices for house rules and announcements.
- **`grocery_items`**: Shared shopping checklist with real-time status.
- **`house_inventory`**: Shared assets (refrigerator, microwave, router, couch) with purchase costs and ownership.

### 5. Chat, Agreements, Disputes & Trust
- **`conversations` & `messages`**: 1-on-1 direct or group chats with real-time support.
- **`agreements` & `agreement_signatures`**: Digital FlatFit flatmate agreements with custom clauses, rent distribution, notice periods, and IP-logged signatures.
- **`reviews`**: Peer reviews with tag badges (`'great_with_chores'`, `'pays_on_time'`, etc.).
- **`disputes`**: Conflict escalation system for security deposits, damage claims, or notice breaches.

### 6. Subscriptions, Payments & B2B
- **`payments` & `subscriptions`**: Razorpay transaction tracking and FlatFit Plus subscription plans.
- **`corporate_accounts`, `college_accounts`, `operator_accounts`, `broker_accounts`**: B2B integrations for universities, verified employers, PG operators, and registered brokers.

---

## 🔒 Row Level Security (RLS) Strategy

All tables enforce Row Level Security:
- **Profiles**: Public read for active discovery; write restricted strictly to owner (`id = auth.uid()`).
- **Questionnaire Answers**: Readable and editable only by the specific user.
- **Chat & Messaging**: Access restricted to conversation members verified via `is_conversation_member()` security definer function.
- **Flat Operations**: Expenses, chores, calendar, grocery, and notices are isolated strictly to active flat members verified via `is_flat_member()`.
- **Listings**: Active listings are visible to all; drafts and management restricted to listing owner.
- **Admin Tables**: Audited logs, moderation queue, disputes, and B2B configurations restricted to users with `is_admin()`.

---

## ⚡ Edge Functions

### 1. `compute-matches`
Background job that pairs active users in the same city:
- **Hard Filters**:
  1. Gender preference match (instant reject if mismatched).
  2. Budget overlap $\ge 20\%$ (instant reject if below).
  3. Move-in date within 30 days.
  4. PostGIS distance within 15 km.
  5. Any conflicting answer marked as `deal_breaker` causes instant rejection.
- **Scoring**: Computes weighted score (0–100) from remaining questionnaire topics and upserts to `precomputed_matches`.

### 2. `send-notification`
Abstract provider interface for transactional notifications:
- Dispatches across Push (FCM), WhatsApp (Gupshup/Twilio), SMS, or Email.
- Respects user channel preferences in `notification_preferences`.
- Writes persistent record into `notifications` table.

### 3. `verify-kyc`
Mock identity provider verification:
- Validates Indian KYC documents (Aadhaar 12-digit, PAN alphanumeric format, Passport).
- Updates `verifications` table with verified timestamp and provider reference.
- Automatically recalibrates and increments the user's `trust_scores` (adding 25 points).

### 4. `process-payment`
Handles Razorpay end-to-end checkout lifecycle:
- Action `create_order`: Generates Razorpay Order ID, persists pending record in `payments`.
- Action `verify_payment`: Verifies payment signature, marks completed, activates `subscriptions` for FlatFit Plus (30 days), and logs to `audit_logs`.

### 5. `ai-service`
Provider-agnostic LLM interface with support for Google Gemini (`gemini-1.5-flash`), OpenAI (`gpt-3.5-turbo`), and intelligent deterministic fallbacks:
- Generates natural, engaging flatmate bios based on questionnaire habits.
- Synthesizes 2-sentence match compatibility summaries (highlighting shared values and watch-outs).
- Enhances property listing descriptions for higher conversion.

### 6. `listing-quality`
Evaluates property listing completeness on a 0–100 scale:
- Evaluates photo count ($\ge 4$ photos = 25 pts), title/description depth (20 pts), amenity checklist (15 pts), exact coordinates (15 pts), house rules (10 pts), and verified owner status (15 pts).
- Updates `listings.quality_score` and activates `is_verified` badge when score $\ge 70$.

### 7. `analytics`
Ingests user funnel telemetry into `analytics_events` (signup, search, match discovery, direct message, agreement signature, payment).

---

## 🚀 How to Run Migrations & Seed Data

### Prerequisites
- Supabase CLI installed (`npm install -g supabase` or `brew install supabase/tap/supabase`)
- Docker Desktop running (for local Supabase instance)

### Local Development Setup
1. **Initialize Supabase**:
   ```bash
   cd flatfit
   supabase init
   ```
2. **Start Local Supabase Stack**:
   ```bash
   supabase start
   ```
3. **Run All Migrations Sequentially**:
   The migrations in `supabase/migrations/` are ordered from `001_` through `017_`.
   ```bash
   supabase db reset
   ```
   *Note: `supabase db reset` applies all migrations in `supabase/migrations/` and then runs `supabase/seed/seed.sql`.*

### Executing Migrations Against a Remote Supabase Project
To link and push migrations to your Supabase project:
```bash
# Link remote project
supabase link --project-ref your-project-ref

# Push migrations
supabase db push

# Run seed script
supabase db execute --file ./supabase/seed/seed.sql
```

Alternatively via `psql`:
```bash
for file in supabase/migrations/*.sql; do
  psql "$DATABASE_URL" -f "$file"
done
psql "$DATABASE_URL" -f supabase/seed/seed.sql
```

---

## 🔑 Environment Variables

Set the following secrets in your Supabase project dashboard or `.env.local`:

| Variable | Description |
| :--- | :--- |
| `SUPABASE_URL` | Your Supabase Project API URL (`https://xyz.supabase.co` or `http://localhost:54321`) |
| `SUPABASE_ANON_KEY` | Public anonymous key for client-side Flutter requests |
| `SUPABASE_SERVICE_ROLE_KEY` | Privileged service key for Edge Functions and background workers |
| `GEMINI_API_KEY` | Google Gemini API key for AI bio generation and compatibility explanations |
| `OPENAI_API_KEY` | (Optional) OpenAI API key for alternative LLM provider |
| `RAZORPAY_KEY_ID` | Razorpay Merchant Key ID for payment checkout |
| `RAZORPAY_KEY_SECRET` | Razorpay Secret for webhook signature verification |
