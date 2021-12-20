import 'package:http/http.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class FirebaseAuthRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;

  FirebaseAuthRepository(
    this._baseUrl,
    this._httpClient,
    this._headersBuilder,
  );

  Future<String?> getFirebaseToken(String userId) async {
    final url = Uri.parse(_baseUrl + "/auth/firebase/token");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headersBuilder.headers(userId: userId, contentType: 'application/json'),
      );
      if (response.statusCode.isValid()) return jsonUtf8Decode(response.bodyBytes)["token"];
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
