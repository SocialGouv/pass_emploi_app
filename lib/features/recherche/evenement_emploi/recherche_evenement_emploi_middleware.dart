import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';

class RechercheEvenementEmploiMiddleware extends RechercheMiddleware<EvenementEmploiCriteresRecherche,
    EvenementEmploiFiltresRecherche, EvenementEmploi> {
  final EvenementEmploiRepository _repository;

  RechercheEvenementEmploiMiddleware(this._repository);

  @override
  RechercheState<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche, EvenementEmploi>
      getRechercheState(
    AppState state,
  ) {
    return state.rechercheEvenementEmploiState;
  }

  @override
  RechercheRepository<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche, EvenementEmploi>
      getRepository() {
    return _repository;
  }
}
