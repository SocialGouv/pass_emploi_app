import 'package:pass_emploi_app/models/accueil/accueil.dart';

class AccueilRequestAction {
  final bool forceRefresh;

  AccueilRequestAction({this.forceRefresh = false});
}

class AccueilLoadingAction {}

class AccueilSuccessAction {
  final Accueil accueil;

  AccueilSuccessAction(this.accueil);
}

class AccueilFailureAction {}

class AccueilResetAction {}
