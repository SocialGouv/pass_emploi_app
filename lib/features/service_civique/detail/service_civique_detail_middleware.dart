import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:redux/redux.dart';

import '../../../redux/states/app_state.dart';
import '../../../repositories/service_civique/service_civique_repository.dart';

class ServiceCiviqueDetailMiddleware extends MiddlewareClass<AppState> {
  final ServiceCiviqueDetailRepository _repository;

  ServiceCiviqueDetailMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is GetServiceCiviqueDetailAction) {
      store.dispatch(ServiceCiviqueDetailLoadingAction());
      final detail = await _repository.getServiceCiviqueDetail(action.id);
      store.dispatch(detail == null ? ServiceCiviqueDetailFailureAction() : ServiceCiviqueDetailSuccessAction(detail));
    }
  }
}
