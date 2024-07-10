import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

sealed class DemarcheSource {
  List<DemarcheDuReferentiel> demarcheList(Store<AppState> store);
  DemarcheDuReferentiel? demarche(Store<AppState> store, String idDemarche);
}

class RechercheDemarcheSource extends DemarcheSource {
  @override
  List<DemarcheDuReferentiel> demarcheList(Store<AppState> store) {
    final state = store.state.searchDemarcheState;
    return state is SearchDemarcheSuccessState ? state.demarchesDuReferentiel : <DemarcheDuReferentiel>[];
  }

  @override
  DemarcheDuReferentiel? demarche(Store<AppState> store, String idDemarche) {
    final demarchesDuReferentiel = demarcheList(store);
    return demarchesDuReferentiel.firstWhereOrNull((demarche) => demarche.id == idDemarche);
  }
}

class ThematiqueDemarcheSource extends DemarcheSource {
  final String thematiqueCode;

  ThematiqueDemarcheSource(this.thematiqueCode);

  @override
  List<DemarcheDuReferentiel> demarcheList(Store<AppState> store) {
    final state = store.state.thematiquesDemarcheState;
    final thematiques = state is ThematiqueDemarcheSuccessState ? state.thematiques : <ThematiqueDeDemarche>[];
    return thematiques.firstWhereOrNull((thematique) => thematique.code == thematiqueCode)?.demarches ??
        <DemarcheDuReferentiel>[];
  }

  @override
  DemarcheDuReferentiel? demarche(Store<AppState> store, String idDemarche) {
    final demarchesDuReferentiel = demarcheList(store);
    return demarchesDuReferentiel.firstWhereOrNull((demarche) => demarche.id == idDemarche);
  }
}

class TopDemarcheSource extends DemarcheSource {
  @override
  List<DemarcheDuReferentiel> demarcheList(Store<AppState> store) {
    final state = store.state.topDemarcheState;
    return state is TopDemarcheSuccessState ? state.demarches : <DemarcheDuReferentiel>[];
  }

  @override
  DemarcheDuReferentiel? demarche(Store<AppState> store, String idDemarche) {
    final demarchesDuReferentiel = demarcheList(store);
    return demarchesDuReferentiel.firstWhereOrNull((demarche) => demarche.id == idDemarche);
  }
}

class MatchingDemarcheSource extends DemarcheSource {
  @override
  List<DemarcheDuReferentiel> demarcheList(Store<AppState> store) {
    return <DemarcheDuReferentiel>[];
  }

  @override
  DemarcheDuReferentiel? demarche(Store<AppState> store, String idDemarche) {
    final matchingDemarcheState = store.state.matchingDemarcheState;

    return matchingDemarcheState is MatchingDemarcheSuccessState
        ? matchingDemarcheState.result?.demarcheDuReferentiel
        : null;
  }
}
