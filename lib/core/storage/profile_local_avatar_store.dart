import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Saves the profile photo under app documents so it survives restarts.
/// One file per [uid] so different accounts do not share the same image.
abstract final class ProfileLocalAvatarStore {
  ProfileLocalAvatarStore._();

  static String _fileNameForUid(String uid) {
    final safe = uid.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return 'profile_avatar_$safe';
  }

  static Future<File> _fileForUid(String uid) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/${_fileNameForUid(uid)}');
  }

  static Future<File?> loadIfExists(String uid) async {
    final f = await _fileForUid(uid);
    return await f.exists() ? f : null;
  }

  /// [path] from gallery/file picker; [bytes] used when [path] is missing.
  static Future<File?> persistPick(
    String uid, {
    String? path,
    List<int>? bytes,
  }) async {
    final dest = await _fileForUid(uid);
    if (path != null && path.isNotEmpty) {
      final src = File(path);
      if (await src.exists()) {
        await src.copy(dest.path);
        return dest;
      }
    }
    if (bytes != null && bytes.isNotEmpty) {
      await dest.writeAsBytes(bytes, flush: true);
      return dest;
    }
    return null;
  }
}
