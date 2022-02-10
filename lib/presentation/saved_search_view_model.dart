import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum CreateSavedSearchDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

typedef OffreEmploiSavedSearchViewModel = SavedSearchViewModel<OffreEmploiSavedSearch>;

typedef ImmersionSavedSearchViewModel = SavedSearchViewModel<ImmersionSavedSearch>;

class SavedSearchViewModel<SAVED_SEARCH_MODEL> extends Equatable {
  final Function(String title) createSavedSearch;
  final CreateSavedSearchDisplayState displayState;
  final SAVED_SEARCH_MODEL searchModel;
  final bool Function() savingFailure;

  SavedSearchViewModel._({
    required this.displayState,
    required this.createSavedSearch,
    required this.searchModel,
    required this.savingFailure,
  });

  factory SavedSearchViewModel._create(
      Store<AppState> store, AbstractSearchExtractor<SAVED_SEARCH_MODEL> search, bool isImmersion) {
    return SavedSearchViewModel._(
      searchModel: search.getSearchFilters(store),
      displayState:
          _displayState(isImmersion ? store.state.immersionSavedSearchState : store.state.offreEmploiSavedSearchState),
      createSavedSearch: (title) => store.dispatch(RequestPostSavedSearchAction(search.getSearchFilters(store), title)),
      savingFailure: () => search.isFailureState(store),
    );
  }

  static OffreEmploiSavedSearchViewModel createForOffreEmploi(Store<AppState> store, {required bool onlyAlternance}) {
    return SavedSearchViewModel._create(
      store,
      OffreEmploiSearchExtractor(),
      false,
    );
  }

  static ImmersionSavedSearchViewModel createForImmersion(Store<AppState> store) {
    return SavedSearchViewModel._create(
      store,
      ImmersionSearchExtractor(),
      true,
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

  bool isFailureState(Store<AppState> store);
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

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.offreEmploiSavedSearchState is SavedSearchFailureState;
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
    final state = store.state.immersionSearchState.getResultOrThrow().first;
    final requestState = store.state.immersionSearchRequestState as RequestedImmersionSearchRequestState;
    final iMetier = state.metier;
    final iLocation = state.ville;
    return ImmersionSavedSearch(
      title: Strings.savedSearchTitleField(iMetier, iLocation),
      metier: iMetier,
      location: iLocation,
      filters: ImmersionSearchParametersFilters.withFilters(
        codeRome: requestState.codeRome,
        lat: requestState.latitude,
        lon: requestState.longitude,
      ),
    );
  }

  @override
  bool isFailureState(Store<AppState> store) {
    return store.state.immersionSavedSearchState is SavedSearchFailureState;
  }
}
