import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/put_register_token_request.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';

class RegisterTokenRepository {
  final String _baseUrl;
  final HeadersBuilder _headersBuilder;
  final PushNotificationManager _pushNotificationManager;

  RegisterTokenRepository(
    this._baseUrl,
    this._headersBuilder,
    this._pushNotificationManager,
  );

  Future<void> registerToken(String userId) async {
    final token = await _pushNotificationManager.getToken();
    if (token != null) {
      final url = Uri.parse(_baseUrl + "/jeunes/$userId/push-notification-token");
      try {
        var jsonBody = customJsonEncode(PutRegisterTokenRequest(token: token));
        await http.put(
          url,
          headers: await _headersBuilder.headers(userId: userId, contentType: 'application/json'),
          body: jsonBody,
        );
      } catch (e) {
        print('Exception on ${url.toString()}: ' + e.toString());
      }
    }
  }
}
