import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

class RechercheEmploiMiddleware
    extends RechercheMiddleware<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres, OffreEmploi> {
  final OffreEmploiRepository _repository;

  RechercheEmploiMiddleware(this._repository);

  @override
  RechercheState<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres, OffreEmploi> getRechercheState(
    AppState state,
  ) {
    return state.rechercheEmploiState;
  }

  @override
  RechercheRepository<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres, OffreEmploi> getRepository() {
    return _repository;
  }
}
