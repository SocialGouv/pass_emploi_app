import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
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
      items: [],
      displayState: OffreEmploiFavorisListDisplayState.SHOW_CONTENT,
      onRetry: () => store.dispatch(RequestOffreEmploiFavorisAction()),
    );
  }
}
