import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

enum OffreEmploiFavorisListDisplayState { SHOW_CONTENT, SHOW_LOADER, SHOW_ERROR, SHOW_EMPTY_ERROR }

class OffreEmploiFavorisListViewModel extends Equatable {
  final OffreEmploiFavorisListDisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final Function() onRetry;

  @override
  List<Object?> get props => [displayState, items];

  OffreEmploiFavorisListViewModel._({required this.items, required this.displayState, required this.onRetry});

  factory OffreEmploiFavorisListViewModel.create(Store<AppState> store) {
    return OffreEmploiFavorisListViewModel._(
      items: _items(store.state.offreEmploiFavorisState),
      displayState: _displayState(store.state.offreEmploiFavorisState),
      onRetry: () => store.dispatch(RequestOffreEmploiFavorisAction()),
    );
  }
}

List<OffreEmploiItemViewModel> _items(OffreEmploiFavorisState favorisState) {
  if (favorisState is OffreEmploiFavorisLoadedState) {
    return favorisState.data?.values
            .map((e) => OffreEmploiItemViewModel(
                  e.id,
                  e.title,
                  e.companyName,
                  e.contractType,
                  e.duration,
                  e.location,
                ))
            .toList() ??
        [];
  } else {
    return [];
  }
}

OffreEmploiFavorisListDisplayState _displayState(OffreEmploiFavorisState favorisState) {
  if (favorisState is OffreEmploiFavorisLoadedState) {
    if (favorisState.data?.isEmpty == true) {
      return OffreEmploiFavorisListDisplayState.SHOW_EMPTY_ERROR;
    } else if (favorisState.data != null) {
      return OffreEmploiFavorisListDisplayState.SHOW_CONTENT;
    } else {
      return OffreEmploiFavorisListDisplayState.SHOW_LOADER;
    }
  } else {
    return OffreEmploiFavorisListDisplayState.SHOW_ERROR;
  }
}
