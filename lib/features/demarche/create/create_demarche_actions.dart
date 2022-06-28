class CreateDemarcheRequestAction {
  final String codeQuoi;
  final String codePourquoi;
  final String? codeComment;
  final DateTime dateEcheance;

  CreateDemarcheRequestAction({
    required this.codeQuoi,
    required this.codePourquoi,
    required this.codeComment,
    required this.dateEcheance,
  });
}

class CreateDemarchePersonnaliseeRequestAction {
  final String commentaire;
  final DateTime dateEcheance;

  CreateDemarchePersonnaliseeRequestAction(this.commentaire, this.dateEcheance);
}

class CreateDemarcheLoadingAction {}

class CreateDemarcheSuccessAction {}

class CreateDemarcheFailureAction {}

class CreateDemarcheResetAction {}
