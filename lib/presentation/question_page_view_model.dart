import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/campagne/campagne_result_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
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
    final campagne = store.campagne()!; // todo que faire si null, qui ne doit pas arriver ?

    return QuestionPageViewModel(
      idQuestion: campagne.questions[pageOffset].id,
      titre: Strings.campagneTitle(pageOffset + 1, campagne.questions.length),
      information: pageOffset.information(),
      question: campagne.questions[pageOffset].libelle,
      options: campagne.questions[pageOffset].options,
      bottomButton: pageOffset.isLastPage(campagne) ? QuestionBottomButton.validate : QuestionBottomButton.next,
      onButtonClick: (idQuestion, idAnswer, pourquoi) => store.dispatch(
        CampagneResultAction(
          idQuestion,
          idAnswer,
          pourquoi,
        ),
      ),
    );
  }
}

enum QuestionBottomButton { next, validate }

extension _Offset on int {
  bool isLastPage(Campagne campagne) => this == (campagne.questions.length - 1);

  String? information() => this == 0 ? "Les questions marquées d'une * sont obligatoires" : null;
}

extension _Campagne on Store<AppState> {
  Campagne? campagne() {
    final loginState = state.loginState;
    if (loginState is! LoginSuccessState) return null;

    if (loginState.user.loginMode.isPe()) {
      final actionsState = state.userActionPEListState;
      if (actionsState is! UserActionPEListSuccessState) return null;
      return actionsState.campagne;
    } else {
      final actionsState = state.userActionListState;
      if (actionsState is! UserActionListSuccessState) return null;
      return actionsState.campagne;
    }
  }
}
