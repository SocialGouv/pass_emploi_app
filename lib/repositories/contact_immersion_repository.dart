import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_immersion_request.dart';

enum ContactImmersionResponse {
  success,
  failure,
  alreadyDone,
}

class ContactImmersionRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ContactImmersionRepository(this._httpClient, [this._crashlytics]);

  Future<ContactImmersionResponse> post(String userId, ContactImmersionRequest request) async {
    final url = '/jeunes/$userId/offres-immersion/contact';
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(PostContactImmersionRequest(request)),
      );
      return ContactImmersionResponse.success;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
      if (e is DioException && e.response?.statusCode == 409) {
        return ContactImmersionResponse.alreadyDone;
      }
    }
    return ContactImmersionResponse.failure;
  }
}
