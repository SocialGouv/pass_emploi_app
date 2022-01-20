import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

typedef OffreEmploiFavorisListViewModel = FavorisListViewModel<OffreEmploi, OffreEmploiItemViewModel>;

class FavorisListViewModel<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> extends Equatable {
  final DisplayState displayState;
  final List<FAVORIS_VIEW_MODEL> items;
  final Function() onRetry;

  @override
  List<Object?> get props => [displayState, items];

  FavorisListViewModel._({required this.items, required this.displayState, required this.onRetry});

  factory FavorisListViewModel.create(
    Store<AppState> store,
    RelevantFavorisExtractor<FAVORIS_MODEL> relevantFavorisExtractor,
    FavorisViewModelTransformer<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> viewModelTransformer,
  ) {
    final retry = () => store.dispatch(RequestFavorisAction<FAVORIS_MODEL>());
    if (relevantFavorisExtractor.isDataInitialized(store)) {
      final favoris = relevantFavorisExtractor.getRelevantFavoris(store);
      return FavorisListViewModel._(
        items: favoris?.map((e) => viewModelTransformer.transform(e)).toList() ?? [],
        displayState: _displayState(favoris),
        onRetry: retry,
      );
    } else {
      return FavorisListViewModel._(items: [], displayState: DisplayState.FAILURE, onRetry: retry);
    }
  }

  static OffreEmploiFavorisListViewModel createForOffreEmploi(Store<AppState> store, {required bool onlyAlternance}) {
    return FavorisListViewModel.create(
      store,
      onlyAlternance ? AlternanceRelevantFavorisExtractor() : OffreEmploiRelevantFavorisExtractor(),
      OffreEmploiFavorisViewModelTransformer(),
    );
  }
}

DisplayState _displayState(List? favoris) {
  if (favoris?.isEmpty == true) return DisplayState.EMPTY;
  if (favoris != null) return DisplayState.CONTENT;
  return DisplayState.LOADING;
}

abstract class RelevantFavorisExtractor<FAVORIS_MODEL> {
  List<FAVORIS_MODEL>? getRelevantFavoris(Store<AppState> store);

  bool isDataInitialized(Store<AppState> store);
}

class AlternanceRelevantFavorisExtractor extends RelevantFavorisExtractor<OffreEmploi> {
  @override
  List<OffreEmploi>? getRelevantFavoris(Store<AppState> store) {
    final state = store.state.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>;
    return state.data?.values.where((e) => e.isAlternance).toList();
  }

  @override
  bool isDataInitialized(Store<AppState> store) {
    return store.state.offreEmploiFavorisState is FavorisLoadedState<OffreEmploi>;
  }
}

class OffreEmploiRelevantFavorisExtractor extends RelevantFavorisExtractor<OffreEmploi> {
  @override
  List<OffreEmploi>? getRelevantFavoris(Store<AppState> store) {
    final state = store.state.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>;
    return state.data?.values.toList();
  }

  @override
  bool isDataInitialized(Store<AppState> store) {
    return store.state.offreEmploiFavorisState is FavorisLoadedState<OffreEmploi>;
  }
}

abstract class FavorisViewModelTransformer<FAVORIS_MODEL, FAVORIS_VIEW_MODEL> {
  FAVORIS_VIEW_MODEL transform(FAVORIS_MODEL favorisModel);
}

class OffreEmploiFavorisViewModelTransformer
    extends FavorisViewModelTransformer<OffreEmploi, OffreEmploiItemViewModel> {
  @override
  OffreEmploiItemViewModel transform(OffreEmploi favorisModel) {
    return OffreEmploiItemViewModel.create(favorisModel);
  }
}
