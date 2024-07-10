import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';

class MatchingDemarcheRequestAction {
  final String demarcheId;

  MatchingDemarcheRequestAction({required this.demarcheId});
}

class MatchingDemarcheLoadingAction {}

class MatchingDemarcheSuccessAction {
  final MatchingDemarcheDuReferentiel? result;

  MatchingDemarcheSuccessAction(this.result);
}

class MatchingDemarcheFailureAction {}

class MatchingDemarcheResetAction {}
