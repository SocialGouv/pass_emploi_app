import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:redux/redux.dart';

class CampagneMiddleware extends MiddlewareClass<AppState> {
  final CampagneRepository _repository;

  CampagneMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loggedIn = store.state.loginState;
    if (loggedIn is LoginSuccessState && action is CampagneAnswerAction) {
      final campagneId = store.state.campagneState.campagne?.id;
      if (campagneId != null) {
        final updatedAnswers = _updatedAnswers(
          store.state.campagneState.answers,
          CampagneQuestionAnswer(action.idQuestion, action.idAnswer, action.pourquoi),
        );
        store.dispatch(CampagneUpdateAnswersAction(updatedAnswers));
        _repository.postAnswers(loggedIn.user.id, campagneId, updatedAnswers);
      }
    }
  }

  List<CampagneQuestionAnswer> _updatedAnswers(
    List<CampagneQuestionAnswer> currentAnswers,
    CampagneQuestionAnswer newAnswer,
  ) {
    currentAnswers.removeWhere((element) => element.idQuestion == newAnswer.idQuestion);
    return currentAnswers..add(newAnswer);
  }
}
