import 'package:pass_emploi_app/models/metier.dart';

class SearchMetierRequestAction {
  final String? input;

  SearchMetierRequestAction(this.input);
}

class SearchMetierSuccessAction {
  final List<Metier> metiers;

  SearchMetierSuccessAction(this.metiers);
}

class SearchMetierResetAction {}
