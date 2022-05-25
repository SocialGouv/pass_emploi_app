import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/utils/log.dart';

class CampagneRepository {
  Future<void> postAnswers(String userId, String campagneId, List<CampagneQuestionAnswer> updatedAnswers) async {
    Log.i('POST ANSWERS userId: $userId campagneId: $campagneId answers: $updatedAnswers');
  }
}
