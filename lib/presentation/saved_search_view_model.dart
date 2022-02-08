import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum CreateSavedSearchDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

typedef OffreEmploiSavedSearchViewModel = SavedSearchViewModel<OffreEmploiSavedSearch>;
typedef ImmersionSavedSearchViewModel = SavedSearchViewModel<ImmersionSavedSearch>;

class SavedSearchViewModel<SAVED_SEARCH_MODEL> extends Equatable {
  final Function(String? title) createSavedSearch;
  final CreateSavedSearchDisplayState displayState;
  final SAVED_SEARCH_MODEL searchModel;

  SavedSearchViewModel._({
    required this.displayState,
    required this.createSavedSearch,
    required this.searchModel,
  });

  factory SavedSearchViewModel.create(Store<AppState> store, AbstractSearchExtractor<SAVED_SEARCH_MODEL> search) {
    return SavedSearchViewModel._(
        searchModel: search.getSearchFilters(store),
        displayState: _displayState(store.state.offreEmploiSavedSearchState),
        createSavedSearch: (title) => store.dispatch(
              RequestPostSavedSearchAction(search.getSearchFilters(store)),
            )
        // withError: _withError(offerId, store.state.savedSearchUpdateState),
        // withLoading: _withLoading(offerId, store.state.savedSearchUpdateState),
        );
  }

  static OffreEmploiSavedSearchViewModel createForOffreEmploi(Store<AppState> store, {required bool onlyAlternance}) {
    return SavedSearchViewModel.create(
      store,
      onlyAlternance ? AlternanceSearchExtractor() : OffreEmploiSearchExtractor(),
    );
  }

  static ImmersionSavedSearchViewModel createForImmersion(Store<AppState> store) {
    return SavedSearchViewModel.create(
      store,
      ImmersionSearchExtractor(),
    );
  }

  @override
  List<Object?> get props => [displayState, createSavedSearch];
}

CreateSavedSearchDisplayState _displayState(SavedSearchState savedSearchCreateState) {
  if (savedSearchCreateState is SavedSearchNotInitialized) {
    return CreateSavedSearchDisplayState.SHOW_CONTENT;
  } else if (savedSearchCreateState is SavedSearchLoadingState) {
    return CreateSavedSearchDisplayState.SHOW_LOADING;
  } else if (savedSearchCreateState is SavedSearchSuccessfullyCreated) {
    return CreateSavedSearchDisplayState.TO_DISMISS;
  } else {
    return CreateSavedSearchDisplayState.SHOW_ERROR;
  }
}

abstract class AbstractSearchExtractor<SAVED_SEARCH_MODEL> {
  SAVED_SEARCH_MODEL getSearchFilters(Store<AppState> store);
}

class AlternanceSearchExtractor extends AbstractSearchExtractor<OffreEmploiSavedSearch> {
  @override
  OffreEmploiSavedSearch getSearchFilters(Store<AppState> store) {
    final state = store.state.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState;
    final eMetier = state.keywords;
    final eLocation = state.location;
    String _title = _setTitleForOffer(eMetier, eLocation?.libelle);
    return OffreEmploiSavedSearch(
      title: _title,
      metier: state.keywords,
      location: state.location,
      keywords: state.keywords,
      isAlternance: state.onlyAlternance,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: state.filtres.distance,
        experience: state.filtres.experience,
        duree: state.filtres.duree,
        contrat: state.filtres.contrat,
      ),
    );
  }

  String _setTitleForOffer(String? metier, String? location) {
    if (_stringWithValue(metier) && _stringWithValue(location))
      return Strings.savedSearchTitleField(metier, location);
    else if (_stringWithValue(metier))
      return metier!;
    else if (_stringWithValue(location)) return location!;
    return "";
  }

  bool _stringWithValue(String? str) => str != null && str.isNotEmpty;
}

class OffreEmploiSearchExtractor extends AbstractSearchExtractor<OffreEmploiSavedSearch> {
  @override
  OffreEmploiSavedSearch getSearchFilters(Store<AppState> store) {
    final state = store.state.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState;
    final eMetier = state.keywords;
    final eLocation = state.location;
    String _title = _setTitleForOffer(eMetier, eLocation?.libelle);
    return OffreEmploiSavedSearch(
      title: _title,
      metier: eMetier,
      location: eLocation,
      keywords: eMetier,
      isAlternance: state.onlyAlternance,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: state.filtres.distance,
        experience: state.filtres.experience,
        duree: state.filtres.duree,
        contrat: state.filtres.contrat,
      ),
    );
  }

  String _setTitleForOffer(String? metier, String? location) {
    if (_stringWithValue(metier) && _stringWithValue(location))
      return Strings.savedSearchTitleField(metier, location);
    else if (_stringWithValue(metier))
      return metier!;
    else if (_stringWithValue(location)) return location!;
    return "";
  }

  bool _stringWithValue(String? str) => str != null && str.isNotEmpty;
}

class ImmersionSearchExtractor extends AbstractSearchExtractor<ImmersionSavedSearch> {
  @override
  ImmersionSavedSearch getSearchFilters(Store<AppState> store) {
    final state = store.state.immersionSearchState;
    final iMetier = state.getResultOrThrow().first.metier;
    final iLocation = state.getResultOrThrow().first.ville;
    return ImmersionSavedSearch(
      title: Strings.savedSearchTitleField(iMetier, iLocation),
      metier: iMetier,
      location: iLocation,
      filters: ImmersionSearchParametersFilters.withoutFilters(),
    );
  }
}
