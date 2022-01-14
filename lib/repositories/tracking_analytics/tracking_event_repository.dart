import 'package:http/http.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class TrackingEventRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  TrackingEventRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  Future<bool> sendEvent({required String userId, required EventType event, required LoginMode loginMode}) async {
    final url = Uri.parse(_baseUrl + "/evenements");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headersBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PostTrackingEvent(event: event, loginMode: loginMode, userId: userId)),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
