import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

typedef RechercheEmploiState = RechercheState<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres, OffreEmploi>;
typedef RechercheServiceCiviqueState
    = RechercheState<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique>;

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
