import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:redux/redux.dart';

import '../../../redux/app_state.dart';
import '../../../repositories/service_civique/service_civique_repository.dart';

class ServiceCiviqueDetailMiddleware extends MiddlewareClass<AppState> {
  final ServiceCiviqueDetailRepository _repository;

  ServiceCiviqueDetailMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is GetServiceCiviqueDetailAction) {
      store.dispatch(ServiceCiviqueDetailLoadingAction());
      final response = await _repository.getServiceCiviqueDetail(action.id);
      if (response is FailedServiceCiviqueDetailResponse) {
        store.dispatch(ServiceCiviqueDetailFailureAction());
      } else if (response is SuccessfullServiceCiviqueDetailResponse) {
        store.dispatch(ServiceCiviqueDetailSuccessAction(response.detail));
      } else if (response is NotFoundServiceCiviqueDetailResponse) {
        _handleNotFound(store, action);
      }
    }
  }

  void _handleNotFound(Store<AppState> store, GetServiceCiviqueDetailAction action) {
    final FavoriListState<ServiceCivique> favorisState = store.state.serviceCiviqueFavorisState;
    if (favorisState is FavoriListLoadedState<ServiceCivique>) {
      if (favorisState.data?[action.id] != null) {
        store.dispatch(ServiceCiviqueDetailNotFoundAction(favorisState.data![action.id]!));
      } else {
        store.dispatch(ServiceCiviqueDetailFailureAction());
      }
    } else {
      store.dispatch(ServiceCiviqueDetailFailureAction());
    }
  }
}
