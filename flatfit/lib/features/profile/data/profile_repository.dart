import '../domain/profile_model.dart';
import 'profile_remote_data_source.dart';
import 'photo_upload_service.dart';
import 'package:image_picker/image_picker.dart';

/// Repository providing clean profile CRUD operations.
class ProfileRepository {
  final ProfileRemoteDataSource _dataSource;
  final PhotoUploadService _photoService;

  ProfileRepository(this._dataSource, this._photoService);

  /// Get the current user's ID.
  String? get currentUserId => _dataSource.currentUserId;

  /// Fetch a user's full profile (with photos & voice intro).
  Future<Profile?> getProfile(String userId) async {
    final json = await _dataSource.getProfile(userId);
    if (json == null) return null;
    return Profile.fromJson(json);
  }

  /// Fetch the current authenticated user's profile.
  Future<Profile?> getCurrentProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;
    return getProfile(userId);
  }

  /// Create or update the profile.
  Future<Profile> saveProfile(Profile profile) async {
    final data = profile.toJson();
    data['profile_completion'] = profile.calculateCompletion();
    final json = await _dataSource.upsertProfile(data);
    return Profile.fromJson(json);
  }

  /// Update specific fields on the current user's profile.
  Future<Profile> updateProfileFields(Map<String, dynamic> fields) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    final json = await _dataSource.updateProfile(userId, fields);
    return Profile.fromJson(json);
  }

  /// Upload a photo and add it to the profile.
  Future<ProfilePhoto> addPhoto({
    required String userId,
    required XFile file,
    required int position,
  }) async {
    // Upload to storage
    final url = await _photoService.uploadPhoto(
      userId: userId,
      file: file,
      position: position,
    );

    // Save record in database
    final json = await _dataSource.addPhoto({
      'profile_id': userId,
      'url': url,
      'position': position,
      'is_primary': position == 0,
    });

    return ProfilePhoto.fromJson(json);
  }

  /// Delete a photo from storage and database.
  Future<void> deletePhoto({
    required String userId,
    required String photoId,
    required int position,
  }) async {
    await _photoService.deletePhoto(userId: userId, position: position);
    await _dataSource.deletePhoto(photoId);
  }

  /// Reorder photos (swap positions).
  Future<void> reorderPhotos(
      String profileId, List<Map<String, dynamic>> updates) async {
    await _dataSource.reorderPhotos(profileId, updates);
  }

  /// Set a photo as primary.
  Future<void> setPrimaryPhoto(String profileId, String photoId) async {
    await _dataSource.setPrimaryPhoto(profileId, photoId);
  }

  /// Upload and save a voice/video intro.
  Future<VoiceIntro> saveVoiceIntro({
    required String userId,
    required XFile file,
    required int durationSeconds,
  }) async {
    final url = await _photoService.uploadVoiceIntro(
      userId: userId,
      file: file,
    );

    final json = await _dataSource.saveVoiceIntro({
      'profile_id': userId,
      'url': url,
      'duration_seconds': durationSeconds,
    });

    return VoiceIntro.fromJson(json);
  }

  /// Delete the voice intro.
  Future<void> deleteVoiceIntro(String userId) async {
    await _photoService.deleteVoiceIntro(userId: userId);
    await _dataSource.deleteVoiceIntro(userId);
  }
}
