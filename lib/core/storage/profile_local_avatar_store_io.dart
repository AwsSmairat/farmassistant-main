import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<Uint8List?> loadAvatarBytes(String uid) async {
  final f = await _fileForUid(uid);
  if (!await f.exists()) return null;
  return f.readAsBytes();
}

Future<Uint8List?> persistAvatarPick(
  String uid, {
  String? path,
  Uint8List? bytes,
}) async {
  final dest = await _fileForUid(uid);
  if (path != null && path.isNotEmpty) {
    final src = File(path);
    if (await src.exists()) {
      await src.copy(dest.path);
      return dest.readAsBytes();
    }
  }
  if (bytes != null && bytes.isNotEmpty) {
    await dest.writeAsBytes(bytes, flush: true);
    return bytes;
  }
  return null;
}

Future<File> _fileForUid(String uid) async {
  final dir = await getApplicationDocumentsDirectory();
  final safe = uid.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  return File('${dir.path}/profile_avatar_$safe');
}
