import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class ThematiqueDemarcheRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;
  List<ThematiqueDeDemarche>? _cache;

  ThematiqueDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<List<ThematiqueDeDemarche>?> getThematique() async {
    if (_cache != null) return _cache;

    const url = "/referentiels/pole-emploi/catalogue-demarches";
    try {
      final response = await _httpClient.get(url);
      _cache = response.asListOf(ThematiqueDeDemarche.fromJson);
      return _cache;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
