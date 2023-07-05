import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheDuReferentielCardViewModel {
  final String quoi;
  final String pourquoi;

  DemarcheDuReferentielCardViewModel({required this.quoi, required this.pourquoi});

  factory DemarcheDuReferentielCardViewModel.create(Store<AppState> store, String idDemarche, DemarcheSource source) {
    return switch (source) {
      RechercheDemarcheSource() => _demarcheFromRecherche(store, idDemarche),
      ThematiquesDemarcheSource() => _demarcheFromThematiques(store, idDemarche),
    };
  }
}

DemarcheDuReferentielCardViewModel _demarcheFromRecherche(Store<AppState> store, String idDemarche) {
  final state = store.state.searchDemarcheState;
  if (state is SearchDemarcheSuccessState) {
    final demarche = state.demarchesDuReferentiel.firstWhereOrNull((demarche) => demarche.id == idDemarche);
    if (demarche != null) return DemarcheDuReferentielCardViewModel(quoi: demarche.quoi, pourquoi: demarche.pourquoi);
  }
  return DemarcheDuReferentielCardViewModel(quoi: '', pourquoi: '');
}

DemarcheDuReferentielCardViewModel _demarcheFromThematiques(Store<AppState> store, String idDemarche) {
  final state = store.state.thematiquesDemarcheState;
  if (state is ThematiquesDemarcheSuccessState) {
    final thematique = state.thematiques
        .firstWhereOrNull((thematique) => thematique.demarches.any((demarche) => demarche.id == idDemarche));
    if (thematique != null) {
      final demarche = thematique.demarches.firstWhereOrNull((demarche) => demarche.id == idDemarche);
      if (demarche != null) return DemarcheDuReferentielCardViewModel(quoi: demarche.quoi, pourquoi: demarche.pourquoi);
    }
  }
  return DemarcheDuReferentielCardViewModel(quoi: '', pourquoi: '');
}
