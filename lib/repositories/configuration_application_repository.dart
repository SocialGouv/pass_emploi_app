import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/put_configuration_application.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';

class ConfigurationApplicationRepository {
  final String _baseUrl;
  final Client _httpClient;

  final PushNotificationManager _pushNotificationManager;
  final Crashlytics? _crashlytics;

  ConfigurationApplicationRepository(
    this._baseUrl,
    this._httpClient,
    this._pushNotificationManager, [
    this._crashlytics,
  ]);

  Future<void> configureApplication(String userId, String fuseauHoraire) async {
    final token = await _pushNotificationManager.getToken();
    if (token != null) {
      final url = Uri.parse(_baseUrl + "/jeunes/$userId/configuration-application");
      try {
        await _httpClient.put(url,
            body: customJsonEncode(PutConfigurationApplication(
              token: token,
              fuseauHoraire: fuseauHoraire,
            )));
      } catch (e, stack) {
        _crashlytics?.recordNonNetworkException(e, stack, url);
      }
    }
  }
}
