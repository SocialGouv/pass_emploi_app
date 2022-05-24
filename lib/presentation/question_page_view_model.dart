import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class QuestionPageViewModel {
  final String titre = "Votre expérience 1/2";
  final String? information = "Les questions marquées d'une * sont obligatoires";
  final String question = "Est-ce c'est super la vie ?";
  final List<String> options = ["Non", "Oui", "Peut-être"];

  final int? answerSelectedIndex = null;
  final String? pourquoiAnswer = null;

  final QuestionBottomButton bottomButton = QuestionBottomButton.next;

  QuestionPageViewModel({
    required Store<AppState> store,
    required int pageOffset,
  });
}

enum QuestionBottomButton { next, validate }

class ReponsesCampagneState {}
