import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class BackendConfigRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  BackendConfigRepository(this._httpClient, [this._crashlytics]);

  Future<List<String>?> getIdsConseillerCvmEarlyAdopters() async {
    const url = "/config";

    try {
      final response = await _httpClient.get(url);
      final ids = response.data["ids_conseiller_cvm_early_adopters"] as List?;
      return ids?.map((e) => e.toString()).toList() ?? [];
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
