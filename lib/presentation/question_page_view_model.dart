import 'package:pass_emploi_app/features/campagne/result/campagne_result_actions.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class QuestionPageViewModel {
  final int idQuestion;
  final String titre;
  final String? information;
  final String question;
  final List<Option> options;
  final Function(int idQuestion, int idAnswer, String? pourquoi) onButtonClick;

  final QuestionBottomButton bottomButton;

  QuestionPageViewModel({
    required this.idQuestion,
    required this.titre,
    required this.information,
    required this.question,
    required this.options,
    required this.bottomButton,
    required this.onButtonClick,
  });

  factory QuestionPageViewModel.create(Store<AppState> store, int pageOffset) {
    final campagne = store.state.campagneState.campagne;
    if (campagne == null) return dummyCampagne();

    return QuestionPageViewModel(
      idQuestion: campagne.questions[pageOffset].id,
      titre: Strings.campagneTitle(pageOffset + 1, campagne.questions.length),
      information: pageOffset.information(),
      question: campagne.questions[pageOffset].libelle,
      options: campagne.questions[pageOffset].options,
      bottomButton: pageOffset.isLastPage(campagne) ? QuestionBottomButton.validate : QuestionBottomButton.next,
      onButtonClick: (idQuestion, idAnswer, pourquoi) {
        store.dispatch(CampagneResultAction(idQuestion, idAnswer, pourquoi));
        if (pageOffset.isLastPage(campagne)) {
          store.dispatch(CampagneResetAction());
        }
      },
    );
  }

  static QuestionPageViewModel dummyCampagne() {
    return QuestionPageViewModel(
      idQuestion: 0,
      titre: '',
      information: null,
      question: '',
      options: [],
      bottomButton: QuestionBottomButton.validate,
      onButtonClick: (idQuestion, idAnswer, pourquoi) {},
    );
  }
}

enum QuestionBottomButton { next, validate }

extension _Offset on int {
  bool isLastPage(Campagne campagne) => this == (campagne.questions.length - 1);

  String? information() => this == 0 ? "Les questions marquées d'une * sont obligatoires" : null;
}
