class CreateDemarcheRequestAction {
  final String commentaire;
  final DateTime dateEcheance;

  CreateDemarcheRequestAction(this.commentaire, this.dateEcheance);
}

class CreateDemarcheSuccessAction {}

class CreateDemarcheFailureAction {}
