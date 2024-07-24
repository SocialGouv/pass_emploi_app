import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';

class DetailsJeuneRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  DetailsJeuneRepository(this._httpClient, [this._crashlytics]);

  Future<DetailsJeune?> get(String userId) async {
    final url = "/jeunes/$userId";
    try {
      final response = await _httpClient.get(url);
      return DetailsJeune.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
