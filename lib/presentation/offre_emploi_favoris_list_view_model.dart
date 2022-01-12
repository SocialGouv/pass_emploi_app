import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

class OffreEmploiFavorisListViewModel extends Equatable {
  final DisplayState displayState;
  final List<OffreEmploiItemViewModel> items;
  final Function() onRetry;

  @override
  List<Object?> get props => [displayState, items];

  OffreEmploiFavorisListViewModel._({required this.items, required this.displayState, required this.onRetry});

  factory OffreEmploiFavorisListViewModel.create(Store<AppState> store, {required bool onlyAlternance}) {
    final relevantFavoris = _relevantFavoris(store.state.offreEmploiFavorisState, onlyAlternance);
    return OffreEmploiFavorisListViewModel._(
      items: _items(relevantFavoris),
      displayState: _displayState(store.state.offreEmploiFavorisState, relevantFavoris),
      onRetry: () => store.dispatch(RequestOffreEmploiFavorisAction()),
    );
  }
}

List<OffreEmploi>? _relevantFavoris(OffreEmploiFavorisState favorisState, onlyAlternance) {
  if (favorisState is OffreEmploiFavorisLoadedState) {
    final data = favorisState.data;
    if (data == null) return null;
    return onlyAlternance ? data.values.where((e) => e.isAlternance).toList() : data.values.toList();
  }
  return null;
}

List<OffreEmploiItemViewModel> _items(List<OffreEmploi>? favoris) {
  if (favoris == null) return [];
  return favoris
      .map((e) => OffreEmploiItemViewModel(
            id: e.id,
            title: e.title,
            companyName: e.companyName,
            contractType: e.contractType,
            duration: e.duration,
            location: e.location,
          ))
      .toList();
}

DisplayState _displayState(OffreEmploiFavorisState favorisState, List<OffreEmploi>? favoris) {
  if (favorisState is OffreEmploiFavorisLoadedState) {
    if (favoris?.isEmpty == true) {
      return DisplayState.EMPTY;
    } else if (favoris != null) {
      return DisplayState.CONTENT;
    } else {
      return DisplayState.LOADING;
    }
  } else {
    return DisplayState.FAILURE;
  }
}
