import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flatfit/features/matching/domain/profile.dart';
import 'package:flatfit/features/discovery/domain/discovery_filters.dart';
import 'package:flatfit/features/discovery/domain/group_search_model.dart';
import 'package:flatfit/features/discovery/domain/interest_model.dart';

/// Data source executing Supabase queries for discovery, filters, shortlists, interests, and groups.
class DiscoveryDataSource {
  final SupabaseClient _client;

  DiscoveryDataSource(this._client);

  /// Queries profiles matching filter criteria with pagination.
  Future<List<Profile>> fetchProfiles({
    required String currentUserId,
    required DiscoveryFilters filters,
    int limit = 30,
    int offset = 0,
  }) async {
    var query = _client.from('profiles').select('''
      *,
      profile_photos(url, is_primary, position)
    ''').eq('is_active', true).neq('id', currentUserId);

    // Apply filters
    if (filters.gender != 'any') {
      query = query.eq('gender', filters.gender);
    }
    if (filters.housingGoal != 'any') {
      query = query.eq('housingGoal', filters.housingGoal);
    }

    query = query
        .gte('age', filters.ageMin)
        .lte('age', filters.ageMax)
        .lte('budget_min', filters.budgetMax)
        .gte('budget_max', filters.budgetMin);

    if (filters.localities.isNotEmpty) {
      query = query.overlaps('preferred_localities', filters.localities);
    }

    final response = await query.range(offset, offset + limit - 1);
    final rawList = List<Map<String, dynamic>>.from(response);

    return rawList.map((map) {
      final photosList = <String>[];
      String? primaryPhoto;
      if (map['profile_photos'] != null && map['profile_photos'] is List) {
        final photos = List<Map<String, dynamic>>.from(map['profile_photos'] as List);
        photos.sort((a, b) => ((a['position'] as int?) ?? 1).compareTo((b['position'] as int?) ?? 1));
        for (final p in photos) {
          final url = p['url']?.toString();
          if (url != null && url.isNotEmpty) {
            photosList.add(url);
            if (p['is_primary'] == true && primaryPhoto == null) {
              primaryPhoto = url;
            }
          }
        }
      }
      map['photos'] = photosList;
      if (primaryPhoto != null) {
        map['primary_photo_url'] = primaryPhoto;
      }
      return Profile.fromJson(map);
    }).toList();
  }

  /// Sends an interest request (standard or super-interest).
  Future<void> sendInterest({
    required String fromUserId,
    required String toUserId,
    String? note,
    bool isSuperInterest = false,
  }) async {
    await _client.from('interests').upsert({
      'from_user': fromUserId,
      'to_user': toUserId,
      'note': note,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    }, onConflict: 'from_user,to_user');
  }

  /// Updates status of an interest request ('accepted' or 'declined').
  Future<void> respondToInterest({
    required String interestId,
    required String status,
  }) async {
    await _client
        .from('interests')
        .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', interestId);
  }

  /// Fetches incoming interest requests for the user.
  Future<List<InterestModel>> fetchIncomingInterests(String userId) async {
    final response = await _client
        .from('interests')
        .select('''
          *,
          from_profile:profiles!interests_from_user_fkey(
            *,
            profile_photos(url, is_primary, position)
          )
        ''')
        .eq('to_user', userId)
        .order('created_at', ascending: false);

    return (response as List).map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      return InterestModel.fromJson(map);
    }).toList();
  }

  /// Fetches outgoing interest requests sent by the user.
  Future<List<InterestModel>> fetchOutgoingInterests(String userId) async {
    final response = await _client
        .from('interests')
        .select('''
          *,
          to_profile:profiles!interests_to_user_fkey(
            *,
            profile_photos(url, is_primary, position)
          )
        ''')
        .eq('from_user', userId)
        .order('created_at', ascending: false);

    return (response as List).map((row) {
      final map = Map<String, dynamic>.from(row as Map);
      return InterestModel.fromJson(map);
    }).toList();
  }

  /// Adds or removes a profile from the user's shortlist.
  Future<bool> toggleShortlist({
    required String userId,
    required String targetUserId,
  }) async {
    final existing = await _client
        .from('shortlists')
        .select('id')
        .eq('user_id', userId)
        .eq('shortlisted_user_id', targetUserId)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('shortlists')
          .delete()
          .eq('user_id', userId)
          .eq('shortlisted_user_id', targetUserId);
      return false; // removed
    } else {
      await _client.from('shortlists').insert({
        'user_id': userId,
        'shortlisted_user_id': targetUserId,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true; // added
    }
  }

  /// Fetches all profiles shortlisted by the user.
  Future<List<Profile>> fetchShortlistedProfiles(String userId) async {
    final response = await _client
        .from('shortlists')
        .select('''
          shortlisted_user_id,
          target_profile:profiles!shortlists_shortlisted_user_id_fkey(
            *,
            profile_photos(url, is_primary, position)
          )
        ''')
        .eq('user_id', userId);

    final list = <Profile>[];
    for (final row in response as List) {
      final pMap = row['target_profile'] as Map<String, dynamic>?;
      if (pMap != null) {
        list.add(Profile.fromJson(pMap));
      }
    }
    return list;
  }

  /// Saves a search filter preset.
  Future<void> saveSearchFilter({
    required String userId,
    required String name,
    required DiscoveryFilters filters,
    bool alertEnabled = false,
  }) async {
    await _client.from('saved_searches').insert({
      'user_id': userId,
      'name': name,
      'filters': filters.toJson(),
      'alert_enabled': alertEnabled,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Fetches saved search presets for user.
  Future<List<Map<String, dynamic>>> fetchSavedSearches(String userId) async {
    final res = await _client
        .from('saved_searches')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  /// Deletes a saved search preset.
  Future<void> deleteSavedSearch(String id) async {
    await _client.from('saved_searches').delete().eq('id', id);
  }

  /// Fetches groups the user is part of.
  Future<List<GroupSearchModel>> fetchUserGroups(String userId) async {
    final res = await _client
        .from('group_members')
        .select('''
          group_id,
          groups(
            *,
            group_members(
              *,
              profiles(
                *,
                profile_photos(url, is_primary)
              )
            )
          )
        ''')
        .eq('user_id', userId);

    final groups = <GroupSearchModel>[];
    for (final item in res as List) {
      final gMap = item['groups'] as Map<String, dynamic>?;
      if (gMap != null) {
        groups.add(GroupSearchModel.fromJson(gMap));
      }
    }
    return groups;
  }

  /// Creates a new flat-hunting group.
  Future<GroupSearchModel> createGroup({
    required String name,
    String? description,
    required String userId,
    int maxMembers = 4,
  }) async {
    final res = await _client.from('groups').insert({
      'name': name,
      'description': description,
      'created_by': userId,
      'max_members': maxMembers,
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();

    final groupId = res['id'] as String;

    // Add creator as member
    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
      'joined_at': DateTime.now().toIso8601String(),
    });

    return GroupSearchModel.fromJson(res);
  }
}
