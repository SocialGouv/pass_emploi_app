import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import 'offre_emploi_item_view_model.dart';

typedef OffreEmploiFavorisListViewModel = FavorisListViewModel<OffreEmploi, OffreEmploiItemViewModel>;
typedef ImmersionFavorisListViewModel = FavorisListViewModel<Immersion, Immersion>;

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
    void retry() => store.dispatch(FavoriListRequestAction<FAVORIS_MODEL>());
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

  static ImmersionFavorisListViewModel createForImmersion(Store<AppState> store) {
    return FavorisListViewModel.create(
      store,
      ImmersionRelevantFavorisExtractor(),
      ImmersionFavorisViewModelTransformer(),
    );
  }

  static FavorisListViewModel<ServiceCivique, ServiceCivique> createForServiceCivique(Store<AppState> store) {
    return FavorisListViewModel.create(
      store,
      ServiceCiviqueRelevantFavorisExtractor(),
      ServiceCiviqueFavorisViewModelTransformer(),
    );
  }
}

DisplayState _displayState<FAVORIS_MODEL>(List<FAVORIS_MODEL>? favoris) {
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
    final state = store.state.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>;
    return state.data?.values.where((e) => e.isAlternance).toList();
  }

  @override
  bool isDataInitialized(Store<AppState> store) {
    return store.state.offreEmploiFavorisState is FavoriListLoadedState<OffreEmploi>;
  }
}

class OffreEmploiRelevantFavorisExtractor extends RelevantFavorisExtractor<OffreEmploi> {
  @override
  List<OffreEmploi>? getRelevantFavoris(Store<AppState> store) {
    final state = store.state.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>;
    return state.data?.values.toList();
  }

  @override
  bool isDataInitialized(Store<AppState> store) {
    return store.state.offreEmploiFavorisState is FavoriListLoadedState<OffreEmploi>;
  }
}

class ImmersionRelevantFavorisExtractor extends RelevantFavorisExtractor<Immersion> {
  @override
  List<Immersion>? getRelevantFavoris(Store<AppState> store) {
    final state = store.state.immersionFavorisState as FavoriListLoadedState<Immersion>;
    return state.data?.values.toList();
  }

  @override
  bool isDataInitialized(Store<AppState> store) {
    return store.state.immersionFavorisState is FavoriListLoadedState<Immersion>;
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

class ImmersionFavorisViewModelTransformer extends FavorisViewModelTransformer<Immersion, Immersion> {
  @override
  Immersion transform(Immersion favorisModel) {
    return favorisModel;
  }
}

class ServiceCiviqueRelevantFavorisExtractor extends RelevantFavorisExtractor<ServiceCivique> {
  @override
  List<ServiceCivique>? getRelevantFavoris(Store<AppState> store) {
    final state = store.state.serviceCiviqueFavorisState as FavoriListLoadedState<ServiceCivique>;
    return state.data?.values.toList();
  }

  @override
  bool isDataInitialized(Store<AppState> store) {
    return store.state.serviceCiviqueFavorisState is FavoriListLoadedState<ServiceCivique>;
  }
}

class ServiceCiviqueFavorisViewModelTransformer extends FavorisViewModelTransformer<ServiceCivique, ServiceCivique> {
  @override
  ServiceCivique transform(ServiceCivique favorisModel) {
    return favorisModel;
  }
}
