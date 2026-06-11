// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile_local_avatar_store_stub.dart
// المسار: core/storage/profile_local_avatar_store_stub.dart
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

/// دالة load صورة bytes.
Future<Uint8List?> loadAvatarBytes(String uid) async => null;

/// دالة persist صورة pick.
Future<Uint8List?> persistAvatarPick(
  String uid, {
  String? path,
  Uint8List? bytes,
}) async =>
    null;
