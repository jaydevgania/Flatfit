import { supabase, isSupabaseConfigured } from '../config/supabase';
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
  MetricStat,
  FunnelStage,
  RetentionCohort,
  LocalityMetric
} from '../types';
import {
  mockNorthStarMetrics,
  mockFunnelData,
  mockRetentionCohorts,
  mockLocalityMetrics,
  mockUsers,
  mockListings,
  mockModerationQueue,
  mockDisputes,
  mockCorporateAccounts,
  mockRelocationCohorts,
  mockCorporateEmployees,
  mockCollegeAccounts,
  mockCollegeBatches,
  mockStudentProfiles,
  mockOperatorAccounts,
  mockOperatorProperties,
  mockBedAllocations,
  mockAuditLogs
} from './mockData';

// Mutable in-memory stores for state persistence within the session
let usersStore = [...mockUsers];
let listingsStore = [...mockListings];
let moderationStore = [...mockModerationQueue];
let disputesStore = [...mockDisputes];
let corporateStore = [...mockCorporateAccounts];
let relocationStore = [...mockRelocationCohorts];
let corporateEmployeesStore = [...mockCorporateEmployees];
let collegeStore = [...mockCollegeAccounts];
let collegeBatchesStore = [...mockCollegeBatches];
let studentProfilesStore = [...mockStudentProfiles];
let operatorStore = [...mockOperatorAccounts];
let operatorPropertiesStore = [...mockOperatorProperties];
let bedAllocationsStore = [...mockBedAllocations];
let auditLogsStore = [...mockAuditLogs];

function recordAuditLog(action: string, entity_type: string, entity_id: string, old_data?: any, new_data?: any) {
  const newLog: AuditLog = {
    id: `log-${Date.now()}`,
    admin_id: 'adm-current',
    admin_name: 'Current Admin',
    action,
    entity_type,
    entity_id,
    old_data,
    new_data,
    ip_address: '127.0.0.1',
    created_at: new Date().toISOString()
  };
  auditLogsStore = [newLog, ...auditLogsStore];
}

export const api = {
  isLiveSupabase: () => isSupabaseConfigured,

  // Analytics & Dashboard
  async getDashboardMetrics(): Promise<{
    northStar: MetricStat[];
    funnel: FunnelStage[];
    retention: RetentionCohort[];
    localities: LocalityMetric[];
  }> {
    if (isSupabaseConfigured) {
      try {
        const { data: analytics } = await supabase.from('analytics_events').select('*').limit(50);
        if (analytics && analytics.length > 0) {
          // If live events exist, use them or supplement
        }
      } catch (err) {
        console.warn('Supabase query failed, falling back to mock data:', err);
      }
    }
    return {
      northStar: mockNorthStarMetrics,
      funnel: mockFunnelData,
      retention: mockRetentionCohorts,
      localities: mockLocalityMetrics
    };
  },

  // Users Management
  async getUsers(): Promise<UserProfile[]> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('profiles').select('*, trust_scores(score, factors)').limit(100);
        if (!error && data && data.length > 0) {
          return data.map((d: any) => ({
            id: d.id,
            full_name: d.full_name,
            email: d.email || `${d.full_name.toLowerCase().replace(/\s+/g, '.')}@example.com`,
            phone: d.phone,
            age: d.age,
            gender: d.gender,
            occupation: d.occupation,
            company_or_college: d.company_or_college,
            city: d.city,
            locality: d.locality,
            bio: d.bio,
            housing_goal: d.housing_goal,
            budget_min: d.budget_min,
            budget_max: d.budget_max,
            preferred_localities: d.preferred_localities || [],
            profile_completion: d.profile_completion,
            is_active: d.is_active,
            is_banned: !d.is_active,
            trust_score: d.trust_scores?.[0]?.score || 85,
            created_at: d.created_at,
            verifications: { phone: true, kyc: true }
          }));
        }
      } catch (e) {
        console.warn('Fallback to mock users:', e);
      }
    }
    return [...usersStore];
  },

  async toggleBanUser(userId: string, reason?: string): Promise<UserProfile> {
    const userIndex = usersStore.findIndex(u => u.id === userId);
    if (userIndex === -1) throw new Error('User not found');
    const user = usersStore[userIndex];
    const willBan = !user.is_banned;
    const oldData = { is_active: user.is_active, is_banned: user.is_banned };

    const updatedUser: UserProfile = {
      ...user,
      is_banned: willBan,
      is_active: !willBan,
      ban_reason: willBan ? (reason || 'Admin policy violation') : undefined
    };

    usersStore[userIndex] = updatedUser;
    recordAuditLog(willBan ? 'user.ban' : 'user.unban', 'profile', userId, oldData, updatedUser);

    if (isSupabaseConfigured) {
      await supabase.from('profiles').update({ is_active: !willBan }).eq('id', userId);
    }
    return updatedUser;
  },

  async verifyUserKyc(userId: string): Promise<UserProfile> {
    const userIndex = usersStore.findIndex(u => u.id === userId);
    if (userIndex === -1) throw new Error('User not found');
    const user = usersStore[userIndex];
    const oldData = { ...user.verifications, trust_score: user.trust_score };
    const updatedUser: UserProfile = {
      ...user,
      trust_score: Math.min(100, (user.trust_score || 70) + 15),
      verifications: {
        ...user.verifications,
        kyc: true,
        phone: true
      }
    };
    usersStore[userIndex] = updatedUser;
    recordAuditLog('kyc.verify_manual', 'profile', userId, oldData, updatedUser);
    return updatedUser;
  },

  // Listings Management
  async getListings(): Promise<PropertyListing[]> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('listings').select('*').limit(100);
        if (!error && data && data.length > 0) {
          return data.map((l: any) => ({
            id: l.id,
            owner_id: l.owner_id,
            owner_name: 'Property Owner',
            type: l.type,
            title: l.title,
            description: l.description,
            rent: Number(l.rent),
            deposit: Number(l.deposit || 0),
            maintenance: Number(l.maintenance || 0),
            furnishing: l.furnishing,
            locality: l.locality,
            city: l.city,
            room_type: l.room_type,
            bhk_type: l.bhk_type || '2BHK',
            quality_score: l.quality_score || 80,
            is_verified: l.is_verified,
            views_count: l.views_count || 120,
            status: l.status,
            is_sublet: l.is_sublet,
            is_short_stay: l.is_short_stay,
            photos: [],
            amenities: ['WiFi', 'Power Backup'],
            created_at: l.created_at,
            updated_at: l.updated_at
          }));
        }
      } catch (e) {
        console.warn('Fallback to mock listings:', e);
      }
    }
    return [...listingsStore];
  },

  async updateListingStatus(listingId: string, status: PropertyListing['status'], notes?: string): Promise<PropertyListing> {
    const index = listingsStore.findIndex(l => l.id === listingId);
    if (index === -1) throw new Error('Listing not found');
    const oldListing = listingsStore[index];
    const updated: PropertyListing = {
      ...oldListing,
      status,
      is_verified: status === 'active' ? true : oldListing.is_verified,
      updated_at: new Date().toISOString()
    };
    listingsStore[index] = updated;
    recordAuditLog(`listing.${status}`, 'listing', listingId, oldListing, { status, notes });

    if (isSupabaseConfigured) {
      await supabase.from('listings').update({ status, is_verified: updated.is_verified }).eq('id', listingId);
    }
    return updated;
  },

  // Moderation Queue
  async getModerationQueue(): Promise<ModerationQueueItem[]> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('moderation_queue').select('*').order('priority', { ascending: false });
        if (!error && data && data.length > 0) {
          return data;
        }
      } catch (e) {
        console.warn('Fallback to mock moderation queue:', e);
      }
    }
    return [...moderationStore];
  },

  async reviewModerationItem(itemId: string, action: 'approved' | 'rejected', notes?: string): Promise<ModerationQueueItem> {
    const index = moderationStore.findIndex(m => m.id === itemId);
    if (index === -1) throw new Error('Item not found');
    const old = moderationStore[index];
    const updated: ModerationQueueItem = {
      ...old,
      status: action,
      reviewed_by: 'adm-01',
      review_notes: notes || `Moderator marked as ${action}`,
      reviewed_at: new Date().toISOString()
    };
    moderationStore[index] = updated;
    recordAuditLog(`moderation.${action}`, 'moderation_queue', itemId, old, updated);

    if (isSupabaseConfigured) {
      await supabase.from('moderation_queue').update({
        status: action,
        review_notes: updated.review_notes,
        reviewed_at: updated.reviewed_at
      }).eq('id', itemId);
    }
    return updated;
  },

  // Disputes
  async getDisputes(): Promise<Dispute[]> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('disputes').select('*').order('created_at', { ascending: false });
        if (!error && data && data.length > 0) {
          return data;
        }
      } catch (e) {
        console.warn('Fallback to mock disputes:', e);
      }
    }
    return [...disputesStore];
  },

  async resolveDispute(disputeId: string, resolution: string, status: Dispute['status']): Promise<Dispute> {
    const index = disputesStore.findIndex(d => d.id === disputeId);
    if (index === -1) throw new Error('Dispute not found');
    const old = disputesStore[index];
    const updated: Dispute = {
      ...old,
      status,
      resolution,
      resolved_by: 'Current Admin',
      resolved_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };
    disputesStore[index] = updated;
    recordAuditLog(`dispute.${status}`, 'dispute', disputeId, old, updated);

    if (isSupabaseConfigured) {
      await supabase.from('disputes').update({
        status,
        resolution,
        resolved_at: updated.resolved_at
      }).eq('id', disputeId);
    }
    return updated;
  },

  // Corporate Relocation
  async getCorporateAccounts(): Promise<{
    accounts: CorporateAccount[];
    cohorts: RelocationCohort[];
    employees: CorporateEmployee[];
  }> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('corporate_accounts').select('*');
        if (!error && data && data.length > 0) {
          // Can map corporate accounts
        }
      } catch (e) {
        console.warn('Fallback to mock corporate accounts:', e);
      }
    }
    return {
      accounts: [...corporateStore],
      cohorts: [...relocationStore],
      employees: [...corporateEmployeesStore]
    };
  },

  async addCorporateAccount(account: Omit<CorporateAccount, 'id' | 'created_at' | 'placed_employees' | 'housing_subsidy_total' | 'compatibility_index_avg'>): Promise<CorporateAccount> {
    const newAccount: CorporateAccount = {
      ...account,
      id: `corp-${Date.now()}`,
      placed_employees: 0,
      housing_subsidy_total: 0,
      compatibility_index_avg: 92.0,
      created_at: new Date().toISOString()
    };
    corporateStore = [newAccount, ...corporateStore];
    recordAuditLog('corporate.create', 'corporate_account', newAccount.id, null, newAccount);
    return newAccount;
  },

  // College Housing
  async getCollegeAccounts(): Promise<{
    colleges: CollegeAccount[];
    batches: CollegeBatch[];
    students: StudentHousingProfile[];
  }> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('college_accounts').select('*');
        if (!error && data && data.length > 0) {
          // Can map college accounts
        }
      } catch (e) {
        console.warn('Fallback to mock colleges:', e);
      }
    }
    return {
      colleges: [...collegeStore],
      batches: [...collegeBatchesStore],
      students: [...studentProfilesStore]
    };
  },

  // Operator Accounts & Smart Allocation
  async getOperatorAccounts(): Promise<{
    operators: OperatorAccount[];
    properties: OperatorProperty[];
    allocations: SmartBedAllocation[];
  }> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('operator_accounts').select('*');
        if (!error && data && data.length > 0) {
          // Can map operator accounts
        }
      } catch (e) {
        console.warn('Fallback to mock operators:', e);
      }
    }
    return {
      operators: [...operatorStore],
      properties: [...operatorPropertiesStore],
      allocations: [...bedAllocationsStore]
    };
  },

  async updateBedAllocationStatus(allocationId: string, status: SmartBedAllocation['status']): Promise<SmartBedAllocation> {
    const index = bedAllocationsStore.findIndex(a => a.id === allocationId);
    if (index === -1) throw new Error('Allocation not found');
    const old = bedAllocationsStore[index];
    const updated = { ...old, status };
    bedAllocationsStore[index] = updated;
    recordAuditLog(`bed_allocation.${status}`, 'smart_bed_allocation', allocationId, old, updated);
    return updated;
  },

  // Audit Trail
  async getAuditLogs(): Promise<AuditLog[]> {
    if (isSupabaseConfigured) {
      try {
        const { data, error } = await supabase.from('audit_logs').select('*').order('created_at', { ascending: false }).limit(100);
        if (!error && data && data.length > 0) {
          return data;
        }
      } catch (e) {
        console.warn('Fallback to mock audit logs:', e);
      }
    }
    return [...auditLogsStore];
  }
};
