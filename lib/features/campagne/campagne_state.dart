import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';

class CampagneState {
  final Campagne? campagne;
  final List<CampagneQuestionAnswer> answers;

  CampagneState(this.campagne, this.answers);
}
