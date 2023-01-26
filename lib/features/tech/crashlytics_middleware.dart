import 'package:pass_emploi_app/collection/last_in_first_out_queue.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:redux/redux.dart';

class CrashlyticsMiddleware extends MiddlewareClass<AppState> {
  static const _CAPACITY = 10;
  final _lastActions = LastInFirstOutQueue<String>(_CAPACITY);

  final Crashlytics crashlytics;
  final InstallationIdRepository _installationIdRepository;

  CrashlyticsMiddleware(this.crashlytics, this._installationIdRepository);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is LoginSuccessAction) crashlytics.setUserIdentifier(action.user.id);

    _lastActions.add(action.toString());
    crashlytics.setCustomKey("last_actions", _formatQueueForCrashlytics());
    crashlytics.setCustomKey("app_state", _formatStoreForCrashlytics(store));

    if (action is BootstrapAction) {
      final uuid = await _installationIdRepository.getInstallationId();
      crashlytics.setUserIdentifier(uuid);
      Log.i("Crashlytics setUserIdentifier: $uuid");
    }

    next(action);
  }

  String _formatQueueForCrashlytics() {
    return _lastActions
        .toList()
        .asMap()
        .entries
        .map((entry) => "#${_CAPACITY - entry.key}:${entry.value.replaceAll('Instance of ', '')}")
        .toList()
        .toString();
  }

  String _formatStoreForCrashlytics(Store<AppState> store) => store.state.toString().replaceAll('Instance of ', '');
}
