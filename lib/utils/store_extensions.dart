import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension StoreDeeplinks on Store<AppState> {
  void dispatchAgendaDeeplink() {
    dispatch(LocalDeeplinkAction({"type": "AGENDA"}));
  }
}
