import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class TopDemarchePageViewModel extends Equatable {
  final List<DemarcheListItem> demarches;

  TopDemarchePageViewModel({required this.demarches});

  factory TopDemarchePageViewModel.create(Store<AppState> store) {
    final state = store.state.topDemarcheState;
    return TopDemarchePageViewModel(
      demarches: _thematiques(state),
    );
  }

  @override
  List<Object?> get props => [demarches];
}

List<DemarcheListItem> _thematiques(TopDemarcheState state) {
  return state is TopDemarcheSuccessState ? state.demarches.map((e) => IdItem(e.id)).toList() : <DemarcheListItem>[];
}
