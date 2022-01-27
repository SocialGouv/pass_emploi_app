import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/actions/immersion_details_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:redux/redux.dart';

class ImmersionDetailsMiddleware extends MiddlewareClass<AppState> {
  final ImmersionDetailsRepository _repository;

  ImmersionDetailsMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is ImmersionDetailsAction && action.isRequest()) {
      final offreId = action.getRequestOrThrow();
      store.dispatch(ImmersionDetailsAction.loading());
      final result = await _repository.fetch(offreId);
      if (result.details != null) {
        store.dispatch(ImmersionDetailsAction.success(result.details!));
      } else {
        _dispatchIncompleteDataOrError(store, result, offreId);
      }
    }
  }

  void _dispatchIncompleteDataOrError(Store<AppState> store, OffreDetailsResponse result, String offreId) {
    var favorisState = store.state.immersionFavorisState;
    if (result.isOffreNotFound &&
        favorisState is FavorisLoadedState<Immersion> &&
        favorisState.data != null &&
        favorisState.data![offreId] != null) {
      store.dispatch(ImmersionDetailsIncompleteDataAction(favorisState.data![offreId]!));
    } else {
      store.dispatch(ImmersionDetailsAction.failure());
    }
  }
}
