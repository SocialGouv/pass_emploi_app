import 'package:pass_emploi_app/models/mon_suivi.dart';

class MonSuiviRequestAction {
  final DateTime debut;
  final DateTime fin;

  MonSuiviRequestAction({required this.debut, required this.fin});
}

class MonSuiviLoadingAction {}

class MonSuiviSuccessAction {
  final MonSuivi monSuivi;

  MonSuiviSuccessAction(this.monSuivi);
}

class MonSuiviFailureAction {}

class MonSuiviResetAction {}
