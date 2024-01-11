import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// FlutterSecureStorage ne garantit pas la sécurité des données sur iOS et Android.
/// C'est pourquoi nous préférons chiffrer les données pour ne pas les stocker en clair.
class ChatEncryptionLocalStorage {
  static const String _path = "chat_encryption_v2";
  static const int _keyLength = 32;
  static const int _ivLength = 16; // Required length for AES with key length of 32 bytes

  late final Encrypter _encrypter;
  final FlutterSecureStorage storage;

  ChatEncryptionLocalStorage({required this.storage}) {
    _encrypter = Encrypter(AES(Key.fromLength(_keyLength)));
  }

  Future<void> saveChatEncryptionKey(String chatEncryptionKey, String vector) async {
    final encrypted = _encrypter.encrypt(chatEncryptionKey, iv: _get16LengthIVFromInput(vector));
    await storage.write(key: _path, value: encrypted.base64);
  }

  Future<String> getChatEncryptionKey(String vector) async {
    final encrypted = await storage.read(key: _path);
    if (encrypted == null) return '';
    return _encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: _get16LengthIVFromInput(vector));
  }

  IV _get16LengthIVFromInput(String input) {
    if (input.length < _ivLength) return IV.fromUtf8(input.padRight(_ivLength, 'a'));
    if (input.length > _ivLength) return IV.fromUtf8(input.substring(0, _ivLength));
    return IV.fromUtf8(input);
  }
}
