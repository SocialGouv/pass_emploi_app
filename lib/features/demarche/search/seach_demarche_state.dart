import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

abstract class SearchDemarcheState {}

class SearchDemarcheNotInitializedState extends SearchDemarcheState {}

class SearchDemarcheLoadingState extends SearchDemarcheState {}

class SearchDemarcheSuccessState extends SearchDemarcheState {
  final List<DemarcheDuReferentiel> demarchesDuReferentiel;

  SearchDemarcheSuccessState(this.demarchesDuReferentiel);
}

class SearchDemarcheFailureState extends SearchDemarcheState {}
