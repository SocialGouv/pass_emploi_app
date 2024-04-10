import 'package:encrypt/encrypt.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChatCrypto {
  Encrypter? _encrypter;
  Store<AppState>? _store;

  ChatCrypto();

  void setStore(Store<AppState> store) => _store = store;

  EncryptedTextWithIv encrypt(String plainText) {
    final initializationVector = IV.fromSecureRandom(16);
    return EncryptedTextWithIv(
      initializationVector.base64,
      _assertEncrypter().encrypt(plainText, iv: initializationVector).base64,
    );
  }

  EncryptedTextWithIv encryptWithIv(String plainText, String initializationVector) {
    final message = _assertEncrypter().encrypt(plainText, iv: IV.fromBase64(initializationVector)).base64;
    return EncryptedTextWithIv(initializationVector, message);
  }

  String decrypt(EncryptedTextWithIv encrypted) {
    return _assertEncrypter().decrypt(
      Encrypted.fromBase64(encrypted.base64Message),
      iv: IV.fromBase64(encrypted.base64InitializationVector),
    );
  }

  void setKey(String key) {
    _encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
  }

  bool isInitialized() {
    return _encrypter != null;
  }

  Encrypter _assertEncrypter() {
    if (_encrypter == null) {
      _store?.dispatch(TryConnectChatAgainAction());
      throw Exception("Trying to encrypt without a key.");
    }
    return _encrypter!;
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
