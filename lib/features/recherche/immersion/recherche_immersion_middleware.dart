import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';

class RechercheImmersionMiddleware
    extends RechercheMiddleware<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres, Immersion> {
  final ImmersionRepository _repository;

  RechercheImmersionMiddleware(this._repository);

  @override
  RechercheImmersionState getRechercheState(
    AppState state,
  ) {
    return state.rechercheImmersionState;
  }

  @override
  RechercheRepository<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres, Immersion> getRepository() {
    return _repository;
  }
}
