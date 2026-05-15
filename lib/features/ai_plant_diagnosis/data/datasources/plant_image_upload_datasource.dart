import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
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

  /// Downscale / re-encode before upload so Storage + Cloud Function fetch + Gemini see less data.
  static const int _maxSidePx = 1536;
  static const int _jpegQuality = 82;
  static const int _reencodeIfLargerThanBytes = 900 * 1024;

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

    final prepared = _prepareUploadBytes(bytes, mime);
    if (prepared.bytes.length > maxBytes) {
      throw const PlantDiagnosisFailure(PlantDiagnosisFailureReason.unsupportedImage);
    }

    final name = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('plant_uploads/$uid/$name');

    try {
      await ref.putData(
        prepared.bytes,
        SettableMetadata(contentType: prepared.contentType),
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

  /// Returns smaller JPEG when decode succeeds and resize/re-encode helps latency.
  ({Uint8List bytes, String contentType}) _prepareUploadBytes(
    Uint8List raw,
    String declaredMime,
  ) {
    try {
      final decoded = img.decodeImage(raw);
      if (decoded == null) {
        return (bytes: raw, contentType: _contentTypeFor(declaredMime));
      }

      final w = decoded.width;
      final h = decoded.height;
      final tooLargeSide = w > _maxSidePx || h > _maxSidePx;
      final heavyFile = raw.length > _reencodeIfLargerThanBytes;

      if (!tooLargeSide && !heavyFile) {
        return (bytes: raw, contentType: _contentTypeFor(declaredMime));
      }

      final img.Image resized = tooLargeSide
          ? (w >= h
              ? img.copyResize(decoded, width: _maxSidePx, interpolation: img.Interpolation.average)
              : img.copyResize(decoded, height: _maxSidePx, interpolation: img.Interpolation.average))
          : decoded;

      final out = Uint8List.fromList(
        img.encodeJpg(resized, quality: _jpegQuality),
      );
      return (bytes: out, contentType: 'image/jpeg');
    } catch (e, st) {
      debugPrint('PlantImageUploadDatasource: prepare bytes skipped: $e\n$st');
      return (bytes: raw, contentType: _contentTypeFor(declaredMime));
    }
  }
}
