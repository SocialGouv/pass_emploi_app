import 'package:encrypt/encrypt.dart';
import 'package:equatable/equatable.dart';

class ChatCrypto {
  final _encrypter;

  ChatCrypto(String key) : this._encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));

  EncryptedTextWithIv encrypt(String plainText) {
    final initializationVector = IV.fromSecureRandom(16);
    return EncryptedTextWithIv(
      initializationVector.base64,
      _encrypter.encrypt(plainText, iv: initializationVector).base64,
    );
  }

  String decrypt(EncryptedTextWithIv encrypted) {
    return _encrypter.decrypt(
      Encrypted.fromBase64(encrypted.base64Message),
      iv: IV.fromBase64(encrypted.base64InitializationVector),
    );
  }
}

class EncryptedTextWithIv extends Equatable {
  final String base64InitializationVector;
  final String base64Message;

  EncryptedTextWithIv(this.base64InitializationVector, this.base64Message);

  @override
  List<Object?> get props => [base64InitializationVector, base64Message];

  @override
  bool? get stringify => true;
}
