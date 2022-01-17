import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';
import 'package:redux/redux.dart';

class FavoriHeartViewModel<T> extends Equatable {
  final bool isFavori;
  final bool withError;
  final bool withLoading;
  final Function(bool newStatus) update;

  FavoriHeartViewModel._({
    required this.isFavori,
    required this.withError,
    required this.withLoading,
    required this.update,
  });

  factory FavoriHeartViewModel.create(String offreId, Store<AppState> store) {
    return FavoriHeartViewModel._(
      isFavori: _isFavori(offreId, store.state.offreEmploiFavorisState),
      withError: _withError(offreId, store.state.offreEmploiFavorisUpdateState),
      withLoading: _withLoading(offreId, store.state.offreEmploiFavorisUpdateState),
      update: (newStatus) => store.dispatch(RequestUpdateFavoriAction<T>(offreId, newStatus)),
    );
  }

  @override
  List<Object?> get props => [isFavori, withError, withLoading];
}

bool _isFavori<T>(String offreId, FavorisState<T> offreEmploiFavorisState) {
  if (offreEmploiFavorisState is FavorisLoadedState<T>) {
    return offreEmploiFavorisState.favorisId.contains(offreId);
  } else {
    return false;
  }
}

bool _withError(String offreId, OffreEmploiFavorisUpdateState updateState) {
  return updateState.requestStatus[offreId] == OffreEmploiFavorisUpdateStatus.ERROR;
}

bool _withLoading(String offreId, OffreEmploiFavorisUpdateState updateState) {
  return updateState.requestStatus[offreId] == OffreEmploiFavorisUpdateStatus.LOADING;
}
