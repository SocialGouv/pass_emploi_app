import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class QuestionPageViewModel {
  final String titre = "Votre expérience 1/2";
  final String? information = "Les questions marquées d'une * sont obligatoires";
  final String question = "Aimez-vous Perceval ?";
  final List<String> options = ["Ouais c'est pas faux"];

  final int? answerSelectedIndex = null;
  final String? pourquoiAnswer = null;

  final QuestionBottomButton bottomButton = QuestionBottomButton.next;

  QuestionPageViewModel(Store<AppState> store, int pageOffset);
}

enum QuestionBottomButton { next, validate }

class ReponsesCampagneState {}
