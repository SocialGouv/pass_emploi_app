import 'package:pass_emploi_app/models/favori.dart';

class FavoriUpdateRequestAction<T> {
  final String favoriId;
  final FavoriStatus newStatus;

  FavoriUpdateRequestAction(this.favoriId, this.newStatus);
}

class FavoriUpdateLoadingAction<T> {
  final String favoriId;

  FavoriUpdateLoadingAction(this.favoriId);
}

class FavoriUpdateSuccessAction<T> {
  final String favoriId;
  final FavoriStatus confirmedNewStatus;

  FavoriUpdateSuccessAction(this.favoriId, this.confirmedNewStatus);
}

class FavoriUpdateFailureAction<T> {
  final String favoriId;

  FavoriUpdateFailureAction(this.favoriId);
}
