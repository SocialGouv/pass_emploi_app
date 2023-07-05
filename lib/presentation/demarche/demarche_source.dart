import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

sealed class DemarcheSource {
  DemarcheDuReferentiel? demarcheFromSource(Store<AppState> store, String idDemarche) {
    return _demarcheFromSource(store, idDemarche, this);
  }
}

class RechercheDemarcheSource extends DemarcheSource {}

class ThematiquesDemarcheSource extends DemarcheSource {
  final String thematiqueCode;

  ThematiquesDemarcheSource(this.thematiqueCode);
}

DemarcheDuReferentiel? _demarcheFromSource(Store<AppState> store, String idDemarche, DemarcheSource source) {
  return switch (source) {
    RechercheDemarcheSource() => _demarcheFromRecherche(store, idDemarche),
    ThematiquesDemarcheSource() => _demarcheFromThematiques(store, idDemarche),
  };
}

DemarcheDuReferentiel? _demarcheFromRecherche(Store<AppState> store, String idDemarche) {
  final state = store.state.searchDemarcheState;
  if (state is SearchDemarcheSuccessState) {
    return state.demarchesDuReferentiel.firstWhereOrNull((demarche) => demarche.id == idDemarche);
  }
  return null;
}

DemarcheDuReferentiel? _demarcheFromThematiques(Store<AppState> store, String idDemarche) {
  final state = store.state.thematiquesDemarcheState;
  if (state is ThematiquesDemarcheSuccessState) {
    final thematique = state.thematiques
        .firstWhereOrNull((thematique) => thematique.demarches.any((demarche) => demarche.id == idDemarche));
    if (thematique != null) {
      return thematique.demarches.firstWhereOrNull((demarche) => demarche.id == idDemarche);
    }
  }
  return null;
}
