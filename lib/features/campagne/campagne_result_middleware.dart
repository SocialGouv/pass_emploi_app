import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/campagne/campagne_result_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action_PE/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:redux/redux.dart';

class CampagneResultMiddleware extends MiddlewareClass<AppState> {
  final CampagneRepository _repository;

  CampagneResultMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loggedIn = store.state.loginState;
    if (loggedIn is LoginSuccessState && action is CampagneResultAction) {
      final campagneId = store.campagne()?.id;
      if (campagneId != null) {
        final answers = store.state.campagneResultState.answers;
        final currentAnswer = CampagneQuestionAnswer(action.idQuestion, action.idAnswer, action.pourquoi);
        // TODO-636: et si c'est la même question avec une autre réponse ??? Replace au lieu de add
        final updatedAnswers = answers..add(currentAnswer);
        store.dispatch(CampagneUpdateAnswersAction(updatedAnswers));
        _repository.postAnswers(loggedIn.user.id, campagneId, updatedAnswers);
      }
    }
  }
}

extension _Campagne on Store<AppState> {
  Campagne? campagne() {
    final loginState = state.loginState;
    if (loginState is! LoginSuccessState) return null;

    if (loginState.user.loginMode.isPe()) {
      final actionsState = state.userActionPEListState;
      if (actionsState is! UserActionPEListSuccessState) return null;
      // TODO-636 WTF???
      return (actionsState as UserActionPEListSuccessState).campagne;
    } else {
      final actionsState = state.userActionListState;
      if (actionsState is! UserActionListSuccessState) return null;
      return actionsState.campagne;
    }
  }
}
