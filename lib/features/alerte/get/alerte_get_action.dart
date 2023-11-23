import 'package:pass_emploi_app/models/alerte/alerte.dart';

class FetchAlerteResultsFromIdAction {
  final String alerteId;

  FetchAlerteResultsFromIdAction(this.alerteId);
}

class FetchAlerteResultsAction {
  final Alerte alerte;

  FetchAlerteResultsAction(this.alerte);
}
