import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';

class IaFtSuggestionsRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  IaFtSuggestionsRepository(this._httpClient, [this._crashlytics]);

  Future<List<DemarcheIaSuggestion>?> get(String? query) async {
    const url = "/jeunes/todo";
    try {
      // final response = await _httpClient.get(url);
      await Future.delayed(const Duration(seconds: 2));
      return [
        DemarcheIaSuggestion(
          id: "1",
          content: "content",
          label: "label",
          titre: "titre",
          sousTitre: "sousTitre",
        ),
        DemarcheIaSuggestion(
          id: "2",
          content: "content",
          label: "label",
          titre: "titre",
          sousTitre: "sousTitre",
        ),
      ];
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
