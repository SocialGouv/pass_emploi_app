import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

class MonSuiviRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  MonSuiviRepository(this._httpClient, [this._crashlytics]);

  Future<MonSuivi?> getMonSuivi({required String userId, required DateTime debut, required DateTime fin}) async {
    final url = "/jeunes/todo";
    try {
      final response = await _httpClient.get(url);
      return null;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
