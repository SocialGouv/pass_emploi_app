import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class ThematiqueDemarcheRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ThematiqueDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<List<ThematiqueDeDemarche>?> getThematique() async {
    const url = "/referentiels/pole-emploi/catalogue";
    try {
      final response = await _httpClient.get(url);
      return response.asListOf(ThematiqueDeDemarche.fromJson);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
