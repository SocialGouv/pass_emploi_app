import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/network/post_campagne_results.dart';

class CampagneRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  CampagneRepository(this._httpClient, [this._crashlytics]);

  Future<void> postAnswers(String userId, String campagneId, List<CampagneQuestionAnswer> updatedAnswers) async {
    final url = "/jeunes/$userId/campagnes/$campagneId/evaluer";
    final answers = updatedAnswers.map((e) => PostCampagneResults(answer: e)).toList();
    final result = jsonEncode(answers);
    try {
      await _httpClient.post(url, data: result);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
  }
}
