import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class OffreEmploiMiddleware extends MiddlewareClass<AppState> {
  final OffreEmploiRepository _repository;

  OffreEmploiMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    final parametersState = store.state.offreEmploiSearchParametersState;
    final searchState = store.state.offreEmploiSearchState;
    if (loginState is LoggedInState) {
      if (action is SearchOffreEmploiAction) {
        store.dispatch(OffreEmploiSearchLoadingAction());
        final result = await _repository.search(
          userId: loginState.user.id,
          keywords: action.keywords,
          department: action.department,
          page: 1,
        );

        if (result != null) {
          store.dispatch(OffreEmploiSearchSuccessAction(offres: result, page: 1));
        } else {
          store.dispatch(OffreEmploiSearchFailureAction());
        }
      } else if (action is RequestMoreOffreEmploiSearchResultsAction &&
          parametersState is OffreEmploiSearchParametersInitializedState &&
          searchState is OffreEmploiSearchSuccessState) {
        store.dispatch(OffreEmploiSearchLoadingAction());
        var pageToLoad = searchState.loadedPage + 1;
        final result = await _repository.search(
          userId: loginState.user.id,
          keywords: parametersState.keyWords,
          department: parametersState.department,
          page: pageToLoad,
        );
        if (result != null) {
          store.dispatch(OffreEmploiSearchSuccessAction(offres: result, page: pageToLoad));
        } else {
          store.dispatch(OffreEmploiSearchFailureAction());
        }
      }
    }
  }
}
