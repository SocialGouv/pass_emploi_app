import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class SearchDemarcheRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  SearchDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<List<DemarcheDuReferentiel>?> search(String query) async {
    const url = '/referentiels/pole-emploi/types-demarches';
    try {
      final response = await _httpClient.get(url, queryParameters: {'recherche': query});
      return response.asListOf(DemarcheDuReferentiel.fromJson);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
