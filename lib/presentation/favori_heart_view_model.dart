import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class FavoriHeartViewModel<T> extends Equatable {
  final bool isFavori;
  final bool withError;
  final bool withLoading;
  final Function(FavoriStatus newStatus) update;

  FavoriHeartViewModel._({
    required this.isFavori,
    required this.withError,
    required this.withLoading,
    required this.update,
  });

  factory FavoriHeartViewModel.create(String offreId, Store<AppState> store, FavoriIdsState<T> favorisState) {
    return FavoriHeartViewModel._(
      isFavori: _isFavori(offreId, favorisState),
      withError: _withError(offreId, store.state.favoriUpdateState),
      withLoading: _withLoading(offreId, store.state.favoriUpdateState),
      update: (newStatus) => store.dispatch(FavoriUpdateRequestAction<T>(offreId, newStatus)),
    );
  }

  @override
  List<Object?> get props => [isFavori, withError, withLoading];
}

bool _isFavori<T>(String offreId, FavoriIdsState<T> favorisState) {
  if (favorisState is FavoriIdsSuccessState<T>) {
    return favorisState.favoris.any((favori) => favori.id == offreId);
  } else {
    return false;
  }
}

bool _withError(String offreId, FavoriUpdateState updateState) {
  return updateState.requestStatus[offreId] == FavoriUpdateStatus.ERROR;
}

bool _withLoading(String offreId, FavoriUpdateState updateState) {
  return updateState.requestStatus[offreId] == FavoriUpdateStatus.LOADING;
}
