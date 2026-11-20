import '../../matching/domain/profile.dart';
import '../domain/discovery_filters.dart';
import '../domain/group_search_model.dart';
import '../domain/interest_model.dart';
import 'discovery_data_source.dart';

/// Repository for the Discovery feature.
class DiscoveryRepository {
  final DiscoveryDataSource _dataSource;

  DiscoveryRepository(this._dataSource);

  /// Retrieves discovery profiles matching current filters.
  Future<List<Profile>> getProfiles({
    required String currentUserId,
    required DiscoveryFilters filters,
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      final profiles = await _dataSource.fetchProfiles(
        currentUserId: currentUserId,
        filters: filters,
        limit: limit,
        offset: offset,
      );

      if (profiles.isEmpty) {
        return _getDemoDiscoveryProfiles();
      }
      return profiles;
    } catch (_) {
      return _getDemoDiscoveryProfiles();
    }
  }

  /// Sends interest request to a flatmate candidate.
  Future<void> sendInterest({
    required String fromUserId,
    required String toUserId,
    String? note,
    bool isSuperInterest = false,
  }) async {
    try {
      await _dataSource.sendInterest(
        fromUserId: fromUserId,
        toUserId: toUserId,
        note: note,
        isSuperInterest: isSuperInterest,
      );
    } catch (_) {
      // Offline fallback
    }
  }

  /// Accepts or declines an interest request.
  Future<void> respondToInterest({
    required String interestId,
    required String status,
  }) async {
    try {
      await _dataSource.respondToInterest(interestId: interestId, status: status);
    } catch (_) {}
  }

  /// Fetches incoming interest requests.
  Future<List<InterestModel>> getIncomingInterests(String userId) async {
    try {
      final list = await _dataSource.fetchIncomingInterests(userId);
      if (list.isEmpty) return _getDemoIncomingInterests();
      return list;
    } catch (_) {
      return _getDemoIncomingInterests();
    }
  }

  /// Fetches outgoing interest requests.
  Future<List<InterestModel>> getOutgoingInterests(String userId) async {
    try {
      final list = await _dataSource.fetchOutgoingInterests(userId);
      if (list.isEmpty) return _getDemoOutgoingInterests();
      return list;
    } catch (_) {
      return _getDemoOutgoingInterests();
    }
  }

  /// Adds or removes a profile from the user's shortlist.
  Future<bool> toggleShortlist({
    required String userId,
    required String targetUserId,
  }) async {
    try {
      return await _dataSource.toggleShortlist(
        userId: userId,
        targetUserId: targetUserId,
      );
    } catch (_) {
      return true;
    }
  }

  /// Fetches all profiles shortlisted by the user.
  Future<List<Profile>> getShortlistedProfiles(String userId) async {
    try {
      final list = await _dataSource.fetchShortlistedProfiles(userId);
      if (list.isEmpty) return _getDemoShortlistedProfiles();
      return list;
    } catch (_) {
      return _getDemoShortlistedProfiles();
    }
  }

  /// Saves a search filter preset.
  Future<void> saveSearch({
    required String userId,
    required String name,
    required DiscoveryFilters filters,
    bool alertEnabled = false,
  }) async {
    try {
      await _dataSource.saveSearchFilter(
        userId: userId,
        name: name,
        filters: filters,
        alertEnabled: alertEnabled,
      );
    } catch (_) {}
  }

  /// Fetches saved search presets.
  Future<List<Map<String, dynamic>>> getSavedSearches(String userId) async {
    try {
      final list = await _dataSource.fetchSavedSearches(userId);
      if (list.isEmpty) return _getDemoSavedSearches();
      return list;
    } catch (_) {
      return _getDemoSavedSearches();
    }
  }

  /// Deletes a saved search preset.
  Future<void> deleteSavedSearch(String id) async {
    try {
      await _dataSource.deleteSavedSearch(id);
    } catch (_) {}
  }

  /// Fetches groups the user is part of.
  Future<List<GroupSearchModel>> getUserGroups(String userId) async {
    try {
      final list = await _dataSource.fetchUserGroups(userId);
      if (list.isEmpty) return _getDemoGroups();
      return list;
    } catch (_) {
      return _getDemoGroups();
    }
  }

  /// Creates a new flat-hunting group.
  Future<GroupSearchModel> createGroup({
    required String name,
    String? description,
    required String userId,
    int maxMembers = 4,
  }) async {
    try {
      return await _dataSource.createGroup(
        name: name,
        description: description,
        userId: userId,
        maxMembers: maxMembers,
      );
    } catch (_) {
      return GroupSearchModel(
        id: 'group_new_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        createdBy: userId,
        maxMembers: maxMembers,
        createdAt: DateTime.now(),
      );
    }
  }

  // --- Demo / Fallback Data ---
  List<Profile> _getDemoDiscoveryProfiles() {
    return [
      const Profile(
        id: 'p_rohan',
        fullName: 'Rohan Sharma',
        age: 26,
        gender: 'male',
        occupation: 'working',
        companyOrCollege: 'Razorpay, Product Designer',
        city: 'Mumbai',
        locality: 'Bandra West',
        bio: 'UI designer at fintech startup. Early riser, love pour-over coffee, gym 4x/week, and quiet evenings.',
        housingGoal: 'need_room',
        budgetMin: 20000,
        budgetMax: 30000,
        preferredLocalities: ['Bandra West', 'Khar West', 'Pali Hill'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
        photos: [
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=800&q=80',
        ],
        keyTraits: ['Non-Smoker', 'Early Bird', 'Pure Veg friendly', 'WFH 2 days'],
        isVerified: true,
      ),
      const Profile(
        id: 'p_priya',
        fullName: 'Priya Iyer',
        age: 24,
        gender: 'female',
        occupation: 'working',
        companyOrCollege: 'Zomato, Frontend Dev',
        city: 'Mumbai',
        locality: 'Andheri West',
        bio: 'Frontend engineer who loves cooking South Indian food on weekends. Clean, organized, pet lover.',
        housingGoal: 'need_room',
        budgetMin: 18000,
        budgetMax: 26000,
        preferredLocalities: ['Andheri West', 'Lokhandwala', 'Versova'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
        photos: [
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80',
        ],
        keyTraits: ['Pet Friendly', 'Veg/Egg', 'Moderate Sleep', 'Occasional Drinks'],
        isVerified: true,
      ),
      const Profile(
        id: 'p_aarav',
        fullName: 'Aarav Mehta',
        age: 27,
        gender: 'male',
        occupation: 'freelancer',
        companyOrCollege: 'Freelance Filmmaker & Editor',
        city: 'Mumbai',
        locality: 'Versova',
        bio: 'Filmmaker and colorist. Mostly editing with headphones. Chill vibe, love weekend indie movie screenings.',
        housingGoal: 'have_room',
        budgetMin: 22000,
        budgetMax: 32000,
        preferredLocalities: ['Versova', 'Juhu'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
        photos: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
        ],
        keyTraits: ['Night Owl', 'Social Drinker', 'Movie Buff', 'Have 2BHK Room'],
        isVerified: false,
      ),
      const Profile(
        id: 'p_tanvi',
        fullName: 'Tanvi Kulkarni',
        age: 25,
        gender: 'female',
        occupation: 'working',
        companyOrCollege: 'Deloitte, Consultant',
        city: 'Mumbai',
        locality: 'Powai',
        bio: 'Management consultant near Hiranandani Powai. Very punctual with bills and rent, neat and quiet.',
        housingGoal: 'need_room',
        budgetMin: 25000,
        budgetMax: 35000,
        preferredLocalities: ['Powai', 'Kanjurmarg West'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        photos: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        ],
        keyTraits: ['Punctual', 'Cleanliness Geek', 'Quiet Study', 'Non-Smoker'],
        isVerified: true,
      ),
      const Profile(
        id: 'p_kabir',
        fullName: 'Kabir Oberoi',
        age: 28,
        gender: 'male',
        occupation: 'working',
        companyOrCollege: 'Morgan Stanley, Quant Analyst',
        city: 'Mumbai',
        locality: 'Lower Parel',
        bio: 'Quant analyst in Lower Parel. Looking for flatmate in modern high-rise. Gym, pool, clean kitchen.',
        housingGoal: 'looking_together',
        budgetMin: 35000,
        budgetMax: 50000,
        preferredLocalities: ['Lower Parel', 'Worli', 'Prabhadevi'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=800&q=80',
        photos: [
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=800&q=80',
        ],
        keyTraits: ['High Rise Lover', 'Non-Smoker', 'Strict Fitness', 'Quiet Nights'],
        isVerified: true,
      ),
    ];
  }

  List<InterestModel> _getDemoIncomingInterests() {
    return [
      InterestModel(
        id: 'int_1',
        fromUserId: 'p_priya',
        toUserId: 'current_user',
        note: 'Hey! Loved your profile. I also work hybrid in tech and need a place near Andheri metro!',
        status: InterestStatus.pending,
        isSuperInterest: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        fromProfile: const Profile(
          id: 'p_priya',
          fullName: 'Priya Iyer',
          age: 24,
          locality: 'Andheri West',
          occupation: 'Frontend Dev at Zomato',
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
          keyTraits: ['Pet Friendly', 'Veg/Egg', 'Moderate Sleep'],
        ),
      ),
      InterestModel(
        id: 'int_2',
        fromUserId: 'p_aarav',
        toUserId: 'current_user',
        note: 'Have a master bedroom available in a 2BHK in Versova. Let me know if you want to visit!',
        status: InterestStatus.pending,
        isSuperInterest: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        fromProfile: const Profile(
          id: 'p_aarav',
          fullName: 'Aarav Mehta',
          age: 27,
          locality: 'Versova',
          occupation: 'Filmmaker',
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
          keyTraits: ['Night Owl', 'Movie Buff', 'Have 2BHK Room'],
        ),
      ),
    ];
  }

  List<InterestModel> _getDemoOutgoingInterests() {
    return [
      InterestModel(
        id: 'int_out_1',
        fromUserId: 'current_user',
        toUserId: 'p_rohan',
        note: 'Hi Rohan! We have 94% compatibility. Would love to connect regarding Bandra flats!',
        status: InterestStatus.pending,
        isSuperInterest: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        toProfile: const Profile(
          id: 'p_rohan',
          fullName: 'Rohan Sharma',
          age: 26,
          locality: 'Bandra West',
          occupation: 'Product Designer',
          primaryPhotoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
        ),
      ),
    ];
  }

  List<Profile> _getDemoShortlistedProfiles() {
    return [
      const Profile(
        id: 'p_rohan',
        fullName: 'Rohan Sharma',
        age: 26,
        gender: 'male',
        occupation: 'Product Designer at Razorpay',
        city: 'Mumbai',
        locality: 'Bandra West',
        budgetMin: 20000,
        budgetMax: 30000,
        preferredLocalities: ['Bandra West', 'Khar West'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
        keyTraits: ['Non-Smoker', 'Early Bird', 'Pure Veg friendly'],
      ),
      const Profile(
        id: 'p_tanvi',
        fullName: 'Tanvi Kulkarni',
        age: 25,
        gender: 'female',
        occupation: 'Consultant at Deloitte',
        city: 'Mumbai',
        locality: 'Powai',
        budgetMin: 25000,
        budgetMax: 35000,
        preferredLocalities: ['Powai', 'Kanjurmarg West'],
        primaryPhotoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
        keyTraits: ['Punctual', 'Cleanliness Geek', 'Quiet Study'],
      ),
    ];
  }

  List<Map<String, dynamic>> _getDemoSavedSearches() {
    return [
      {
        'id': 'saved_1',
        'name': 'Bandra & Khar under ₹30K',
        'alert_enabled': true,
        'filters': {
          'budget_min': 15000,
          'budget_max': 30000,
          'localities': ['Bandra West', 'Khar West'],
        },
      },
      {
        'id': 'saved_2',
        'name': 'Powai Techies / Vegetarians',
        'alert_enabled': false,
        'filters': {
          'budget_min': 20000,
          'budget_max': 35000,
          'localities': ['Powai'],
        },
      },
    ];
  }

  List<GroupSearchModel> _getDemoGroups() {
    return [
      GroupSearchModel(
        id: 'group_1',
        name: 'Bandra 3BHK Search Squad',
        description: 'Looking to rent a spacious 3BHK in Bandra/Khar with a terrace.',
        createdBy: 'current_user',
        maxMembers: 3,
        combinedBudgetMin: 75000,
        combinedBudgetMax: 110000,
        preferredLocalities: const ['Bandra West', 'Khar West', 'Pali Hill'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        members: const [
          GroupMemberModel(
            id: 'gm_1',
            groupId: 'group_1',
            userId: 'current_user',
            joinedAt: null,
          ),
          GroupMemberModel(
            id: 'gm_2',
            groupId: 'group_1',
            userId: 'p_rohan',
            joinedAt: null,
            profile: Profile(
              id: 'p_rohan',
              fullName: 'Rohan Sharma',
              age: 26,
              occupation: 'Product Designer',
              primaryPhotoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80',
            ),
          ),
        ],
      ),
    ];
  }
}
