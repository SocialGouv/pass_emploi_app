import 'package:pass_emploi_app/features/alerte/create/alerte_create_middleware.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueAlerteCreateMiddleware extends AlerteCreateMiddleware<ServiceCiviqueAlerte> {
  ServiceCiviqueAlerteCreateMiddleware(super.repository);

  @override
  AlerteCreateState<ServiceCiviqueAlerte> getAlerteCreateState(Store<AppState> store) {
    return store.state.serviceCiviqueAlerteCreateState;
  }

  @override
  ServiceCiviqueAlerte copyWithTitle(ServiceCiviqueAlerte t, String title) => t.copyWithTitle(title);
}
