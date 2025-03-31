import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheDuReferentielCardViewModel {
  final String idDemarche;
  final String quoi;
  final String pourquoi;
  final String codeQuoi;
  final String codePourquoi;

  DemarcheDuReferentielCardViewModel({
    required this.idDemarche,
    required this.quoi,
    required this.pourquoi,
    this.codeQuoi = "",
    this.codePourquoi = "",
  });

  factory DemarcheDuReferentielCardViewModel.create(Store<AppState> store, String idDemarche, DemarcheSource source) {
    final demarche = source.demarche(store, idDemarche);
    if (demarche != null) {
      return DemarcheDuReferentielCardViewModel(
        idDemarche: idDemarche,
        quoi: demarche.quoi,
        pourquoi: demarche.pourquoi,
        codeQuoi: demarche.codeQuoi,
        codePourquoi: demarche.codePourquoi,
      );
    }
    return DemarcheDuReferentielCardViewModel(
      idDemarche: '',
      quoi: '',
      pourquoi: '',
      codeQuoi: '',
      codePourquoi: '',
    );
  }
}
