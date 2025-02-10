import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/remote_campagne_accueil/remote_campagne_accueil_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/remote_campagne_accueil_repository.dart';
import 'package:redux/redux.dart';

class RemoteCampagneAccueilMiddleware extends MiddlewareClass<AppState> {
  final RemoteCampagneAccueilRepository _repository;

  RemoteCampagneAccueilMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is AccueilRequestAction) {
      final result = await _repository.getCampagnes();
      store.dispatch(RemoteCampagneAccueilSuccessAction(result));
    } else if (action is RemoteCampagneAccueilDismissAction) {
      await _repository.dismissCampagne(action.campagneId);
      store.dispatch(RemoteCampagneAccueilSuccessAction(store.state.remoteCampagneAccueilState.campagnes
          .where((campagne) => campagne.id != action.campagneId)
          .toList()));
    }
  }
}
