import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class CreateDemarcheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  CreateDemarcheRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<bool> createDemarche(String commentaire, DateTime dateEcheance, String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/demarches");
    try {
      final response = await _httpClient.post(
        url,
        body: {"description": commentaire, "dateFin": dateEcheance.toIso8601String()},
      );
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
