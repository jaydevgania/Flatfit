import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/photo_upload_service.dart';
import '../../data/profile_remote_data_source.dart';
import '../../data/profile_repository.dart';
import '../../domain/profile_model.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Remote data source provider
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRemoteDataSource(client);
});

/// Photo upload service provider
final photoUploadServiceProvider = Provider<PhotoUploadService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PhotoUploadService(client);
});

/// Profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  final photoService = ref.watch(photoUploadServiceProvider);
  return ProfileRepository(dataSource, photoService);
});

/// State for the current user's profile
class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  /// Load current user profile
  Future<void> loadProfile({String? userId}) async {
    try {
      state = const AsyncValue.loading();
      final profile = userId != null
          ? await _repository.getProfile(userId)
          : await _repository.getCurrentProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Save or create profile
  Future<bool> saveProfile(Profile profile) async {
    try {
      final updated = await _repository.saveProfile(profile);
      state = AsyncValue.data(updated);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Update partial fields
  Future<bool> updateFields(Map<String, dynamic> fields) async {
    try {
      final updated = await _repository.updateProfileFields(fields);
      state = AsyncValue.data(updated);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Upload photo
  Future<bool> uploadPhoto(XFile file, int position) async {
    final current = state.value;
    if (current == null) return false;

    try {
      final newPhoto = await _repository.addPhoto(
        userId: current.id,
        file: file,
        position: position,
      );

      final updatedPhotos = List<ProfilePhoto>.from(current.photos)..add(newPhoto);
      final updatedProfile = current.copyWith(photos: updatedPhotos);
      state = AsyncValue.data(updatedProfile);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Delete photo
  Future<bool> deletePhoto(String photoId, int position) async {
    final current = state.value;
    if (current == null) return false;

    try {
      await _repository.deletePhoto(
        userId: current.id,
        photoId: photoId,
        position: position,
      );

      final updatedPhotos =
          current.photos.where((p) => p.id != photoId).toList();
      final updatedProfile = current.copyWith(photos: updatedPhotos);
      state = AsyncValue.data(updatedProfile);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Set primary photo
  Future<bool> setPrimaryPhoto(String photoId) async {
    final current = state.value;
    if (current == null) return false;

    try {
      await _repository.setPrimaryPhoto(current.id, photoId);
      final updatedPhotos = current.photos.map((p) {
        return ProfilePhoto(
          id: p.id,
          profileId: p.profileId,
          url: p.url,
          position: p.position,
          isPrimary: p.id == photoId,
          createdAt: p.createdAt,
        );
      }).toList();

      state = AsyncValue.data(current.copyWith(photos: updatedPhotos));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Upload voice intro
  Future<bool> uploadVoiceIntro(XFile file, int durationSeconds) async {
    final current = state.value;
    if (current == null) return false;

    try {
      final voice = await _repository.saveVoiceIntro(
        userId: current.id,
        file: file,
        durationSeconds: durationSeconds,
      );
      state = AsyncValue.data(current.copyWith(voiceIntro: voice));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Delete voice intro
  Future<bool> deleteVoiceIntro() async {
    final current = state.value;
    if (current == null) return false;

    try {
      await _repository.deleteVoiceIntro(current.id);
      state = AsyncValue.data(current.copyWith(voiceIntro: null));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Profile state provider
final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Profile?>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});

/// Provider family for viewing other users' profiles
final otherUserProfileProvider =
    FutureProvider.family<Profile?, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile(userId);
});
