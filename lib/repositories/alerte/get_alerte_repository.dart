import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_json_extractor.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_response.dart';

class GetAlerteRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  GetAlerteRepository(this._httpClient, [this._crashlytics]);

  static String getAlerteUrl({required String userId}) => '/jeunes/$userId/recherches';

  Future<List<Alerte>?> getAlerte(String userId) async {
    final url = getAlerteUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);
      final list = (response.data as List).map((search) => AlerteResponse.fromJson(search)).toList();
      return list.map((e) => AlerteJsonExtractor().extract(e)).whereType<Alerte>().toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
