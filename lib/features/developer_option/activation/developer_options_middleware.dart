import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DeveloperOptionsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    final flavor = store.state.configurationState.getFlavor();
    if (action is DeveloperOptionsActivationRequestAction && flavor == Flavor.STAGING) {
      store.dispatch(DeveloperOptionsActivationSuccessAction());
    }
  }
}
