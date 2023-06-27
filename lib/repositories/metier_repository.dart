import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class MetierRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  MetierRepository(this._httpClient, [this._crashlytics]);

  Future<List<Metier>> getMetiers(String userInput) async {
    if (userInput.length <= 2) return [];

    final url = "/referentiels/metiers?recherche=$userInput";
    try {
      final response = await _httpClient.get(url);
      return response.asListOf(Metier.fromJson);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return [];
  }
}
