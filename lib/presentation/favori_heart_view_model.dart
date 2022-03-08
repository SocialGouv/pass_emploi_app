import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
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

  factory FavoriHeartViewModel.create(String offreId, Store<AppState> store, FavorisState<T> favorisState) {
    return FavoriHeartViewModel._(
      isFavori: _isFavori(offreId, favorisState),
      withError: _withError(offreId, store.state.favorisUpdateState),
      withLoading: _withLoading(offreId, store.state.favorisUpdateState),
      update: (newStatus) => store.dispatch(UpdateFavoriRequestAction<T>(offreId, newStatus)),
    );
  }

  @override
  List<Object?> get props => [isFavori, withError, withLoading];
}

bool _isFavori<T>(String offreId, FavorisState<T> favorisState) {
  if (favorisState is FavorisLoadedState<T>) {
    return favorisState.favoriIds.contains(offreId);
  } else {
    return false;
  }
}

bool _withError(String offreId, FavorisUpdateState updateState) {
  return updateState.requestStatus[offreId] == FavorisUpdateStatus.ERROR;
}

bool _withLoading(String offreId, FavorisUpdateState updateState) {
  return updateState.requestStatus[offreId] == FavorisUpdateStatus.LOADING;
}
