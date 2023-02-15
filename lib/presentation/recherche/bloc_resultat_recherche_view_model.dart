import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum BlocResultatRechercheDisplayState { recherche, empty, results, results_with_opacity }

class BlocResultatRechercheViewModel<Result> extends Equatable {
  final BlocResultatRechercheDisplayState displayState;
  final List<Result> items;
  final bool withLoadMore;
  final Function() onListWithOpacityTouch;
  final Function() onLoadMore;

  BlocResultatRechercheViewModel({
    required this.displayState,
    required this.items,
    required this.withLoadMore,
    required this.onListWithOpacityTouch,
    required this.onLoadMore,
  });

  factory BlocResultatRechercheViewModel.create(
    Store<AppState> store,
    RechercheState Function(AppState) rechercheState,
  ) {
    final state = rechercheState(store.state);
    return BlocResultatRechercheViewModel(
      displayState: _displayState(state),
      items: state.results as List<Result>? ?? [],
      withLoadMore: state.canLoadMore,
      onListWithOpacityTouch: () => store.dispatch(RechercheCloseCriteresAction<Result>()),
      onLoadMore: () => store.dispatch(RechercheLoadMoreAction<Result>()),
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
  } else if (state.status == RechercheStatus.nouvelleRecherche) {
    if (state.results == null) {
      return BlocResultatRechercheDisplayState.recherche;
    } else {
      return state.results?.isEmpty == true
          ? BlocResultatRechercheDisplayState.empty
          : BlocResultatRechercheDisplayState.results_with_opacity;
    }
  } else {
    return BlocResultatRechercheDisplayState.recherche;
  }
}
