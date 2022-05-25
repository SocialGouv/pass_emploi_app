import 'package:pass_emploi_app/features/campagne/result/campagne_result_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
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
      final campagneId = store.state.campagneState.campagne?.id;
      if (campagneId != null) {
        final answers = store.state.campagneResultState.answers;
        final currentAnswer = CampagneQuestionAnswer(action.idQuestion, action.idAnswer, action.pourquoi);
        answers.removeWhere((element) => element.idQuestion == action.idQuestion);
        final updatedAnswers = answers..add(currentAnswer);
        store.dispatch(CampagneUpdateAnswersAction(updatedAnswers));
        _repository.postAnswers(loggedIn.user.id, campagneId, updatedAnswers);
      }
    }
  }
}
