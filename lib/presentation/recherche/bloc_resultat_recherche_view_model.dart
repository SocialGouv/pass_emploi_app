import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

//TODO: 4T: Result (pour dispatch RechercheLoadMoreAction)
//TODO: 4T: store vers status ou state générique (pour display state)
//TODO: 4T: store vers results ou state générique (pour items)
//TODO: 4T: store vers results ou state générique (pour canLoadMore)
//TODO: 4T: attention ici items ne devrait pas être spécifique

enum BlocResultatRechercheDisplayState { recherche, empty, results }

class BlocResultatRechercheViewModel extends Equatable {
  final BlocResultatRechercheDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final bool withLoadMore;
  final Function() onLoadMore;

  BlocResultatRechercheViewModel({
    required this.displayState,
    required this.items,
    required this.withLoadMore,
    required this.onLoadMore,
  });

  factory BlocResultatRechercheViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEmploiState;
    return BlocResultatRechercheViewModel(
      displayState: _displayState(state),
      items: state.results?.map((offre) => OffreEmploiItemViewModel.create(offre)).toList() ?? [],
      withLoadMore: state.canLoadMore,
      onLoadMore: () => store.dispatch(RechercheLoadMoreAction<OffreEmploi>()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, withLoadMore];
}

BlocResultatRechercheDisplayState _displayState(RechercheState state) {
  if (state.status == RechercheStatus.success) {
    return state.results?.isEmpty == true
        ? BlocResultatRechercheDisplayState.empty
        : BlocResultatRechercheDisplayState.results;
  } else if (state.status == RechercheStatus.updateLoading) {
    return BlocResultatRechercheDisplayState.results;
  } else {
    return BlocResultatRechercheDisplayState.recherche;
  }
}
