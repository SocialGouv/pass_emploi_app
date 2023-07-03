import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class ThematiquesDemarcheRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ThematiquesDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<List<ThematiqueDeDemarche>?> get() async {
    const url = "/referentiels/pole-emploi/thematiques-demarche";
    try {
      final response = await _httpClient.get(url);
      return response.asListOf(ThematiqueDeDemarche.fromJson);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
