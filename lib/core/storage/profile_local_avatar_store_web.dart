import 'dart:typed_data';

/// In-memory avatar cache for web (paths from file picker are usually unavailable).
final Map<String, Uint8List> _avatarMemory = {};

Future<Uint8List?> loadAvatarBytes(String uid) async => _avatarMemory[uid];

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
