import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:redux/redux.dart';

class ImmersionDetailsMiddleware extends MiddlewareClass<AppState> {
  final ImmersionDetailsRepository _repository;

  ImmersionDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is ImmersionDetailsRequestAction) {
      store.dispatch(ImmersionDetailsLoadingAction());
      final result = await _repository.fetch(action.immersionId);
      if (result.details != null) {
        store.dispatch(ImmersionDetailsSuccessAction(result.details!));
      } else {
        _dispatchIncompleteDataOrError(store, result, action.immersionId);
      }
    }
  }

  void _dispatchIncompleteDataOrError<T>(Store<AppState> store, OffreDetailsResponse<T> result, String offreId) {
    final favorisState = store.state.favoriListV2State;
    if (result.isOffreNotFound &&
        favorisState is FavoriListV2SuccessState &&
        favorisState.results.any((element) => element.id == offreId)) {
      final favori = favorisState.results.firstWhere((element) => element.id == offreId);
      store.dispatch(ImmersionDetailsIncompleteDataAction(favori.toImmersion));
    } else {
      store.dispatch(ImmersionDetailsFailureAction());
    }
  }
}
