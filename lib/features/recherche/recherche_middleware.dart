import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RechercheMiddleware<Criteres extends Equatable, Filtres extends Equatable, Result>
    extends MiddlewareClass<AppState> {
  final RechercheRepository<Criteres, Filtres, Result> _repository;

  RechercheMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is RechercheRequestAction<Criteres, Filtres>) {
      _rechercher(store: store, userId: userId, request: action.request);
    } else if (action is RechercheUpdateFiltres<Filtres>) {
      final newRequest = copyRequestWith(state: store.state, filtres: action.filtres);
      _rechercher(store: store, userId: userId, request: newRequest);
    } else if (action is RechercheLoadMoreAction<Result>) {
      final newRequest = copyRequestWith(state: store.state, newPage: (page) => page + 1);
      _rechercher(store: store, userId: userId, request: newRequest, previousResults: _previousResults(store.state));
    }
  }

  void _rechercher({
    required Store<AppState> store,
    required String userId,
    required RechercheRequest<Criteres, Filtres> request,
    List<Result> previousResults = const [],
  }) async {
    final response = await _repository.rechercher(userId: userId, request: request);
    if (response != null) {
      final results = previousResults.isEmpty ? response.results : previousResults + response.results;
      store.dispatch(RechercheSuccessAction(request, results, response.canLoadMore));
    } else {
      store.dispatch(RechercheFailureAction<Result>());
    }
  }

  //TODO: pour l'instant copyRequestWith() et _previousResults() sont en dur ici.
  // Plus tard, on passe la classe en abstract, ces méthodes aussi.

  RechercheRequest<Criteres, Filtres> copyRequestWith({
    required AppState state,
    Filtres? filtres,
    int Function(int)? newPage,
  }) {
    final oldRequest = state.rechercheEmploiState.request!;
    return oldRequest.copyWith(
      filtres: filtres == null ? null : filtres as OffreEmploiSearchParametersFiltres,
      page: newPage == null ? null : newPage(oldRequest.page),
    ) as RechercheRequest<Criteres, Filtres>;
  }

  List<Result> _previousResults(AppState state) => state.rechercheEmploiState.results as List<Result>;
}

abstract class RechercheRepository<Criteres extends Equatable, Filtres extends Equatable, Result> {
  Future<RechercheResponse<Result>?> rechercher(
      {required String userId, required RechercheRequest<Criteres, Filtres> request});
}

class RechercheResponse<Result> {
  final List<Result> results;
  final bool canLoadMore;

  RechercheResponse({
    required this.results,
    required this.canLoadMore,
  });
}
