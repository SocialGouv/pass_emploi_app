import 'package:pass_emploi_app/models/evenement_emploi_details.dart';

class EvenementEmploiDetailsRequestAction {}

class EvenementEmploiDetailsLoadingAction {}

class EvenementEmploiDetailsSuccessAction {
  final EvenementEmploiDetails details;

  EvenementEmploiDetailsSuccessAction(this.details);
}

class EvenementEmploiDetailsFailureAction {}

class EvenementEmploiDetailsResetAction {}
