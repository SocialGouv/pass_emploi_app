import 'package:pass_emploi_app/features/favori/ids/favori_ids_action.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class FavoriIdsReducer<T> {
  FavoriIdsState<T> reduceFavorisState(FavoriIdsState<T> current, dynamic action) {
    if (action is FavoriIdsSuccessAction<T>) return FavoriIdsState<T>.success(action.favoris);
    if (action is FavoriUpdateSuccessAction<T> && current is FavoriIdsSuccessState<T>) {
      return _updatedIds(current, action);
    }
    return current;
  }

  FavoriIdsState<T> _updatedIds(FavoriIdsSuccessState<T> current, FavoriUpdateSuccessAction<T> action) {
    final newIds = Set<FavoriDto>.from(current.favoris);
    if (action.confirmedNewStatus == FavoriStatus.added) newIds.add(FavoriDto(action.favoriId));
    if (action.confirmedNewStatus == FavoriStatus.postulated) {
      newIds.add(FavoriDto(action.favoriId, datePostulation: DateTime.now()));
    }
    if (action.confirmedNewStatus == FavoriStatus.removed) newIds.remove(FavoriDto(action.favoriId));
    return FavoriIdsState<T>.success(newIds);
  }
}
