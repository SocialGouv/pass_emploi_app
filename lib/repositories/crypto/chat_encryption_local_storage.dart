import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// FlutterSecureStorage ne garantit pas la sécurité des données sur iOS et Android.
/// C'est pourquoi nous préférons chiffrer les données pour ne pas les stocker en clair.
class ChatEncryptionLocalStorage {
  ChatEncryptionLocalStorage({required this.storage}) {
    _encrypter = Encrypter(AES(Key.fromLength(32)));
  }
  final FlutterSecureStorage storage;
  late final Encrypter _encrypter;

  static const String path = "chat_encryption";

  Future<void> saveChatEncryptionKey(String chatEncryptionKey, String vector) async {
    final encrypted = _encrypter.encrypt(chatEncryptionKey, iv: IV.fromUtf8(vector));
    await storage.write(key: path, value: encrypted.base64);
  }

  Future<String> getChatEncryptionKey(String vector) async {
    final encrypted = await storage.read(key: path);
    if (encrypted == null) {
      return "";
    }
    return _encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: IV.fromUtf8(vector));
  }
}
