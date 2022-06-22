import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep3ViewModel extends Equatable {
  final String pourquoi;
  final String quoi;

  CreateDemarcheStep3ViewModel({
    required this.pourquoi,
    required this.quoi,
  });

  factory CreateDemarcheStep3ViewModel.create(Store<AppState> store, String idDemarche) {
    final state = store.state.searchDemarcheState;
    if (state is SearchDemarcheSuccessState) {
      final demarche = state.demarchesDuReferentiel.firstWhereOrNull((e) => e.id == idDemarche);
      if (demarche != null) {
        return CreateDemarcheStep3ViewModel(
          pourquoi: demarche.pourquoi,
          quoi: demarche.quoi,
        );
      }
    }
    return CreateDemarcheStep3ViewModel(pourquoi: '', quoi  :'');
  }

  @override
  List<Object?> get props => [pourquoi, quoi];
}
