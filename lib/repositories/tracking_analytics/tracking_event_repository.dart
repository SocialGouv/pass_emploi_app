import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';

class TrackingEventRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  TrackingEventRepository(this._httpClient, [this._crashlytics]);

  Future<bool> sendEvent({
    required String userId,
    required EventType event,
    required LoginMode loginMode,
    required Brand brand,
  }) async {
    const url = "/evenements";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(PostTrackingEvent(event: event, loginMode: loginMode, userId: userId, brand: brand)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
