import 'package:pass_emploi_app/models/comptage_des_heures.dart';

class ComptageDesHeuresRequestAction {}

class ComptageDesHeuresLoadingAction {}

class ComptageDesHeuresSuccessAction {
  final ComptageDesHeures comptageDesHeures;

  ComptageDesHeuresSuccessAction(this.comptageDesHeures);
}

class ComptageDesHeuresProgressAction {}

class ComptageDesHeuresFailureAction {}
