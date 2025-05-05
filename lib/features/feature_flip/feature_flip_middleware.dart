import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/backend_config_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:redux/redux.dart';

class FeatureFlipMiddleware extends MiddlewareClass<AppState> {
  final RemoteConfigRepository _remoteConfigRepository;
  final BackendConfigRepository _backendConfigRepository;
  final DetailsJeuneRepository _detailsJeuneRepository;

  FeatureFlipMiddleware(
    this._remoteConfigRepository,
    this._backendConfigRepository,
    this._detailsJeuneRepository,
  );

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoginSuccessAction) {
      if (action.user.loginMode.isPe()) {
        _handleCvmFeatureFlip(store, action.user.id);
      }
    }
  }

  Future<void> _handleCvmFeatureFlip(Store<AppState> store, String userId) async {
    final cvmByAccompagnement = _remoteConfigRepository.cvmActivationByAccompagnement();
    if (cvmByAccompagnement[store.state.user()?.accompagnement] == true) {
      store.dispatch(FeatureFlipUseCvmAction(true));
    } else {
      final idsConseiller = await _backendConfigRepository.getIdsConseillerCvmEarlyAdopters();
      if (idsConseiller == null || idsConseiller.isEmpty) return;

      final jeune = await _detailsJeuneRepository.get(userId);
      if (idsConseiller.contains(jeune?.conseiller.id)) {
        store.dispatch(FeatureFlipUseCvmAction(true));
      }
    }
  }
}
