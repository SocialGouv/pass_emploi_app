import 'package:pass_emploi_app/features/cgu/cgu_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:redux/redux.dart';

class CguMiddleware extends MiddlewareClass<AppState> {
  final DetailsJeuneRepository _detailsJeuneRepository;
  final RemoteConfigRepository _remoteConfigRepository;

  CguMiddleware(this._detailsJeuneRepository, this._remoteConfigRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is! LoginSuccessAction) return;

    final detailsJeune = await _detailsJeuneRepository.get(action.user.id);
    if (detailsJeune == null) return;

    final cgu = _remoteConfigRepository.getCgu();
    if (cgu == null) return;

    final dateSignatureCgu = detailsJeune.dateSignatureCgu;
    if (dateSignatureCgu == null) {
      store.dispatch(CguNeverAcceptedAction());
    } else if (dateSignatureCgu.isAfter(cgu.lastUpdate)) {
      store.dispatch(CguAlreadyAcceptedAction());
    } else {
      store.dispatch(CguUpdateRequiredAction(cgu));
    }
  }
}
