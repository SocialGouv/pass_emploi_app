import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

typedef RechercheEmploiState = RechercheState<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres, OffreEmploi>;

enum RechercheStatus {
  nouvelleRecherche,
  initialLoading,
  updateLoading,
  failure,
  success;
}

class RechercheRequest<Criteres extends Equatable, Filtres extends Equatable> extends Equatable {
  final Criteres criteres;
  final Filtres filtres;
  final int page;

  RechercheRequest(this.criteres, this.filtres, this.page);

  RechercheRequest<Criteres, Filtres> copyWith({
    Criteres? criteres,
    Filtres? filtres,
    int? page,
  }) {
    return RechercheRequest(criteres ?? this.criteres, filtres ?? this.filtres, page ?? this.page);
  }

  @override
  List<Object?> get props => [criteres, filtres, page];
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
