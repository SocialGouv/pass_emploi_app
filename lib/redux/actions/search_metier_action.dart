import 'package:pass_emploi_app/models/metier.dart';

abstract class SearchMetierAction {}

class RequestMetierAction extends SearchMetierAction {
  final String? input;

  RequestMetierAction(this.input);
}

class SearchMetierSuccessAction extends SearchMetierAction {
  final List<Metier> metiers;

  SearchMetierSuccessAction(this.metiers);
}

class ResetMetierAction extends SearchMetierAction {}
