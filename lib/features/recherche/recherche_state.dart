import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_externe.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

typedef RechercheEmploiState = RechercheState<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi>;
typedef RechercheImmersionState = RechercheState<ImmersionCriteresRecherche, ImmersionFiltresRecherche, Immersion>;
typedef RechercheServiceCiviqueState
    = RechercheState<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique>;
typedef RechercheEvenementsExternesState
    = RechercheState<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche, EvenementExterne>;

enum RechercheStatus {
  nouvelleRecherche,
  initialLoading,
  updateLoading,
  failure,
  success;
}

class RechercheState<Criteres extends Equatable, Filtres extends Equatable, Result extends Equatable>
    extends Equatable {
  final RechercheStatus status;
  final RechercheRequest<Criteres, Filtres>? request;
  final List<Result>? results;
  final bool canLoadMore;

  RechercheState({
    required this.status,
    required this.request,
    required this.results,
    required this.canLoadMore,
  });

  factory RechercheState.initial() {
    return RechercheState(
      status: RechercheStatus.nouvelleRecherche,
      request: null,
      results: null,
      canLoadMore: false,
    );
  }

  RechercheState<Criteres, Filtres, Result> copyWith({
    RechercheStatus? status,
    RechercheRequest<Criteres, Filtres>? Function()? request,
    List<Result>? Function()? results,
    bool? canLoadMore,
  }) {
    return RechercheState(
      status: status ?? this.status,
      request: request != null ? request() : this.request,
      results: results != null ? results() : this.results,
      canLoadMore: canLoadMore ?? this.canLoadMore,
    );
  }

  @override
  List<Object?> get props => [status, request, results, canLoadMore];
}
