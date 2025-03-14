import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class FavoriIdsSuccessAction<T> {
  final Set<FavoriDto> favoris;

  FavoriIdsSuccessAction(this.favoris);
}
