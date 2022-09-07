import 'package:pass_emploi_app/models/partage_activite.dart';

class PartageActiviteRequestAction {}

class PartageActiviteLoadingAction {}

class PartageActiviteSuccessAction {
  final PartageActivite preferences;

  PartageActiviteSuccessAction(this.preferences);
}

class PartageActiviteFailureAction {}
