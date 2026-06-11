// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile_local_avatar_store_web.dart
// المسار: core/storage/profile_local_avatar_store_web.dart
// الطبقة: core / storage — التخزين المحلي
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • loadAvatarBytes()
//   • persistAvatarPick()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:typed_data';

/// In-memory avatar cache for web (paths from file picker are usually unavailable).
final Map<String, Uint8List> _avatarMemory = {};

/// دالة load صورة bytes.
Future<Uint8List?> loadAvatarBytes(String uid) async => _avatarMemory[uid];

/// دالة persist صورة pick.
Future<Uint8List?> persistAvatarPick(
  String uid, {
  String? path,
  Uint8List? bytes,
}) async {
  if (bytes != null && bytes.isNotEmpty) {
    _avatarMemory[uid] = bytes;
    return bytes;
  }
  return null;
}
