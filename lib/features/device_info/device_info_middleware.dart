import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/device_info/device_info_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:redux/redux.dart';

class DeviceInfoMiddleware extends MiddlewareClass<AppState> {
  final InstallationIdRepository _repository;

  DeviceInfoMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      final uuid = await _repository.getInstallationId();
      store.dispatch(DeviceInfoSuccessAction(uuid));
    }
  }
}
