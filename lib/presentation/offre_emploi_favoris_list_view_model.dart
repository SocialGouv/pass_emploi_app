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
    final state = store.state.offreEmploiFavorisState;
    final retry = store.dispatch(RequestOffreEmploiFavorisAction());
    if (state is OffreEmploiFavorisLoadedState) {
      final favoris = _relevantFavoris(state.data, onlyAlternance);
      return OffreEmploiFavorisListViewModel._(
        items: favoris?.map((e) => OffreEmploiItemViewModel.create(e)).toList() ?? [],
        displayState: _displayState(favoris),
        onRetry: () => retry(),
      );
    } else {
      return OffreEmploiFavorisListViewModel._(items: [], displayState: DisplayState.FAILURE, onRetry: () => retry());
    }
  }
}

List<OffreEmploi>? _relevantFavoris(Map<String, OffreEmploi>? data, onlyAlternance) {
  if (data != null) return onlyAlternance ? data.values.where((e) => e.isAlternance).toList() : data.values.toList();
  return null;
}

DisplayState _displayState(List<OffreEmploi>? favoris) {
  if (favoris?.isEmpty == true) return DisplayState.EMPTY;
  if (favoris != null) return DisplayState.CONTENT;
  return DisplayState.LOADING;
}
