import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/init/alerte_initialize_action.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/alerte/alerte_extractors.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AlerteInitializeMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    final loginState = store.state.loginState;
    if (action is SaveSearchInitializeAction<OffreEmploiAlerte> && loginState is LoginSuccessState) {
      final OffreEmploiAlerte search = OffreEmploiSearchExtractor().getSearchFilters(store);
      store.dispatch(AlerteCreateInitializeAction<OffreEmploiAlerte>(search));
    } else if (action is SaveSearchInitializeAction<ImmersionAlerte> && loginState is LoginSuccessState) {
      final ImmersionAlerte search = ImmersionSearchExtractor().getSearchFilters(store);
      store.dispatch(AlerteCreateInitializeAction<ImmersionAlerte>(search));
    } else if (action is SaveSearchInitializeAction<ServiceCiviqueAlerte> && loginState is LoginSuccessState) {
      final ServiceCiviqueAlerte search = ServiceCiviqueSearchExtractor().getSearchFilters(store);
      store.dispatch(AlerteCreateInitializeAction<ServiceCiviqueAlerte>(search));
    }
  }
}
