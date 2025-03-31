import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';
import 'package:redux/redux.dart';

class ThematiqueDemarcheMiddleware extends MiddlewareClass<AppState> {
  final ThematiqueDemarcheRepository _repository;

  ThematiqueDemarcheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is ThematiqueDemarcheRequestAction &&
        store.state.thematiquesDemarcheState is! ThematiqueDemarcheSuccessState) {
      store.dispatch(ThematiqueDemarcheLoadingAction());
      final result = await _repository.getThematique();
      if (result != null) {
        store.dispatch(ThematiqueDemarcheSuccessAction(result));
      } else {
        store.dispatch(ThematiqueDemarcheFailureAction());
      }
    }
  }
}
