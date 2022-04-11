import 'package:intl/date_symbol_data_local.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class BootstrapMiddleware extends MiddlewareClass<AppState> {
  bool isInitialized = false;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction && !isInitialized) {
      await initializeDateFormatting();
      isInitialized = true;
    }
  }
}
