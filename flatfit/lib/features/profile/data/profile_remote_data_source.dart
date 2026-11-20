import 'package:supabase_flutter/supabase_flutter.dart';

/// Raw Supabase queries for profile data.
class ProfileRemoteDataSource {
  final SupabaseClient _client;

  ProfileRemoteDataSource(this._client);

  /// Fetch a profile by user ID, including photos and voice intros.
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select('*, profile_photos(*), voice_intros(*)')
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  /// Create or update a profile.
  Future<Map<String, dynamic>> upsertProfile(
      Map<String, dynamic> data) async {
    final response = await _client
        .from('profiles')
        .upsert(data)
        .select()
        .single();
    return response;
  }

  /// Update specific profile fields.
  Future<Map<String, dynamic>> updateProfile(
      String userId, Map<String, dynamic> data) async {
    final response = await _client
        .from('profiles')
        .update({...data, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId)
        .select()
        .single();
    return response;
  }

  /// Insert a profile photo record.
  Future<Map<String, dynamic>> addPhoto(Map<String, dynamic> data) async {
    final response = await _client
        .from('profile_photos')
        .insert(data)
        .select()
        .single();
    return response;
  }

  /// Delete a profile photo by ID.
  Future<void> deletePhoto(String photoId) async {
    await _client.from('profile_photos').delete().eq('id', photoId);
  }

  /// Reorder photos by updating positions.
  Future<void> reorderPhotos(
      String profileId, List<Map<String, dynamic>> updates) async {
    for (final update in updates) {
      await _client
          .from('profile_photos')
          .update({'position': update['position']})
          .eq('id', update['id'])
          .eq('profile_id', profileId);
    }
  }

  /// Set a photo as the primary photo.
  Future<void> setPrimaryPhoto(String profileId, String photoId) async {
    // Un-set all current primary
    await _client
        .from('profile_photos')
        .update({'is_primary': false})
        .eq('profile_id', profileId);
    // Set the new primary
    await _client
        .from('profile_photos')
        .update({'is_primary': true})
        .eq('id', photoId);
  }

  /// Save a voice/video intro.
  Future<Map<String, dynamic>> saveVoiceIntro(
      Map<String, dynamic> data) async {
    // Delete existing intro first (one per profile)
    await _client
        .from('voice_intros')
        .delete()
        .eq('profile_id', data['profile_id']);
    final response = await _client
        .from('voice_intros')
        .insert(data)
        .select()
        .single();
    return response;
  }

  /// Delete voice intro for a profile.
  Future<void> deleteVoiceIntro(String profileId) async {
    await _client.from('voice_intros').delete().eq('profile_id', profileId);
  }

  /// Get the current authenticated user's ID.
  String? get currentUserId => _client.auth.currentUser?.id;
}
