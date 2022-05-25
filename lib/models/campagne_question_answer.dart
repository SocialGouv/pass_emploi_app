import 'package:equatable/equatable.dart';

class CampagneQuestionAnswer extends Equatable {
  final int idQuestion;
  final int idAnswer;
  final String? pourquoi;

  CampagneQuestionAnswer(this.idQuestion, this.idAnswer, this.pourquoi);

  @override
  List<Object?> get props => [idQuestion, idAnswer, pourquoi];
}
