import 'package:pass_emploi_app/features/alerte/create/alerte_create_middleware.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_repository.dart';
import 'package:redux/redux.dart';

class ImmersionAlerteCreateMiddleware extends AlerteCreateMiddleware<ImmersionAlerte> {
  ImmersionAlerteCreateMiddleware(AlerteRepository<ImmersionAlerte> repository) : super(repository);

  @override
  AlerteCreateState<ImmersionAlerte> getAlerteCreateState(Store<AppState> store) {
    return store.state.immersionAlerteCreateState;
  }

  @override
  ImmersionAlerte copyWithTitle(ImmersionAlerte t, String title) => t.copyWithTitle(title);
}
