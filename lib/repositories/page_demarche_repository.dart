import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';

class PageDemarcheRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  PageDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<PageDemarches?> getPageDemarches(String userId) async {
    final url = "/v2/jeunes/$userId/home/demarches";
    try {
      final response = await _httpClient.get(url);
      return PageDemarches.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
