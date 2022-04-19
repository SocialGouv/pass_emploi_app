import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class FirebaseAuthRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  FirebaseAuthRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<FirebaseAuthResponse?> getFirebaseAuth(String userId) async {
    final url = Uri.parse(_baseUrl + "/auth/firebase/token");
    try {
      final response = await _httpClient.post(url);
      if (response.statusCode.isValid()) {
        return FirebaseAuthResponse(
          jsonUtf8Decode(response.bodyBytes)["token"] as String,
          jsonUtf8Decode(response.bodyBytes)["cle"] as String,
        );
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}

class FirebaseAuthResponse extends Equatable {
  final String token;
  final String key;

  FirebaseAuthResponse(this.token, this.key);

  @override
  List<Object> get props => [token, key];
}
