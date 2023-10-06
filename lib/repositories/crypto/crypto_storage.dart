import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CryptoStorage {
  CryptoStorage({required this.storage}) {
    _encrypter = Encrypter(AES(Key.fromLength(32)));
  }
  final FlutterSecureStorage storage;
  late final Encrypter _encrypter;

  static String storageKey = "secretKey";

  Future<void> saveKey(String secretKey, String userId) async {
    final encrypted = _encrypter.encrypt(secretKey, iv: IV.fromUtf8(userId));
    await storage.write(key: storageKey, value: encrypted.base64);
  }

  Future<String> getKey(String userId) async {
    final encrypted = await storage.read(key: storageKey);
    if (encrypted == null) {
      return "";
    }
    return _encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: IV.fromUtf8(userId));
  }
}
