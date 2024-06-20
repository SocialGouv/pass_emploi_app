import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';

class EvenementEngagementRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  EvenementEngagementRepository(this._httpClient, [this._crashlytics]);

  Future<bool> send({
    required User user,
    required EvenementEngagement event,
  }) async {
    const url = "/evenements";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(PostEvenementEngagement(user: user, event: event)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
