import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum ResultatRechercheDisplayState { recherche, empty, results }

class ResultatRechercheViewModel extends Equatable {
  final ResultatRechercheDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;

  ResultatRechercheViewModel({
    required this.displayState,
    required this.items,
  });

  factory ResultatRechercheViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEmploiState;
    return ResultatRechercheViewModel(
      displayState: _displayState(state),
      items: state.results?.map((offre) => OffreEmploiItemViewModel.create(offre)).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [displayState, items];
}

ResultatRechercheDisplayState _displayState(RechercheState state) {
  if (state.status == RechercheStatus.success) {
    return state.results?.isEmpty == true ? ResultatRechercheDisplayState.empty : ResultatRechercheDisplayState.results;
  } else {
    return ResultatRechercheDisplayState.recherche;
  }
}
