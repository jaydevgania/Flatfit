// Domain Types for FlatFit Admin & B2B Web Portals

export type AdminRole = 'superadmin' | 'moderator' | 'support';

export interface AdminUser {
  id: string;
  user_id?: string;
  email: string;
  full_name: string;
  role: AdminRole;
  permissions: string[];
  is_active: boolean;
  last_login_at?: string;
  created_at: string;
}

// User Profiles & Verification
export type HousingGoal = 'need_room' | 'have_room' | 'looking_together';
export type OccupationType = 'working' | 'student' | 'freelancer';
export type GenderType = 'male' | 'female' | 'non_binary' | 'prefer_not_to_say';
export type VerificationType = 'phone' | 'kyc' | 'employer_email' | 'college_email' | 'linkedin';
export type VerificationStatus = 'pending' | 'verified' | 'failed';

export interface VerificationItem {
  id: string;
  user_id: string;
  type: VerificationType;
  status: VerificationStatus;
  provider_ref?: string;
  verified_at?: string;
  expires_at?: string;
  created_at: string;
}

export interface TrustScoreFactors {
  profile_complete: number;
  phone_verified: number;
  kyc_done: number;
  reviews_avg: number;
  response_rate: number;
  time_on_platform: number;
}

export interface TrustScore {
  id: string;
  user_id: string;
  score: number;
  factors: TrustScoreFactors;
  updated_at: string;
}

export interface UserProfile {
  id: string;
  full_name: string;
  email: string;
  phone?: string;
  age?: number;
  gender?: GenderType;
  occupation?: OccupationType;
  company_or_college?: string;
  city: string;
  locality?: string;
  bio?: string;
  housing_goal: HousingGoal;
  budget_min?: number;
  budget_max?: number;
  preferred_localities: string[];
  move_in_date?: string;
  stay_duration?: string;
  profile_completion: number;
  is_active: boolean;
  is_banned?: boolean;
  ban_reason?: string;
  last_active_at?: string;
  created_at: string;
  trust_score?: number;
  verifications?: {
    phone?: boolean;
    kyc?: boolean;
    employer_email?: boolean;
    college_email?: boolean;
    linkedin?: boolean;
  };
  avatar_url?: string;
}

// Listings
export type ListingType = 'have_room' | 'need_flatmate';
export type ListingStatus = 'active' | 'paused' | 'filled' | 'under_review' | 'rejected';
export type FurnishingType = 'fully_furnished' | 'semi_furnished' | 'unfurnished';
export type RoomType = 'single' | 'shared' | 'master' | 'hall';

export interface ListingPhoto {
  id: string;
  url: string;
  position: number;
  caption?: string;
}

export interface PropertyListing {
  id: string;
  owner_id: string;
  owner_name: string;
  type: ListingType;
  title: string;
  description: string;
  rent: number;
  deposit: number;
  maintenance: number;
  furnishing: FurnishingType;
  locality: string;
  city: string;
  address?: string;
  room_type: RoomType;
  bhk_type: string;
  floor_number?: number;
  total_floors?: number;
  availability_date?: string;
  is_sublet: boolean;
  is_short_stay: boolean;
  min_stay_months?: number;
  quality_score: number; // 0-100
  is_verified: boolean;
  views_count: number;
  status: ListingStatus;
  current_flatmates_count?: number;
  photos: ListingPhoto[];
  amenities: string[];
  created_at: string;
  updated_at: string;
}

// Moderation
export type ModerationContentType = 'photo' | 'text' | 'listing' | 'report';
export type ModerationStatus = 'pending' | 'approved' | 'rejected';

export interface ModerationQueueItem {
  id: string;
  type: ModerationContentType;
  content_ref: string;
  content_preview: string;
  reported_by?: string;
  reported_user_name?: string;
  reported_user_id?: string;
  status: ModerationStatus;
  priority: number; // 0=low, 1=medium, 2=high, 3=urgent
  reviewed_by?: string;
  review_notes?: string;
  reviewed_at?: string;
  auto_flagged: boolean;
  auto_flag_reason?: string;
  created_at: string;
}

// Disputes
export type DisputeType = 'deposit' | 'notice_period' | 'damage' | 'harassment' | 'other';
export type DisputeStatus = 'open' | 'in_progress' | 'resolved' | 'escalated';

export interface Dispute {
  id: string;
  raised_by: string;
  raised_by_name: string;
  against_id: string;
  against_name: string;
  flat_id?: string;
  type: DisputeType;
  description: string;
  evidence_urls: string[];
  amount_disputed?: number;
  status: DisputeStatus;
  resolution?: string;
  resolved_by?: string;
  resolved_at?: string;
  created_at: string;
  updated_at: string;
}

// Audit Logs
export interface AuditLog {
  id: string;
  user_id?: string;
  admin_id?: string;
  admin_name?: string;
  action: string;
  entity_type: string;
  entity_id?: string;
  old_data?: Record<string, any>;
  new_data?: Record<string, any>;
  metadata?: Record<string, any>;
  ip_address?: string;
  user_agent?: string;
  created_at: string;
}

// Analytics & Funnels
export interface FunnelStage {
  stage: string;
  count: number;
  conversionRate: number; // %
  dropOffRate: number; // %
  avgDurationDays: number;
}

export interface RetentionCohort {
  cohort: string;
  initialUsers: number;
  day30Active: number;
  day30Pct: number;
  day90Active: number;
  day90Pct: number;
  harmonyScoreAvg: number;
}

export interface LocalityMetric {
  locality: string;
  city: string;
  activeUsers: number;
  activeListings: number;
  matchRate: number;
  avgRent: number;
}

export interface MetricStat {
  label: string;
  value: string | number;
  change: number; // percentage change
  trend: 'up' | 'down' | 'neutral';
  subtext?: string;
}

// B2B Corporate
export interface CorporateAccount {
  id: string;
  company_name: string;
  contact_email: string;
  contact_phone?: string;
  plan: 'basic' | 'premium' | 'enterprise';
  logo_url?: string;
  employee_count: number;
  max_employees: number;
  domains: string[];
  budget_stipend_monthly?: number;
  placed_employees: number;
  housing_subsidy_total: number;
  compatibility_index_avg: number;
  is_active: boolean;
  created_at: string;
}

export interface RelocationCohort {
  id: string;
  corporate_id: string;
  cohort_name: string;
  target_city: string;
  start_date: string;
  employee_count: number;
  placed_count: number;
  status: 'planning' | 'onboarding' | 'matching' | 'completed';
}

export interface CorporateEmployee {
  id: string;
  corporate_id: string;
  cohort_id?: string;
  name: string;
  email: string;
  designation: string;
  department: string;
  budget: number;
  status: 'invited' | 'registered' | 'matching' | 'placed';
  matched_coworker_name?: string;
  compatibility_score?: number;
  locality_assigned?: string;
}

// B2B Colleges
export interface CollegeAccount {
  id: string;
  institution_name: string;
  contact_email: string;
  contact_phone?: string;
  plan: 'basic' | 'premium' | 'campus_partner';
  logo_url?: string;
  student_count: number;
  max_students: number;
  domains: string[];
  campus_locality: string;
  city: string;
  verified_students_count: number;
  safety_score: number; // 0-100
  curated_rings_count: number;
  is_active: boolean;
  created_at: string;
}

export interface CollegeBatch {
  id: string;
  college_id: string;
  name: string; // e.g., 'MBA Batch 2026', 'B.Tech Freshers'
  degree: string;
  enrolled_students: number;
  matched_count: number;
  gender_segregated: boolean;
  semester: string;
}

export interface StudentHousingProfile {
  id: string;
  college_id: string;
  batch_id: string;
  student_name: string;
  roll_number: string;
  email: string;
  gender: string;
  budget_monthly: number;
  guardian_verified: boolean;
  guardian_phone: string;
  roommate_matched?: string;
  match_compatibility?: number;
  status: 'unmatched' | 'in_discussion' | 'flat_secured';
}

// B2B Operators
export type OperatorType = 'pg' | 'coliving';

export interface OperatorAccount {
  id: string;
  name: string;
  type: OperatorType;
  contact_email?: string;
  contact_phone?: string;
  properties_count: number;
  cities: string[];
  commission_pct: number;
  occupancy_rate: number; // %
  monthly_revenue: number;
  compatibility_allocation_enabled: boolean;
  is_verified: boolean;
  is_active: boolean;
  created_at: string;
}

export interface OperatorProperty {
  id: string;
  operator_id: string;
  operator_name: string;
  property_name: string;
  locality: string;
  city: string;
  type: OperatorType;
  total_beds: number;
  occupied_beds: number;
  available_beds: number;
  base_rent: number;
  sharing_types: ('single' | 'double' | 'triple')[];
  avg_compatibility_score: number;
  amenities: string[];
}

export interface SmartBedAllocation {
  id: string;
  property_id: string;
  property_name: string;
  room_number: string;
  bed_number: string;
  existing_resident_name: string;
  existing_habits: {
    sleep: string;
    food: string;
    cleanliness: string;
    wfh: string;
  };
  recommended_candidate_name: string;
  candidate_id: string;
  compatibility_score: number;
  match_reasons: string[];
  status: 'proposed' | 'accepted' | 'rejected' | 'allocated';
}
