# FlatFit Admin & B2B Web Portals

The official web administration console and B2B enterprise portals for **FlatFit** — India's compatibility-first flatmate matching platform.

Built with **React 18**, **TypeScript**, **Vite**, **Tailwind CSS**, **Lucide Icons**, and designed to interface seamlessly with **Supabase** backend tables and edge functions.

---

## 🌟 Modules & Features Covered

### Module 15: B2B Enterprise Portals
1. **Corporate Relocation Dashboard (`/b2b-corporate`)**
   - **Enterprise Account Management**: Onboard companies (e.g., Google India, Razorpay, TCS) with customized plan tiers (`basic`, `premium`, `enterprise`).
   - **Domain Auto-Verification**: Whitelist corporate email domains (e.g., `razorpay.com`, `google.com`) so employees receive instant verification badges.
   - **Relocation Cohorts**: Batch-level tracking for graduate joiners and lateral transfer waves (e.g. Summer Batch, Tech Relocation Waves).
   - **Housing Subsidies & Stipends**: Direct company housing stipend allocation and disbursement telemetry.
   - **Co-Worker Compatibility Index**: Algorithmic roommate matching among colleagues based on sleep cycles, food preferences, and commute.

2. **College & University Housing (`/b2b-colleges`)**
   - **University Partnerships**: Off-campus housing rings for institutes like IIT Bombay, NMIMS, St. Xavier's.
   - **Vicinity Safety Score**: Multi-factor locality safety scoring (lighting, emergency access, gated community ratio).
   - **Curated Batch Rings**: Gender-segregated and degree-specific matchmaking groups.
   - **Guardian Verification**: DPDP-compliant parent consent validation and emergency contact tracking.

3. **PG & Co-Living Portals (`/b2b-operators`)**
   - **Operator Management**: Stanza Living, Zolo Stays, Housr, etc.
   - **Real-Time Inventory**: Total beds, occupied beds, vacancy yields, and commission fee tracking.
   - **Smart Compatibility Bed Allocation**: Algorithmic bed recommendations matching candidate lifestyle habits (sleep schedule, vegetarian/non-vegetarian, cleanliness standards, work-from-home rhythm) with existing room residents to prevent roommate conflicts.

---

### Module 16: Admin Panel and Analytics
1. **Analytics & North-Star Metrics Dashboard (`/dashboard`)**
   - **North-Star KPIs**: Successful Move-Ins (MTD), Match-to-Chat Conversion (64.2%), 90-Day Living Harmony (91.8%), Average Time to Roommate (11.4 days).
   - **Full Funnel Visualization**: Visitor ➔ Quiz Completion ➔ KYC Verified ➔ Compatibility Opened ➔ Chat Initiated ➔ Meet Scheduled ➔ Move-in & Agreement Signed.
   - **Cohort Retention**: 30-day and 90-day active retention tables with living harmony metrics.
   - **Micro-Market Locality Breakdown**: Mumbai liquidity metrics across Bandra, Andheri, Powai, Lower Parel, Goregaon, and Juhu.

2. **User Directory & KYC (`/users`)**
   - **User Dossier**: Housing goal (`need_room`, `have_room`, `looking_together`), trust scores (0-100), and profile completeness.
   - **DPDP Verification Badges**: Phone OTP, Aadhaar Masked KYC, LinkedIn, and Corporate/College domain badges.
   - **Enforcement Actions**: Ban/unban user accounts with audit reasons, manual KYC verification overrides.

3. **Listings Review & Quality (`/listings`)**
   - **Quality Score Inspector**: Automated 0-100 rating based on photo resolution, description detail, amenities, and rent reasonableness.
   - **Verification Badge**: Grant admin verified badges for authenticated listings.
   - **Moderation Actions**: Approve, pause, or reject listings with automated notifications to hosts.

4. **Trust & Safety Moderation Queue (`/moderation`)**
   - **Priority Queue**: High/Urgent triage for flagged content.
   - **Automated AI Sentinel**: Stock image detection, off-platform payment schemes (e.g. advance GPay requests), and scam phone number patterns.
   - **Fast-Action Rulings**: Dismiss flags, takedown content, or flag repeat offenders for account suspension.

5. **Dispute Desk (`/disputes`)**
   - **Deposit & Lease Arbitration**: Handling security deposit withholding, 30-day notice period violations, and property damage claims.
   - **Evidence Review**: Digital agreements with signed clauses, move-in/handover photos, and electricity bills.
   - **Binding Settlements**: Escrow deduction orders and mutual agreement recording.

6. **Security Audit Trail (`/audit-logs`)**
   - **Immutable Compliance Log**: Every administrative action (ban, reject, resolve, KYC verify) recorded with admin ID, actor name, timestamp, and IP address.
   - **JSON State Transition Diff**: Before-and-after payload snapshots for auditing.

---

## 🛠️ Tech Stack & Directory Structure

- **Framework**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Icons**: Lucide React
- **Backend & Types**: Supabase (`@supabase/supabase-js`)
- **State & Data**: Dual-mode engine — automatic connection to live Supabase backend or integrated rich mock store with full mutation support for testing without a live database.

```
flatfit-admin/
├── package.json
├── tsconfig.json
├── vite.config.ts
├── tailwind.config.js
├── postcss.config.js
├── index.html
├── src/
│   ├── App.tsx                     # Main layout & router shell
│   ├── main.tsx                    # React DOM entry point
│   ├── index.css                   # Tailwind base & utilities
│   ├── config/
│   │   └── supabase.ts             # Supabase client & environment detection
│   ├── types/
│   │   └── index.ts                # TypeScript domain models matching DB schema
│   ├── components/
│   │   ├── Sidebar.tsx             # Collapsible navigation with pending count badges
│   │   ├── Header.tsx              # City filter, DB status badge, refresh trigger
│   │   ├── MetricCard.tsx          # Responsive KPI cards with trend indicators
│   │   ├── DataTable.tsx           # Sortable, searchable, paginated data table
│   │   └── Modal.tsx               # Accessible dialog modal
│   ├── pages/
│   │   ├── Dashboard.tsx           # Funnel analytics & North-Star KPIs
│   │   ├── Users.tsx               # Directory, KYC, trust scores, ban/unban
│   │   ├── Listings.tsx            # Review listings, quality scores, pause/approve
│   │   ├── Moderation.tsx          # Flagged photos, scam messages, user reports
│   │   ├── Disputes.tsx            # Deposit disputes & notice period mediation
│   │   ├── B2BCorporate.tsx        # Corporate relocation dashboard & cohorts
│   │   ├── B2BColleges.tsx         # University off-campus housing & safety
│   │   ├── B2BOperators.tsx        # PG/co-living inventory & smart bed allocation
│   │   └── AuditLogs.tsx           # Security audit trail with diff inspector
│   └── services/
│       ├── api.ts                  # Hybrid Supabase / in-memory store API
│       └── mockData.ts             # Indian locality & Mumbai-specific mock dataset
└── README.md
```

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
cd flatfit-admin
npm install
```

### 2. Configure Environment (Optional for Live Supabase)
Create a `.env` file in `flatfit-admin/`:
```env
VITE_SUPABASE_URL=https://your-supabase-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```
*Note: If no `.env` is provided, the application runs in comprehensive Mock Demo Mode with pre-populated Mumbai data.*

### 3. Run Development Server
```bash
npm run dev
```
Open your browser at `http://localhost:3000`.

### 4. Build for Production
```bash
npm run build
```
Creates an optimized production bundle in `dist/`.
