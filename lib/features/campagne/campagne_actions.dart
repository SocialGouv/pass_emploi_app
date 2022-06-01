import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';

class CampagneFetchedAction {
  final Campagne? campagne;

  CampagneFetchedAction(this.campagne);
}

class CampagneAnswerAction {
  final int idQuestion;
  final int idAnswer;
  final String? pourquoi;

  CampagneAnswerAction(this.idQuestion, this.idAnswer, this.pourquoi);
}

class CampagneUpdateAnswersAction {
  final List<CampagneQuestionAnswer> updatedAnswers;

  CampagneUpdateAnswersAction(this.updatedAnswers);
}

class CampagneResetAction {}
