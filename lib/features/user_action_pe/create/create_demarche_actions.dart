class CreateDemarcheRequestAction {
  final String commentaire;
  final DateTime dateEcheance;

  CreateDemarcheRequestAction(this.commentaire, this.dateEcheance);
}

class CreateDemarcheLoadingAction {}

class CreateDemarcheSuccessAction {}

class CreateDemarcheFailureAction {}

class CreateDemarcheResetAction {}
