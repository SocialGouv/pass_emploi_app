import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

class SearchDemarcheRequestAction {
  final String query;

  SearchDemarcheRequestAction(this.query);
}

class SearchDemarcheLoadingAction {}

class SearchDemarcheSuccessAction {
  final List<DemarcheDuReferentiel> demarchesDuReferentiel;

  SearchDemarcheSuccessAction(this.demarchesDuReferentiel);
}

class SearchDemarcheFailureAction {}

class SearchDemarcheResetAction {}
