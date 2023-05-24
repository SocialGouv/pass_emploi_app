import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/evenement_externe.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/evenements_externes_repository.dart';

class RechercheEvenementsExternesMiddleware extends RechercheMiddleware<EvenementsExternesCriteresRecherche,
    EvenementsExternesFiltresRecherche, EvenementExterne> {
  final EvenementsExternesRepository _repository;

  RechercheEvenementsExternesMiddleware(this._repository);

  @override
  RechercheState<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche, EvenementExterne>
      getRechercheState(
    AppState state,
  ) {
    return state.rechercheEvenementsExternesState;
  }

  @override
  RechercheRepository<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche, EvenementExterne>
      getRepository() {
    return _repository;
  }
}
