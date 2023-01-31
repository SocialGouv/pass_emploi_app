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
      _rechercher(store: store, userId: userId, request: newRequest);
      //TODO: il faut concaténer les anciens Result avec les nouveaux Result
    }
  }

  void _rechercher({
    required Store<AppState> store,
    required String userId,
    required RechercheRequest<Criteres, Filtres> request,
  }) async {
    final response = await _repository.rechercher(userId: userId, request: request);
    if (response != null) {
      store.dispatch(RechercheSuccessAction(response.results, response.canLoadMore));
    } else {
      store.dispatch(RechercheFailureAction());
    }
  }

  //TODO: pour l'instant c'est en dur ici, mais ça sera à passer en abstract et donc avoir 4 petits middleware
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
