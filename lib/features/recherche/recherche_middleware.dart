import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class RechercheMiddleware<Criteres extends Equatable, Filtres extends Equatable, Result extends Equatable>
    extends MiddlewareClass<AppState> {
  RechercheRepository<Criteres, Filtres, Result> getRepository();

  RechercheState<Criteres, Filtres, Result> getRechercheState(AppState state);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is RechercheRequestAction<Criteres, Filtres>) {
      _rechercher(store: store, userId: userId, request: action.request);
    } else if (action is RechercheUpdateFiltresAction<Filtres>) {
      final newRequest = _copyRequestWith(state: store.state, filtres: action.filtres);
      _rechercher(store: store, userId: userId, request: newRequest);
    } else if (action is RechercheLoadMoreAction<Result>) {
      final newRequest = _copyRequestWith(state: store.state, newPage: (page) => page + 1);
      _rechercher(store: store, userId: userId, request: newRequest, previousResults: _previousResults(store.state));
    }
  }

  void _rechercher({
    required Store<AppState> store,
    required String userId,
    required RechercheRequest<Criteres, Filtres> request,
    List<Result> previousResults = const [],
  }) async {
    final response = await getRepository().rechercher(userId: userId, request: request);
    if (response != null) {
      final results = previousResults.isEmpty ? response.results : previousResults + response.results;
      store.dispatch(RechercheSuccessAction(request, results, response.canLoadMore));
    } else {
      store.dispatch(RechercheFailureAction<Result>());
    }
  }

  RechercheRequest<Criteres, Filtres> _copyRequestWith({
    required AppState state,
    Filtres? filtres,
    int Function(int)? newPage,
  }) {
    final oldRequest = getRechercheState(state).request!;
    return oldRequest.copyWith(
      filtres: filtres,
      page: newPage != null ? newPage(oldRequest.page) : null,
    );
  }

  List<Result> _previousResults(AppState state) => getRechercheState(state).results!;
}
