import 'package:pass_emploi_app/models/accueil/accueil.dart';

class AccueilRequestAction {}

class AccueilLoadingAction {}

class AccueilSuccessAction {
  final Accueil accueil;

  AccueilSuccessAction(this.accueil);
}

class AccueilFailureAction {}

class AccueilResetAction {}
