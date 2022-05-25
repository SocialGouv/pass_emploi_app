import 'dart:convert';

import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/network/post_campagne_results.dart';
import 'package:pass_emploi_app/utils/log.dart';

class CampagneRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  CampagneRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<void> postAnswers(String userId, String campagneId, List<CampagneQuestionAnswer> updatedAnswers) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/campagnes/$campagneId/evaluer");
    final answers = updatedAnswers.map((e) => PostCampagneResults(answer: e)).toList();
    final result = jsonEncode(answers);
    Log.i('POST ANSWERS results: $result');
    try {
      // await _httpClient.post(url, body: result);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
  }
}
