import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheDuReferentielCardViewModel {
  final String quoi;
  final String pourquoi;

  DemarcheDuReferentielCardViewModel({required this.quoi, required this.pourquoi});

  factory DemarcheDuReferentielCardViewModel.create(Store<AppState> store, String idDemarche, DemarcheSource source) {
    final demarche = source.demarche(store, idDemarche);
    if (demarche != null) {
      return DemarcheDuReferentielCardViewModel(
        quoi: demarche.quoi,
        pourquoi: demarche.pourquoi,
      );
    }
    return DemarcheDuReferentielCardViewModel(quoi: '', pourquoi: '');
  }
}
