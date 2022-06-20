import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheDuReferentielCardViewModel {
  final String quoi;
  final String pourquoi;

  DemarcheDuReferentielCardViewModel({required this.quoi, required this.pourquoi});

  factory DemarcheDuReferentielCardViewModel.create(Store<AppState> store, int indexOfDemarche) {
    final state = store.state.searchDemarcheState;
    if (state is SearchDemarcheSuccessState && indexOfDemarche < state.demarchesDuReferentiel.length) {
      final demarche = state.demarchesDuReferentiel[indexOfDemarche];
      return DemarcheDuReferentielCardViewModel(quoi: demarche.quoi, pourquoi: demarche.pourquoi);
    }
    return DemarcheDuReferentielCardViewModel(quoi: '', pourquoi: '');
  }
}
