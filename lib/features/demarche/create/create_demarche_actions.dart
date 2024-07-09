class CreateDemarcheRequestAction {
  final String codeQuoi;
  final String codePourquoi;
  final String? codeComment;
  final DateTime dateEcheance;
  final bool estDuplicata;

  CreateDemarcheRequestAction({
    required this.codeQuoi,
    required this.codePourquoi,
    required this.codeComment,
    required this.dateEcheance,
    required this.estDuplicata,
  });
}

class CreateDemarchePersonnaliseeRequestAction {
  final String commentaire;
  final DateTime dateEcheance;
  final bool estDuplicata;

  CreateDemarchePersonnaliseeRequestAction(
    this.commentaire,
    this.dateEcheance,
    this.estDuplicata,
  );
}

class CreateDemarcheLoadingAction {}

class CreateDemarcheSuccessAction {
  final String demarcheCreatedId;

  CreateDemarcheSuccessAction(this.demarcheCreatedId);
}

class CreateDemarcheFailureAction {}

class CreateDemarcheResetAction {}
