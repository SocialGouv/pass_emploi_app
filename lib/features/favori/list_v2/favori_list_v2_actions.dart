import 'package:pass_emploi_app/models/favori.dart';

class FavoriListV2RequestAction {}

class FavoriListV2SuccessAction {
  final List<Favori> results;

  FavoriListV2SuccessAction(this.results);
}

class FavoriListV2FailureAction {}

class FavoriListV2ResetAction {}
