// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile_local_avatar_store.dart
// المسار: core/storage/profile_local_avatar_store.dart
// الطبقة: core / storage — التخزين المحلي
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • profile_local_avatar_store
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:typed_data';

import 'profile_local_avatar_store_stub.dart'
    if (dart.library.html) 'profile_local_avatar_store_web.dart'
    if (dart.library.io) 'profile_local_avatar_store_io.dart' as avatar_store_impl;

/// Persists profile photo bytes per account. On mobile/desktop IO uses documents
/// directory; on web uses an in-session memory cache (bytes from picker).
abstract final class ProfileLocalAvatarStore {
  ProfileLocalAvatarStore._();

  /// دالة load if exists.
  static Future<Uint8List?> loadIfExists(String uid) => avatar_store_impl.loadAvatarBytes(uid);

  /// دالة persist pick.
  static Future<Uint8List?> persistPick(
    String uid, {
    String? path,
    List<int>? bytes,
  }) =>
      avatar_store_impl.persistAvatarPick(
        uid,
        path: path,
        bytes: bytes == null ? null : Uint8List.fromList(bytes),
      );
}
