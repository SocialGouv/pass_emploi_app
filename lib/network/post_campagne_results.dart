import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostCampagneResults implements JsonSerializable {
  final CampagneQuestionAnswer answer;

  PostCampagneResults({required this.answer});

  @override
  Map<String, dynamic> toJson() => {
    "idQuestion": answer.idQuestion,
    "idReponse": answer.idAnswer,
    "pourquoi": answer.pourquoi,
  };
}
