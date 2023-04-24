import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension StoreDeeplinks on Store<AppState> {
  void dispatchAgendaDeeplink() => dispatch(LocalDeeplinkAction({"type": "AGENDA"}));
  void dispatchFavorisDeeplink() => dispatch(LocalDeeplinkAction({"type": "FAVORIS"}));
  void dispatchSavedSearchesDeeplink() => dispatch(LocalDeeplinkAction({"type": "SAVED_SEARCHES"}));
  void dispatchRechercheDeeplink() => dispatch(LocalDeeplinkAction({"type": "RECHERCHE"}));
  void dispatchOutilsDeeplink() => dispatch(LocalDeeplinkAction({"type": "OUTILS"}));
  void dispatchEventListDeeplink() => dispatch(LocalDeeplinkAction({"type": "EVENT_LIST"}));
}
