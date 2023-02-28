import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

class RechercheEmploiMiddleware
    extends RechercheMiddleware<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> {
  final OffreEmploiRepository _repository;

  RechercheEmploiMiddleware(this._repository);

  @override
  RechercheState<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> getRechercheState(
    AppState state,
  ) {
    return state.rechercheEmploiState;
  }

  @override
  RechercheRepository<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> getRepository() {
    return _repository;
  }
}
