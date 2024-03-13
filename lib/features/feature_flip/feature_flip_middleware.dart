import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:redux/redux.dart';

class FeatureFlipMiddleware extends MiddlewareClass<AppState> {
  final RemoteConfigRepository _remoteConfigRepository;
  final DetailsJeuneRepository _detailsJeuneRepository;

  FeatureFlipMiddleware(this._remoteConfigRepository, this._detailsJeuneRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoginSuccessAction && action.user.loginMode.isPe()) {
      _handleCvmFeatureFlip(store, action.user.id);
    }
  }

  Future<void> _handleCvmFeatureFlip(Store<AppState> store, String userId) async {
    if (_remoteConfigRepository.useCvm()) {
      store.dispatch(FeatureFlipAction(useCvm: true));
    } else {
      final idsConseiller = _remoteConfigRepository.getIdsConseillerCvmEarlyAdopters();
      if (idsConseiller.isEmpty) return;

      final jeune = await _detailsJeuneRepository.fetch(userId);
      if (idsConseiller.contains(jeune?.conseiller.id)) {
        store.dispatch(FeatureFlipAction(useCvm: true));
      }
    }
  }
}
