import 'package:pass_emploi_app/features/alerte/create/alerte_create_middleware.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class OffreEmploiAlerteCreateMiddleware extends AlerteCreateMiddleware<OffreEmploiAlerte> {
  OffreEmploiAlerteCreateMiddleware(super.repository);

  @override
  AlerteCreateState<OffreEmploiAlerte> getAlerteCreateState(Store<AppState> store) {
    return store.state.offreEmploiAlerteCreateState;
  }

  @override
  OffreEmploiAlerte copyWithTitle(OffreEmploiAlerte t, String title) => t.copyWithTitle(title);
}
