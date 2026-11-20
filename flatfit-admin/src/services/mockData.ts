import {
  UserProfile,
  PropertyListing,
  ModerationQueueItem,
  Dispute,
  AuditLog,
  CorporateAccount,
  RelocationCohort,
  CorporateEmployee,
  CollegeAccount,
  CollegeBatch,
  StudentHousingProfile,
  OperatorAccount,
  OperatorProperty,
  SmartBedAllocation,
  FunnelStage,
  RetentionCohort,
  LocalityMetric,
  MetricStat
} from '../types';

export const mockNorthStarMetrics: MetricStat[] = [
  { label: 'Successful Move-Ins (MTD)', value: '1,428', change: 18.4, trend: 'up', subtext: 'Target: 1,500' },
  { label: 'Match-to-Chat Conversion', value: '64.2%', change: 5.1, trend: 'up', subtext: '+3.2% vs last month' },
  { label: '90-Day Living Harmony', value: '91.8%', change: 2.3, trend: 'up', subtext: 'Dispute rate < 1.4%' },
  { label: 'Avg Time to Roommate', value: '11.4 Days', change: -12.5, trend: 'up', subtext: 'Down from 13.8 days' },
  { label: 'Active Listings (Mumbai)', value: '3,842', change: 9.8, trend: 'up', subtext: '88% Verified' },
  { label: 'B2B Relocation Cohorts', value: '42 Active', change: 27.0, trend: 'up', subtext: 'Corporate & University' }
];

export const mockFunnelData: FunnelStage[] = [
  { stage: 'App Visitor / Sign-Up', count: 48500, conversionRate: 100, dropOffRate: 0, avgDurationDays: 0 },
  { stage: 'Quiz & Preferences Done', count: 37830, conversionRate: 78.0, dropOffRate: 22.0, avgDurationDays: 0.5 },
  { stage: 'Verified (Phone + KYC/Work)', count: 28370, conversionRate: 75.0, dropOffRate: 25.0, avgDurationDays: 1.2 },
  { stage: 'Top Compatibility Match Opened', count: 22120, conversionRate: 78.0, dropOffRate: 22.0, avgDurationDays: 2.1 },
  { stage: 'Direct Chat Initiated', count: 14200, conversionRate: 64.2, dropOffRate: 35.8, avgDurationDays: 3.4 },
  { stage: 'In-Person / Video Meet Scheduled', count: 6810, conversionRate: 48.0, dropOffRate: 52.0, avgDurationDays: 6.8 },
  { stage: 'Roommate Agreement & Move-In', count: 3260, conversionRate: 47.9, dropOffRate: 52.1, avgDurationDays: 11.4 }
];

export const mockRetentionCohorts: RetentionCohort[] = [
  { cohort: 'Jun 2026', initialUsers: 1850, day30Active: 1628, day30Pct: 88.0, day90Active: 1461, day90Pct: 79.0, harmonyScoreAvg: 93.2 },
  { cohort: 'Jul 2026', initialUsers: 2120, day30Active: 1908, day30Pct: 90.0, day90Active: 1738, day90Pct: 82.0, harmonyScoreAvg: 92.5 },
  { cohort: 'Aug 2026', initialUsers: 2460, day30Active: 2263, day30Pct: 92.0, day90Active: 2066, day90Pct: 84.0, harmonyScoreAvg: 94.1 },
  { cohort: 'Sep 2026', initialUsers: 2890, day30Active: 2716, day30Pct: 94.0, day90Active: 2485, day90Pct: 86.0, harmonyScoreAvg: 93.8 },
  { cohort: 'Oct 2026', initialUsers: 3150, day30Active: 2992, day30Pct: 95.0, day90Active: 2772, day90Pct: 88.0, harmonyScoreAvg: 95.0 }
];

export const mockLocalityMetrics: LocalityMetric[] = [
  { locality: 'Bandra West', city: 'Mumbai', activeUsers: 1420, activeListings: 410, matchRate: 78, avgRent: 42000 },
  { locality: 'Andheri West', city: 'Mumbai', activeUsers: 2890, activeListings: 890, matchRate: 82, avgRent: 26000 },
  { locality: 'Powai (Hiranandani)', city: 'Mumbai', activeUsers: 1980, activeListings: 630, matchRate: 86, avgRent: 31000 },
  { locality: 'Lower Parel', city: 'Mumbai', activeUsers: 1150, activeListings: 340, matchRate: 74, avgRent: 48000 },
  { locality: 'Goregaon East', city: 'Mumbai', activeUsers: 1720, activeListings: 510, matchRate: 80, avgRent: 24000 },
  { locality: 'Juhu', city: 'Mumbai', activeUsers: 840, activeListings: 220, matchRate: 71, avgRent: 52000 },
  { locality: 'Malad West', city: 'Mumbai', activeUsers: 1450, activeListings: 430, matchRate: 79, avgRent: 22500 }
];

export const mockUsers: UserProfile[] = [
  {
    id: 'u-101',
    full_name: 'Aarav Sharma',
    email: 'aarav.sharma@razorpay.com',
    phone: '+91 98201 44321',
    age: 26,
    gender: 'male',
    occupation: 'working',
    company_or_college: 'Razorpay',
    city: 'Mumbai',
    locality: 'Powai',
    bio: 'Software engineer who loves quiet weekend gaming and early morning jogs. Clean, vegetarian cooking, non-smoker.',
    housing_goal: 'need_room',
    budget_min: 25000,
    budget_max: 35000,
    preferred_localities: ['Powai', 'Kanjurmarg West', 'Vikhroli'],
    move_in_date: '2026-12-01',
    stay_duration: '1 year',
    profile_completion: 100,
    is_active: true,
    is_banned: false,
    trust_score: 96,
    created_at: '2026-09-10T10:30:00Z',
    verifications: { phone: true, kyc: true, employer_email: true, linkedin: true },
    avatar_url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'
  },
  {
    id: 'u-102',
    full_name: 'Priya Iyer',
    email: 'priya.iyer@tcs.com',
    phone: '+91 98711 23908',
    age: 24,
    gender: 'female',
    occupation: 'working',
    company_or_college: 'TCS Innovation Labs',
    city: 'Mumbai',
    locality: 'Andheri West',
    bio: 'Data Analyst relocating from Bengaluru. Looking for a warm, clean flat with like-minded girls.',
    housing_goal: 'looking_together',
    budget_min: 20000,
    budget_max: 28000,
    preferred_localities: ['Andheri West', 'Versova', 'Juhu Circle'],
    move_in_date: '2026-11-20',
    stay_duration: '6 months+',
    profile_completion: 95,
    is_active: true,
    is_banned: false,
    trust_score: 91,
    created_at: '2026-09-15T14:20:00Z',
    verifications: { phone: true, kyc: true, employer_email: true },
    avatar_url: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150'
  },
  {
    id: 'u-103',
    full_name: 'Rohan Mehra',
    email: 'rohan.mehra@gmail.com',
    phone: '+91 99304 88712',
    age: 28,
    gender: 'male',
    occupation: 'freelancer',
    company_or_college: 'Independent UI/UX Designer',
    city: 'Mumbai',
    locality: 'Bandra West',
    bio: 'Have a spacious 2BHK in Bandra near Carter Road. Looking for a respectful, chill flatmate for the master bedroom.',
    housing_goal: 'have_room',
    budget_min: 40000,
    budget_max: 45000,
    preferred_localities: ['Bandra West', 'Khar'],
    move_in_date: '2026-11-15',
    stay_duration: 'Flexible',
    profile_completion: 92,
    is_active: true,
    is_banned: false,
    trust_score: 88,
    created_at: '2026-08-01T09:12:00Z',
    verifications: { phone: true, kyc: true, linkedin: true },
    avatar_url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'
  },
  {
    id: 'u-104',
    full_name: 'Ananya Deshmukh',
    email: 'ananya.d@iitb.ac.in',
    phone: '+91 91672 55091',
    age: 22,
    gender: 'female',
    occupation: 'student',
    company_or_college: 'IIT Bombay (M.Tech CSE)',
    city: 'Mumbai',
    locality: 'Powai',
    bio: 'M.Tech research scholar looking for off-campus accommodation near campus gate 2.',
    housing_goal: 'need_room',
    budget_min: 15000,
    budget_max: 22000,
    preferred_localities: ['Powai', 'Chandivali'],
    move_in_date: '2026-12-15',
    stay_duration: '2 years',
    profile_completion: 90,
    is_active: true,
    is_banned: false,
    trust_score: 94,
    created_at: '2026-10-02T11:00:00Z',
    verifications: { phone: true, kyc: true, college_email: true },
    avatar_url: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'
  },
  {
    id: 'u-105',
    full_name: 'Karan Malhotra',
    email: 'karan.malhotra99@outlook.com',
    phone: '+91 97690 12845',
    age: 29,
    gender: 'male',
    occupation: 'working',
    company_or_college: 'Morgan Stanley',
    city: 'Mumbai',
    locality: 'Lower Parel',
    bio: 'Investment banker, works long hours, values cleanliness, zero tolerance for loud late parties on weekdays.',
    housing_goal: 'have_room',
    budget_min: 50000,
    budget_max: 60000,
    preferred_localities: ['Lower Parel', 'Worli', 'Mahalaxmi'],
    move_in_date: '2026-11-25',
    stay_duration: '1 year',
    profile_completion: 85,
    is_active: true,
    is_banned: false,
    trust_score: 89,
    created_at: '2026-07-20T16:45:00Z',
    verifications: { phone: true, kyc: true, employer_email: true },
    avatar_url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150'
  },
  {
    id: 'u-106',
    full_name: 'Vikram Singh (Suspicious)',
    email: 'broker_deals_mumbai@tempmail.org',
    phone: '+91 99999 00000',
    age: 33,
    gender: 'male',
    occupation: 'freelancer',
    city: 'Mumbai',
    locality: 'Andheri East',
    bio: 'Cheap rooms available without security deposit! Contact immediately on WhatsApp.',
    housing_goal: 'have_room',
    profile_completion: 45,
    is_active: false,
    is_banned: true,
    ban_reason: 'Commercial broker spam disguised as individual flatmate & suspected deposit advance fraud',
    trust_score: 22,
    preferred_localities: ['Andheri East'],
    created_at: '2026-11-01T08:14:00Z',
    verifications: { phone: false, kyc: false },
    avatar_url: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'
  }
];

export const mockListings: PropertyListing[] = [
  {
    id: 'lst-201',
    owner_id: 'u-103',
    owner_name: 'Rohan Mehra',
    type: 'have_room',
    title: 'Master Bedroom in Sea-Facing 2BHK Bandra West',
    description: 'En-suite bath, fully modular kitchen, maid already arranged for cleaning & cooking. 5 mins walk to Carter Road promenade. High speed fiber internet included.',
    rent: 42000,
    deposit: 84000,
    maintenance: 3500,
    furnishing: 'fully_furnished',
    locality: 'Bandra West',
    city: 'Mumbai',
    address: 'Silver Beach Apts, Near Joggers Park, Bandra West',
    room_type: 'master',
    bhk_type: '2BHK',
    floor_number: 6,
    total_floors: 12,
    availability_date: '2026-12-01',
    is_sublet: false,
    is_short_stay: false,
    min_stay_months: 6,
    quality_score: 96,
    is_verified: true,
    views_count: 842,
    status: 'active',
    current_flatmates_count: 1,
    photos: [
      { id: 'p1', url: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500', position: 1, caption: 'Spacious Master Bedroom' },
      { id: 'p2', url: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500', position: 2, caption: 'Living Area with Balcony' }
    ],
    amenities: ['High Speed WiFi', 'Air Conditioning', 'Washing Machine', 'Cook Available', 'Balcony', 'Gated Society'],
    created_at: '2026-10-14T09:30:00Z',
    updated_at: '2026-11-10T12:00:00Z'
  },
  {
    id: 'lst-202',
    owner_id: 'u-105',
    owner_name: 'Karan Malhotra',
    type: 'have_room',
    title: 'Private Room in Premium Highrise, Lower Parel',
    description: 'Looking for a flatmate in Indiabulls Sky. Private bathroom, clubhouse access, swimming pool, gym. Walking distance to corporate offices.',
    rent: 55000,
    deposit: 110000,
    maintenance: 5000,
    furnishing: 'fully_furnished',
    locality: 'Lower Parel',
    city: 'Mumbai',
    address: 'Indiabulls Sky Tower B, Lower Parel',
    room_type: 'single',
    bhk_type: '3BHK',
    floor_number: 28,
    total_floors: 45,
    availability_date: '2026-11-25',
    is_sublet: false,
    is_short_stay: false,
    min_stay_months: 11,
    quality_score: 94,
    is_verified: true,
    views_count: 615,
    status: 'active',
    current_flatmates_count: 2,
    photos: [
      { id: 'p3', url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500', position: 1, caption: 'Bedroom with skyline view' }
    ],
    amenities: ['Gym', 'Swimming Pool', 'Central AC', 'Covered Parking', '24x7 Security', 'Concierge'],
    created_at: '2026-10-20T11:15:00Z',
    updated_at: '2026-11-08T15:20:00Z'
  },
  {
    id: 'lst-203',
    owner_id: 'u-101',
    owner_name: 'Aarav Sharma',
    type: 'need_flatmate',
    title: 'Shared 2BHK in Hiranandani Powai - 1 Room Available',
    description: 'Looking for a chill flatmate who works in tech/consulting. 15 mins to Supreme Business Park. Clean apartment, quiet neighborhood.',
    rent: 28000,
    deposit: 50000,
    maintenance: 2500,
    furnishing: 'semi_furnished',
    locality: 'Powai',
    city: 'Mumbai',
    address: 'Somerset Building, Hiranandani Gardens, Powai',
    room_type: 'single',
    bhk_type: '2BHK',
    floor_number: 4,
    total_floors: 8,
    availability_date: '2026-12-05',
    is_sublet: false,
    is_short_stay: false,
    min_stay_months: 6,
    quality_score: 88,
    is_verified: true,
    views_count: 490,
    status: 'active',
    current_flatmates_count: 1,
    photos: [
      { id: 'p4', url: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=500', position: 1, caption: 'Kitchen and Dining' }
    ],
    amenities: ['Piped Gas', 'Water Purifier', 'Security Guard', 'Power Backup'],
    created_at: '2026-10-25T17:00:00Z',
    updated_at: '2026-11-05T10:00:00Z'
  },
  {
    id: 'lst-204',
    owner_id: 'u-106',
    owner_name: 'Vikram Singh',
    type: 'have_room',
    title: 'Urgent Room No Brokerage Andheri East',
    description: 'Deposit only 5k, immediately available, call now on whatsapp 9999900000. Low rent deal.',
    rent: 11000,
    deposit: 5000,
    maintenance: 0,
    furnishing: 'unfurnished',
    locality: 'Andheri East',
    city: 'Mumbai',
    room_type: 'shared',
    bhk_type: '1BHK',
    quality_score: 35,
    is_verified: false,
    views_count: 120,
    status: 'rejected',
    is_sublet: true,
    is_short_stay: true,
    photos: [],
    amenities: [],
    created_at: '2026-11-01T08:20:00Z',
    updated_at: '2026-11-01T08:35:00Z'
  }
];

export const mockModerationQueue: ModerationQueueItem[] = [
  {
    id: 'mod-301',
    type: 'photo',
    content_ref: 'https://flagged-content.cdn/user_upload_988.jpg',
    content_preview: '[Photo Flagged: AI Watermark / Stock Photo detected on listing avatar]',
    reported_user_id: 'u-106',
    reported_user_name: 'Vikram Singh',
    status: 'pending',
    priority: 3,
    auto_flagged: true,
    auto_flag_reason: 'Image matches duplicate stock photo database with 99.4% similarity',
    created_at: '2026-11-12T14:15:00Z'
  },
  {
    id: 'mod-302',
    type: 'text',
    content_ref: 'msg_98214',
    content_preview: 'Do not pay on app, send 10k advance token to my GPay 9999900000 to hold room immediately or I give to another person.',
    reported_user_id: 'u-106',
    reported_user_name: 'Vikram Singh',
    reported_by: 'u-102',
    status: 'pending',
    priority: 3,
    auto_flagged: true,
    auto_flag_reason: 'Off-platform advance payment solicitation & suspicious phone number pattern',
    created_at: '2026-11-12T13:40:00Z'
  },
  {
    id: 'mod-303',
    type: 'report',
    content_ref: 'rep_1042',
    content_preview: 'User was aggressive and refused to honor stated house quiet hours, threatened to throw personal items out.',
    reported_user_id: 'u-108',
    reported_user_name: 'Siddharth Roy',
    reported_by: 'u-104',
    status: 'pending',
    priority: 2,
    auto_flagged: false,
    created_at: '2026-11-11T19:20:00Z'
  },
  {
    id: 'mod-304',
    type: 'listing',
    content_ref: 'lst-204',
    content_preview: 'Listing title has multiple exclamation marks and suspected fake rent pricing below 50% locality baseline.',
    reported_user_id: 'u-106',
    reported_user_name: 'Vikram Singh',
    status: 'rejected',
    priority: 2,
    reviewed_by: 'adm-01',
    review_notes: 'Confirmed scam posting. User permanently banned.',
    reviewed_at: '2026-11-11T10:00:00Z',
    auto_flagged: true,
    auto_flag_reason: 'Anomaly in pricing vs locality average',
    created_at: '2026-11-11T09:30:00Z'
  }
];

export const mockDisputes: Dispute[] = [
  {
    id: 'disp-401',
    raised_by: 'u-102',
    raised_by_name: 'Priya Iyer',
    against_id: 'u-109',
    against_name: 'Sameer Kapoor',
    flat_id: 'flat-882',
    type: 'deposit',
    description: 'Moved out after completing notice period of 30 days. Flatmate/primary tenant Sameer is withholding ₹25,000 security deposit claiming arbitrary painting charges without any receipts.',
    evidence_urls: [
      'https://evidence.storage/handover_photos_clean.jpg',
      'https://evidence.storage/whatsapp_notice_screenshot.png'
    ],
    amount_disputed: 25000,
    status: 'open',
    created_at: '2026-11-10T11:20:00Z',
    updated_at: '2026-11-10T11:20:00Z'
  },
  {
    id: 'disp-402',
    raised_by: 'u-103',
    raised_by_name: 'Rohan Mehra',
    against_id: 'u-110',
    against_name: 'Devansh Joshi',
    flat_id: 'flat-611',
    type: 'notice_period',
    description: 'Ex-flatmate left with only 3 days notice instead of agreed 30 days as per FlatFit digital agreement, leaving an unpaid electricity bill of ₹4,200.',
    evidence_urls: [
      'https://evidence.storage/digital_agreement_clause_signed.pdf',
      'https://evidence.storage/mseb_electricity_bill.pdf'
    ],
    amount_disputed: 18000,
    status: 'in_progress',
    created_at: '2026-11-08T16:00:00Z',
    updated_at: '2026-11-11T09:30:00Z'
  },
  {
    id: 'disp-403',
    raised_by: 'u-105',
    raised_by_name: 'Karan Malhotra',
    against_id: 'u-111',
    against_name: 'Nitin Rao',
    flat_id: 'flat-442',
    type: 'damage',
    description: 'Damage to living room leather couch during a party. Repair quote from authorized vendor is ₹8,500.',
    evidence_urls: [
      'https://evidence.storage/couch_damage.jpg',
      'https://evidence.storage/carpenter_invoice_quote.pdf'
    ],
    amount_disputed: 8500,
    status: 'resolved',
    resolution: 'Mutual agreement mediated via FlatFit escrow: ₹6,000 deducted from deposit with consent, remainder released.',
    resolved_by: 'Admin Anita K.',
    resolved_at: '2026-11-09T14:15:00Z',
    created_at: '2026-11-05T10:15:00Z',
    updated_at: '2026-11-09T14:15:00Z'
  }
];

export const mockCorporateAccounts: CorporateAccount[] = [
  {
    id: 'corp-501',
    company_name: 'Razorpay Software Pvt Ltd',
    contact_email: 'relocations@razorpay.com',
    contact_phone: '+91 80 4684 0000',
    plan: 'enterprise',
    employee_count: 340,
    max_employees: 500,
    domains: ['razorpay.com'],
    budget_stipend_monthly: 25000,
    placed_employees: 285,
    housing_subsidy_total: 14250000,
    compatibility_index_avg: 94.6,
    is_active: true,
    created_at: '2026-03-15T00:00:00Z'
  },
  {
    id: 'corp-502',
    company_name: 'Google India',
    contact_email: 'people-ops-in@google.com',
    contact_phone: '+91 22 6611 3000',
    plan: 'enterprise',
    employee_count: 520,
    max_employees: 1000,
    domains: ['google.com'],
    budget_stipend_monthly: 40000,
    placed_employees: 480,
    housing_subsidy_total: 38400000,
    compatibility_index_avg: 96.2,
    is_active: true,
    created_at: '2026-01-10T00:00:00Z'
  },
  {
    id: 'corp-503',
    company_name: 'Tata Consultancy Services',
    contact_email: 'campus.relocate@tcs.com',
    contact_phone: '+91 22 6778 9999',
    plan: 'premium',
    employee_count: 850,
    max_employees: 1500,
    domains: ['tcs.com'],
    budget_stipend_monthly: 18000,
    placed_employees: 710,
    housing_subsidy_total: 25560000,
    compatibility_index_avg: 89.4,
    is_active: true,
    created_at: '2026-04-01T00:00:00Z'
  }
];

export const mockRelocationCohorts: RelocationCohort[] = [
  {
    id: 'coh-601',
    corporate_id: 'corp-501',
    cohort_name: 'Engineering Batch Q3 2026 - Mumbai Relocation',
    target_city: 'Mumbai',
    start_date: '2026-11-15',
    employee_count: 45,
    placed_count: 38,
    status: 'matching'
  },
  {
    id: 'coh-602',
    corporate_id: 'corp-502',
    cohort_name: 'BKC Tech Hub - Lateral Hires Batch',
    target_city: 'Mumbai',
    start_date: '2026-12-01',
    employee_count: 60,
    placed_count: 52,
    status: 'onboarding'
  },
  {
    id: 'coh-603',
    corporate_id: 'corp-503',
    cohort_name: 'Yantra Park Freshers 2026',
    target_city: 'Mumbai (Thane/Powai)',
    start_date: '2026-10-01',
    employee_count: 120,
    placed_count: 118,
    status: 'completed'
  }
];

export const mockCorporateEmployees: CorporateEmployee[] = [
  {
    id: 'ce-701',
    corporate_id: 'corp-501',
    cohort_id: 'coh-601',
    name: 'Aarav Sharma',
    email: 'aarav.sharma@razorpay.com',
    designation: 'Senior Backend Engineer',
    department: 'Core Payments',
    budget: 35000,
    status: 'placed',
    matched_coworker_name: 'Tanmay Saxena (Razorpay)',
    compatibility_score: 95,
    locality_assigned: 'Powai'
  },
  {
    id: 'ce-702',
    corporate_id: 'corp-501',
    cohort_id: 'coh-601',
    name: 'Sneha Kulkarni',
    email: 'sneha.k@razorpay.com',
    designation: 'Product Designer',
    department: 'Merchant Experience',
    budget: 30000,
    status: 'matching',
    matched_coworker_name: 'Ritika Sen (Razorpay)',
    compatibility_score: 92,
    locality_assigned: 'Andheri West'
  },
  {
    id: 'ce-703',
    corporate_id: 'corp-501',
    cohort_id: 'coh-601',
    name: 'Harsh Vardhan',
    email: 'harsh.v@razorpay.com',
    designation: 'DevOps Specialist',
    department: 'Infrastructure',
    budget: 28000,
    status: 'registered',
    locality_assigned: 'Pending'
  }
];

export const mockCollegeAccounts: CollegeAccount[] = [
  {
    id: 'col-801',
    institution_name: 'IIT Bombay (Powai)',
    contact_email: 'housing-affairs@iitb.ac.in',
    contact_phone: '+91 22 2572 2545',
    plan: 'campus_partner',
    student_count: 420,
    max_students: 800,
    domains: ['iitb.ac.in'],
    campus_locality: 'Powai',
    city: 'Mumbai',
    verified_students_count: 395,
    safety_score: 98,
    curated_rings_count: 14,
    is_active: true,
    created_at: '2026-02-01T00:00:00Z'
  },
  {
    id: 'col-802',
    institution_name: 'NMIMS (Narsee Monjee Institute, Vile Parle)',
    contact_email: 'studentwelfare@nmims.edu',
    contact_phone: '+91 22 4235 5555',
    plan: 'campus_partner',
    student_count: 680,
    max_students: 1200,
    domains: ['nmims.edu'],
    campus_locality: 'Vile Parle West',
    city: 'Mumbai',
    verified_students_count: 640,
    safety_score: 94,
    curated_rings_count: 22,
    is_active: true,
    created_at: '2026-01-20T00:00:00Z'
  },
  {
    id: 'col-803',
    institution_name: "St. Xavier's College (Autonomous)",
    contact_email: 'admin@xaviers.edu',
    contact_phone: '+91 22 2262 0661',
    plan: 'premium',
    student_count: 290,
    max_students: 500,
    domains: ['xaviers.edu'],
    campus_locality: 'Fort / Marine Lines',
    city: 'Mumbai',
    verified_students_count: 270,
    safety_score: 96,
    curated_rings_count: 9,
    is_active: true,
    created_at: '2026-03-10T00:00:00Z'
  }
];

export const mockCollegeBatches: CollegeBatch[] = [
  {
    id: 'bat-901',
    college_id: 'col-801',
    name: 'M.Tech CSE & Data Science 2026',
    degree: 'Postgraduate',
    enrolled_students: 110,
    matched_count: 98,
    gender_segregated: true,
    semester: 'Semester 1'
  },
  {
    id: 'bat-902',
    college_id: 'col-802',
    name: 'MBA Core Batch 2026-28',
    degree: 'Management',
    enrolled_students: 240,
    matched_count: 215,
    gender_segregated: true,
    semester: 'Trimester 1'
  }
];

export const mockStudentProfiles: StudentHousingProfile[] = [
  {
    id: 'stu-1001',
    college_id: 'col-801',
    batch_id: 'bat-901',
    student_name: 'Ananya Deshmukh',
    roll_number: '24M050012',
    email: 'ananya.d@iitb.ac.in',
    gender: 'Female',
    budget_monthly: 18000,
    guardian_verified: true,
    guardian_phone: '+91 94220 11984',
    roommate_matched: 'Meera Nambiar (IITB M.Tech)',
    match_compatibility: 96,
    status: 'flat_secured'
  },
  {
    id: 'stu-1002',
    college_id: 'col-802',
    batch_id: 'bat-902',
    student_name: 'Aditya Singhania',
    roll_number: 'NM-MBA-089',
    email: 'aditya.s@nmims.edu',
    gender: 'Male',
    budget_monthly: 26000,
    guardian_verified: true,
    guardian_phone: '+91 98110 44521',
    roommate_matched: 'Kabir Chawla (NMIMS MBA)',
    match_compatibility: 91,
    status: 'flat_secured'
  },
  {
    id: 'stu-1003',
    college_id: 'col-801',
    batch_id: 'bat-901',
    student_name: 'Rahul K. Verma',
    roll_number: '24M050044',
    email: 'rahul.kv@iitb.ac.in',
    gender: 'Male',
    budget_monthly: 16000,
    guardian_verified: true,
    guardian_phone: '+91 98765 43210',
    status: 'in_discussion'
  }
];

export const mockOperatorAccounts: OperatorAccount[] = [
  {
    id: 'op-1101',
    name: 'Stanza Living Mumbai',
    type: 'coliving',
    contact_email: 'partners@stanzaliving.com',
    contact_phone: '+91 11 4084 4844',
    properties_count: 28,
    cities: ['Mumbai', 'Navi Mumbai', 'Thane'],
    commission_pct: 6.5,
    occupancy_rate: 93.4,
    monthly_revenue: 14500000,
    compatibility_allocation_enabled: true,
    is_verified: true,
    is_active: true,
    created_at: '2026-01-15T00:00:00Z'
  },
  {
    id: 'op-1102',
    name: 'Zolo Stays Co-Living',
    type: 'coliving',
    contact_email: 'inventory@zolostays.com',
    contact_phone: '+91 88 8016 3000',
    properties_count: 36,
    cities: ['Mumbai', 'Pune', 'Bengaluru'],
    commission_pct: 5.5,
    occupancy_rate: 89.2,
    monthly_revenue: 19800000,
    compatibility_allocation_enabled: true,
    is_verified: true,
    is_active: true,
    created_at: '2026-02-10T00:00:00Z'
  },
  {
    id: 'op-1103',
    name: 'Housr Luxury Coliving',
    type: 'coliving',
    contact_email: 'operations@housr.in',
    contact_phone: '+91 99 9900 1122',
    properties_count: 12,
    cities: ['Mumbai (BKC & Powai)'],
    commission_pct: 7.0,
    occupancy_rate: 96.1,
    monthly_revenue: 11200000,
    compatibility_allocation_enabled: true,
    is_verified: true,
    is_active: true,
    created_at: '2026-04-05T00:00:00Z'
  }
];

export const mockOperatorProperties: OperatorProperty[] = [
  {
    id: 'prop-1201',
    operator_id: 'op-1101',
    operator_name: 'Stanza Living Mumbai',
    property_name: 'Stanza Living Kyoto House - Powai',
    locality: 'Powai (Near IIT Main Gate)',
    city: 'Mumbai',
    type: 'coliving',
    total_beds: 120,
    occupied_beds: 112,
    available_beds: 8,
    base_rent: 18500,
    sharing_types: ['single', 'double'],
    avg_compatibility_score: 93.8,
    amenities: ['High Speed WiFi', 'Daily Housekeeping', '3 Meals/Day', 'Gym', 'Biometric Entry']
  },
  {
    id: 'prop-1202',
    operator_id: 'op-1102',
    operator_name: 'Zolo Stays Co-Living',
    property_name: 'Zolo Amber - Andheri West',
    locality: 'Andheri West (Near Metro Line 1)',
    city: 'Mumbai',
    type: 'coliving',
    total_beds: 84,
    occupied_beds: 76,
    available_beds: 8,
    base_rent: 16000,
    sharing_types: ['double', 'triple'],
    avg_compatibility_score: 90.5,
    amenities: ['WiFi', 'Power Backup', 'Washing Machines', 'Community Lounge']
  },
  {
    id: 'prop-1203',
    operator_id: 'op-1103',
    operator_name: 'Housr Luxury Coliving',
    property_name: 'Housr Botanica - BKC Connector',
    locality: 'BKC / Kurla West',
    city: 'Mumbai',
    type: 'coliving',
    total_beds: 64,
    occupied_beds: 61,
    available_beds: 3,
    base_rent: 32000,
    sharing_types: ['single', 'double'],
    avg_compatibility_score: 96.0,
    amenities: ['Concierge', 'Workstations', 'Rooftop Cafe', 'Valet Parking', 'Housekeeping']
  }
];

export const mockBedAllocations: SmartBedAllocation[] = [
  {
    id: 'alloc-1301',
    property_id: 'prop-1201',
    property_name: 'Stanza Living Kyoto House - Powai',
    room_number: 'Room 304 (Twin Share)',
    bed_number: 'Bed B (Window Side)',
    existing_resident_name: 'Pranav Mehta (Techie, 25)',
    existing_habits: {
      sleep: 'Night owl (sleeps 1 AM, wakes 9 AM)',
      food: 'Vegetarian, strictly no meat in room',
      cleanliness: 'High (daily tidy up)',
      wfh: 'Hybrid (3 days office, 2 days WFH)'
    },
    recommended_candidate_name: 'Aarav Sharma (Razorpay)',
    candidate_id: 'u-101',
    compatibility_score: 96,
    match_reasons: [
      'Identical sleep schedules (both sleep post-midnight)',
      '100% vegetarian culinary alignment',
      'High cleanliness score (95% questionnaire match)',
      'Similar work domains (software engineering)'
    ],
    status: 'proposed'
  },
  {
    id: 'alloc-1302',
    property_id: 'prop-1202',
    property_name: 'Zolo Amber - Andheri West',
    room_number: 'Room 102 (Twin Share)',
    bed_number: 'Bed A',
    existing_resident_name: 'Shruti Nair (Media Planner, 24)',
    existing_habits: {
      sleep: 'Early riser (sleeps 11 PM, wakes 7 AM)',
      food: 'Non-vegetarian friendly',
      cleanliness: 'Moderate',
      wfh: 'Office daily'
    },
    recommended_candidate_name: 'Priya Iyer (TCS)',
    candidate_id: 'u-102',
    compatibility_score: 92,
    match_reasons: [
      'Synchronized morning routines',
      'Both prefer calm evenings without loud guests on weekdays',
      'Shared interest in yoga and reading'
    ],
    status: 'allocated'
  }
];

export const mockAuditLogs: AuditLog[] = [
  {
    id: 'log-1401',
    admin_id: 'adm-01',
    admin_name: 'SuperAdmin Neha Verma',
    action: 'user.ban',
    entity_type: 'profile',
    entity_id: 'u-106',
    old_data: { is_active: true, is_banned: false },
    new_data: { is_active: false, is_banned: true, ban_reason: 'Deposit advance scam attempt' },
    metadata: { report_id: 'rep_1042', triggered_by: 'moderation_review' },
    ip_address: '14.139.122.4',
    created_at: '2026-11-12T14:45:00Z'
  },
  {
    id: 'log-1402',
    admin_id: 'adm-02',
    admin_name: 'Mod Anita Kapur',
    action: 'listing.reject',
    entity_type: 'listing',
    entity_id: 'lst-204',
    old_data: { status: 'active' },
    new_data: { status: 'rejected', reason: 'Stock photo & below-market fraud flag' },
    metadata: { automated_score: 35 },
    ip_address: '49.36.18.92',
    created_at: '2026-11-12T14:20:00Z'
  },
  {
    id: 'log-1403',
    admin_id: 'adm-01',
    admin_name: 'SuperAdmin Neha Verma',
    action: 'dispute.resolve',
    entity_type: 'dispute',
    entity_id: 'disp-403',
    old_data: { status: 'in_progress', amount_disputed: 8500 },
    new_data: { status: 'resolved', agreed_settlement: 6000 },
    metadata: { resolution_type: 'deposit_escrow_deduction' },
    ip_address: '14.139.122.4',
    created_at: '2026-11-09T14:15:00Z'
  },
  {
    id: 'log-1404',
    admin_id: 'adm-03',
    admin_name: 'Support Officer Dev',
    action: 'kyc.manual_verify',
    entity_type: 'verification',
    entity_id: 'ver-8891',
    old_data: { status: 'pending' },
    new_data: { status: 'verified', note: 'Aadhaar XML cryptographically validated' },
    metadata: { dpdp_compliant_masking: true },
    ip_address: '103.21.124.7',
    created_at: '2026-11-09T10:10:00Z'
  },
  {
    id: 'log-1405',
    admin_id: 'adm-01',
    admin_name: 'SuperAdmin Neha Verma',
    action: 'corporate.activate',
    entity_type: 'corporate_account',
    entity_id: 'corp-501',
    old_data: { is_active: false },
    new_data: { is_active: true, plan: 'enterprise', domains: ['razorpay.com'] },
    metadata: { contract_reference: 'CORP-RZP-2026' },
    ip_address: '14.139.122.4',
    created_at: '2026-10-30T16:00:00Z'
  }
];
