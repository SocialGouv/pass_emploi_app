import 'package:pass_emploi_app/models/favori.dart';

class FavoriListRequestAction {}

class FavoriListSuccessAction {
  final List<Favori> results;

  FavoriListSuccessAction(this.results);
}

class FavoriListFailureAction {}

class FavoriListResetAction {}
