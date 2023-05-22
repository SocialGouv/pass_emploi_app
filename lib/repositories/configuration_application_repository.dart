import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/put_configuration_application.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';

class ConfigurationApplicationRepository {
  final String _baseUrl;
  final Client _httpClient;
  final FirebaseInstanceIdGetter _firebaseInstanceIdGetter;

  final PushNotificationManager _pushNotificationManager;
  final Crashlytics? _crashlytics;

  ConfigurationApplicationRepository(
    this._baseUrl,
    this._httpClient,
    this._firebaseInstanceIdGetter,
    this._pushNotificationManager, [
    this._crashlytics,
  ]);

  Future<void> configureApplication(String userId, String fuseauHoraire) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/configuration-application");

    try {
      final token = await _pushNotificationManager.getToken();
      if (token == null) return;

      final firebaseInstanceId = await _firebaseInstanceIdGetter.getFirebaseInstanceId();

      await _httpClient.put(
        url,
        headers: {'X-InstanceId': firebaseInstanceId},
        body: customJsonEncode(PutConfigurationApplication(
          token: token,
          fuseauHoraire: fuseauHoraire,
        )),
      );
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
  }
}

class FirebaseInstanceIdGetter {
  String? _firebaseInstanceId;

  Future<String> getFirebaseInstanceId() async {
    final firebaseInstanceIdCopy = _firebaseInstanceId;
    if (firebaseInstanceIdCopy != null) return firebaseInstanceIdCopy;

    final firebaseInstanceId = await FirebaseInstallations.instance.getId();
    _firebaseInstanceId = firebaseInstanceId;
    return firebaseInstanceId;
  }
}
