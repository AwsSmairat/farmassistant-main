import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/failures/plant_diagnosis_failure.dart';

/// Uploads phone gallery/camera images to Firebase Storage (no API keys).
class PlantImageUploadDatasource {
  PlantImageUploadDatasource({
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  static const int maxBytes = 15 * 1024 * 1024;

  /// `plant_uploads/{userId}/{timestamp}.jpg`
  Future<String> uploadPhonePlantImage(XFile image) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.notAuthenticated);
    }

    final bytes = await image.readAsBytes();
    if (bytes.isEmpty) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.unsupportedImage);
    }
    if (bytes.length > maxBytes) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.unsupportedImage);
    }

    final mime = (image.mimeType ?? 'image/jpeg').toLowerCase();
    if (!_isAllowedMime(mime)) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.unsupportedImage);
    }

    final name = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('plant_uploads/$uid/$name');

    final contentType = _contentTypeFor(mime);

    try {
      await ref.putData(
        bytes,
        SettableMetadata(contentType: contentType),
      );
      return ref.getDownloadURL();
    } catch (e, st) {
      debugPrint('PlantImageUploadDatasource: $e\n$st');
      throw PlantDiagnosisFailure(PlantDiagnosisFailureReason.uploadFailed, technical: e);
    }
  }

  bool _isAllowedMime(String mime) {
    return mime.contains('jpeg') ||
        mime.contains('jpg') ||
        mime.contains('png') ||
        mime.contains('webp') ||
        mime.contains('heic') ||
        mime.contains('heif');
  }

  String _contentTypeFor(String mime) {
    if (mime.contains('png')) return 'image/png';
    if (mime.contains('webp')) return 'image/webp';
    if (mime.contains('heic') || mime.contains('heif')) return 'image/heic';
    return 'image/jpeg';
  }
}
