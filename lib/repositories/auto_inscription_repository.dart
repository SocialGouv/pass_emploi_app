import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class AutoInscriptionRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  AutoInscriptionRepository(this._httpClient, [this._crashlytics]);

  Future<AutoInscriptionResult> inscrire(String userId, String eventId) async {
    final url = "/jeunes/milo/$userId/sessions/$eventId/inscrire";
    try {
      await _httpClient.post(url);
      return AutoInscriptionSuccess();
    } catch (e, stack) {
      if (e is DioException && e.response?.data?["code"] == "NOMBRE_PLACE_INSUFFISANT") {
        return AutoInscriptionNombrePlacesInsuffisantes();
      }

      if (e is DioException && e.response?.statusCode == 422) {
        return AutoInscriptionConseillerInactif();
      }

      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return AutoInscriptionGenericError();
  }
}

sealed class AutoInscriptionResult {
  bool get isSuccess => this is AutoInscriptionSuccess;
}

class AutoInscriptionSuccess extends AutoInscriptionResult {}

sealed class AutoInscriptionError extends AutoInscriptionResult {}

class AutoInscriptionNombrePlacesInsuffisantes extends AutoInscriptionError {}

class AutoInscriptionConseillerInactif extends AutoInscriptionError {}

class AutoInscriptionGenericError extends AutoInscriptionError {}
