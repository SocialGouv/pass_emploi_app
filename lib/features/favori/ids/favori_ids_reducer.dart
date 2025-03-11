import 'package:pass_emploi_app/features/favori/ids/favori_ids_action.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';

class FavoriIdsReducer<T> {
  FavoriIdsState<T> reduceFavorisState(FavoriIdsState<T> current, dynamic action) {
    if (action is FavoriIdsSuccessAction<T>) return FavoriIdsState<T>.success(action.favoriIds);
    if (action is FavoriUpdateSuccessAction<T> && current is FavoriIdsSuccessState<T>) {
      return _updatedIds(current, action);
    }
    return current;
  }

  FavoriIdsState<T> _updatedIds(FavoriIdsSuccessState<T> current, FavoriUpdateSuccessAction<T> action) {
    final newIds = Set<String>.from(current.favoriIds);
    if (action.confirmedNewStatus == FavoriStatus.added) newIds.add(action.favoriId);
    if (action.confirmedNewStatus == FavoriStatus.postulated) newIds.add(action.favoriId);
    if (action.confirmedNewStatus == FavoriStatus.removed) newIds.remove(action.favoriId);
    return FavoriIdsState<T>.success(newIds);
  }
}
