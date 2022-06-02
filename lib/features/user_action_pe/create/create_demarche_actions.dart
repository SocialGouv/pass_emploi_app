class CreateDemarcheRequestAction {
  final String commentaire;

  CreateDemarcheRequestAction(this.commentaire, this.dateEcheance);

  final DateTime dateEcheance;
}

class CreateDemarcheSuccessAction {}

class CreateDemarcheFailureAction {}
