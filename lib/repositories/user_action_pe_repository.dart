import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';

class UserActionPERepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  UserActionPERepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<List<UserActionPE>?> getUserActions(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/pole-emploi/actions");
    // have to wait to get PE token
    if (PoleEmploiTokenRepository().getPoleEmploiAccessToken() == null) {
      await Future.delayed(Duration(seconds: 2));
    }
      try {
        final response = await _httpClient.get(
          url,
          headers: await _headerBuilder.headers(userId: userId),
        );
        if (response.statusCode.isValid()) {
          final json = jsonUtf8Decode(response.bodyBytes);
          return (json as List).map((action) => UserActionPE.fromJson(action)).toList();
        }
      } catch (e, stack) {
        _crashlytics?.recordNonNetworkException(e, stack, url);
      }
      return null;
    }
}
