import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';

class ContactImmersionRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ContactImmersionRepository(this._httpClient, [this._crashlytics]);

  Future<bool?> post(ContactImmersionRequest request) async {
    // TODO: Faire la requête
    return null;

    //   final url = '/jeunes/$userId/offres-immersion/contact';
    //   try {
    //     await _httpClient.post(
    //       url,
    //       data: customJsonEncode(request),
    //     );
    //     return true;
    //   } catch (e, stack) {
    //     _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    //   }
    //   return null;
    // }
  }
}
