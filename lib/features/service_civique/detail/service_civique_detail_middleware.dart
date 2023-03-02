import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:redux/redux.dart';

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
    final favorisState = store.state.favoriListState;
    if (favorisState is FavoriListSuccessState && favorisState.results.any((element) => element.id == action.id)) {
      final favori = favorisState.results.firstWhere((element) => element.id == action.id);
      store.dispatch(ServiceCiviqueDetailNotFoundAction(favori.toServiceCivique));
    } else {
      store.dispatch(ServiceCiviqueDetailFailureAction());
    }
  }
}
