import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

/// Service for uploading profile photos and voice/video intros to Supabase Storage.
class PhotoUploadService {
  final SupabaseClient _client;
  final ImagePicker _picker;

  static const String _photoBucket = 'profile-photos';
  static const String _voiceBucket = 'voice-intros';
  static const int maxPhotos = 5;
  static const int maxVoiceDurationSec = 30;
  static const int minVoiceDurationSec = 15;

  PhotoUploadService(this._client) : _picker = ImagePicker();

  /// Pick an image from gallery.
  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
  }

  /// Pick an image from camera.
  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
  }

  /// Pick a video (for voice/video intro).
  Future<XFile?> pickVideo() async {
    return await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: maxVoiceDurationSec),
    );
  }

  /// Upload a photo to Supabase Storage.
  /// Returns the public URL of the uploaded photo.
  Future<String> uploadPhoto({
    required String userId,
    required XFile file,
    required int position,
  }) async {
    final bytes = await file.readAsBytes();
    final ext = file.name.split('.').last;
    final path = '$userId/photo_$position.$ext';

    await _client.storage.from(_photoBucket).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    return _client.storage.from(_photoBucket).getPublicUrl(path);
  }

  /// Upload a voice/video intro to Supabase Storage.
  /// Returns the public URL of the uploaded file.
  Future<String> uploadVoiceIntro({
    required String userId,
    required XFile file,
  }) async {
    final bytes = await file.readAsBytes();
    final ext = file.name.split('.').last;
    final path = '$userId/voice_intro.$ext';

    await _client.storage.from(_voiceBucket).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    return _client.storage.from(_voiceBucket).getPublicUrl(path);
  }

  /// Delete a photo from storage.
  Future<void> deletePhoto({
    required String userId,
    required int position,
    String ext = 'jpg',
  }) async {
    final path = '$userId/photo_$position.$ext';
    await _client.storage.from(_photoBucket).remove([path]);
  }

  /// Delete a voice intro from storage.
  Future<void> deleteVoiceIntro({required String userId}) async {
    // List files in user folder to find the intro
    final files = await _client.storage.from(_voiceBucket).list(path: userId);
    final intros = files
        .where((f) => f.name.startsWith('voice_intro'))
        .map((f) => '$userId/${f.name}')
        .toList();
    if (intros.isNotEmpty) {
      await _client.storage.from(_voiceBucket).remove(intros);
    }
  }
}
