import 'package:pass_emploi_app/features/chat/messages/chat_reducer.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_reducer.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_reducer.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_reducer.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_reducer.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_reducer.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_reducer.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_reducer.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_reducer.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/actions/search_metier_action.dart';
import 'package:pass_emploi_app/redux/reducers/deep_link_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/favoris/favoris_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/immersion_details_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/reducers/saved_search/saved_search_reducer.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/configuration_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/redux/states/search_metier_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../features/service_civique/detail/service_civique_detail_reducer.dart';
import 'favoris/favoris_update_reducer.dart';

AppState reducer(AppState current, dynamic action) {
  if (action is RequestLogoutAction) {
    return AppState.initialState(configuration: current.configurationState.configuration);
  }
  return AppState(
    userActionListState: userActionListReducer(current.userActionListState, action),
    userActionCreateState: userActionCreateReducer(current.userActionCreateState, action),
    userActionUpdateState: userActionUpdateReducer(current.userActionUpdateState, action),
    userActionDeleteState: userActionDeleteReducer(current.userActionDeleteState, action),
    chatStatusState: chatStatusReducer(current.chatStatusState, action),
    chatState: chatReducer(current.chatState, action),
    offreEmploiSearchState: _offreEmploiSearchState(current.offreEmploiSearchState, action),
    deepLinkState: _deepLinkState(current.deepLinkState, action),
    offreEmploiSearchResultsState: _offreEmploiSearchResultsState(current.offreEmploiSearchResultsState, action),
    offreEmploiSearchParametersState:
        _offreEmploiSearchParametersState(current.offreEmploiSearchParametersState, action),
    offreEmploiDetailsState: offreEmploiDetailsReducer(current.offreEmploiDetailsState, action),
    offreEmploiFavorisState: _offreEmploiFavorisState(current.offreEmploiFavorisState, action),
    immersionFavorisState: _immersionFavorisState(current.immersionFavorisState, action),
    favorisUpdateState: _favorisUpdateState(current.favorisUpdateState, action),
    searchLocationState: _searchLocationState(current.searchLocationState, action),
    searchMetierState: _searchMetierState(current.searchMetierState, action),
    loginState: loginReducer(current.loginState, action),
    rendezvousState: rendezvousReducer(current.rendezvousState, action),
    immersionSearchState: _immersionSearchState(current.immersionSearchState, action),
    immersionDetailsState: _immersionDetailsState(current.immersionDetailsState, action),
    offreEmploiSavedSearchState: _offreEmploiSavedSearchState(current.offreEmploiSavedSearchState, action),
    immersionSavedSearchState: _immersionSavedSearchState(current.immersionSavedSearchState, action),
    configurationState: _configurationState(current.configurationState, action),
    immersionSearchRequestState: _immersionSearchRequestState(current.immersionSearchRequestState, action),
    savedSearchListState: savedSearchListReducer(current.savedSearchListState, action),
    savedSearchDeleteState: savedSearchDeleteReducer(current.savedSearchDeleteState, action),
    serviceCiviqueSearchResultState: serviceCiviqueReducer(current.serviceCiviqueSearchResultState, action),
    serviceCiviqueDetailState: serviceCiviqueDetailReducer(current.serviceCiviqueDetailState, action),
  );
}

OffreEmploiSearchState _offreEmploiSearchState(OffreEmploiSearchState current, dynamic action) {
  if (action is OffreEmploiSearchLoadingAction) {
    return OffreEmploiSearchState.loading();
  } else if (action is OffreEmploiResetResultsAction) {
    return OffreEmploiSearchState.notInitialized();
  } else if (action is OffreEmploiSearchSuccessAction) {
    return OffreEmploiSearchState.success();
  } else if (action is OffreEmploiSearchWithUpdateFiltresSuccessAction) {
    return OffreEmploiSearchState.success();
  } else if (action is OffreEmploiSearchFailureAction) {
    return OffreEmploiSearchState.failure();
  } else if (action is OffreEmploiSearchWithUpdateFiltresFailureAction) {
    return OffreEmploiSearchState.failure();
  } else {
    return current;
  }
}

DeepLinkState _deepLinkState(DeepLinkState current, dynamic action) {
  if (action is GetSavedSearchAction) {
    return DeepLinkState.used();
  } else if (action is ResetDeeplinkAction) {
    return DeepLinkState.used();
  } else if (action is DeepLinkAction) {
    return deepLinkReducer(action);
  } else {
    return current;
  }
}

OffreEmploiSearchResultsState _offreEmploiSearchResultsState(OffreEmploiSearchResultsState current, dynamic action) {
  if (action is OffreEmploiResetResultsAction) {
    return OffreEmploiSearchResultsState.notInitialized();
  } else if (action is OffreEmploiSearchSuccessAction) {
    if (current is OffreEmploiSearchResultsDataState) {
      return OffreEmploiSearchResultsState.data(
        offres: current.offres + action.offres,
        loadedPage: action.page,
        isMoreDataAvailable: action.isMoreDataAvailable,
      );
    } else {
      return OffreEmploiSearchResultsState.data(
        offres: action.offres,
        loadedPage: action.page,
        isMoreDataAvailable: action.isMoreDataAvailable,
      );
    }
  } else if (action is OffreEmploiSearchWithUpdateFiltresSuccessAction) {
    return OffreEmploiSearchResultsState.data(
      offres: action.offres,
      loadedPage: action.page,
      isMoreDataAvailable: action.isMoreDataAvailable,
    );
  } else {
    return current;
  }
}

OffreEmploiSearchParametersState _offreEmploiSearchParametersState(
  OffreEmploiSearchParametersState current,
  dynamic action,
) {
  if (action is OffreEmploiSearchWithFiltresAction) {
    return OffreEmploiSearchParametersState.initialized(
      keywords: action.keywords,
      location: action.location,
      onlyAlternance: action.onlyAlternance,
      filtres: action.updatedFiltres,
    );
  } else if (action is SearchOffreEmploiAction) {
    return OffreEmploiSearchParametersInitializedState(
      keywords: action.keywords,
      location: action.location,
      onlyAlternance: action.onlyAlternance,
      filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
    );
  } else if (action is OffreEmploiSearchUpdateFiltresAction) {
    if (current is OffreEmploiSearchParametersInitializedState) {
      return OffreEmploiSearchParametersInitializedState(
        keywords: current.keywords,
        location: current.location,
        onlyAlternance: current.onlyAlternance,
        filtres: action.updatedFiltres,
      );
    } else {
      return current;
    }
  } else if (action is OffreEmploiSearchWithUpdateFiltresFailureAction) {
    if (current is OffreEmploiSearchParametersInitializedState) {
      return OffreEmploiSearchParametersState.initialized(
        keywords: current.keywords,
        location: current.location,
        onlyAlternance: current.onlyAlternance,
        filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
      );
    } else {
      return current;
    }
  } else {
    return current;
  }
}

FavorisState<OffreEmploi> _offreEmploiFavorisState(FavorisState<OffreEmploi> current, dynamic action) {
  if (action is FavorisAction<OffreEmploi>) {
    return FavorisReducer<OffreEmploi>().reduceFavorisState(current, action);
  } else {
    return current;
  }
}

FavorisState<Immersion> _immersionFavorisState(FavorisState<Immersion> current, dynamic action) {
  if (action is FavorisAction<Immersion>) {
    return FavorisReducer<Immersion>().reduceFavorisState(current, action);
  } else {
    return current;
  }
}

FavorisUpdateState _favorisUpdateState(FavorisUpdateState current, dynamic action) {
  if (action is FavorisAction) {
    return FavorisUpdateReducer().reduceUpdateState(current, action);
  } else {
    return current;
  }
}

SearchLocationState _searchLocationState(SearchLocationState current, dynamic action) {
  if (action is SearchLocationsSuccessAction) {
    return SearchLocationState(action.locations);
  } else if (action is ResetLocationAction) {
    return SearchLocationState([]);
  } else {
    return current;
  }
}

SearchMetierState _searchMetierState(SearchMetierState current, dynamic action) {
  if (action is SearchMetierSuccessAction) {
    return SearchMetierState(action.metiers);
  } else if (action is ResetMetierAction) {
    return SearchMetierState([]);
  } else {
    return current;
  }
}

State<List<Immersion>> _immersionSearchState(State<List<Immersion>> current, dynamic action) {
  if (action is ImmersionAction) {
    return Reducer<List<Immersion>>().reduce(current, action);
  } else {
    return current;
  }
}

State<ImmersionDetails> _immersionDetailsState(State<ImmersionDetails> current, dynamic action) {
  if (action is ImmersionDetailsAction) {
    return ImmersionDetailsReducer().reduce(current, action);
  } else {
    return current;
  }
}

SavedSearchState<OffreEmploiSavedSearch> _offreEmploiSavedSearchState(
    SavedSearchState<OffreEmploiSavedSearch> current, dynamic action) {
  if (action is SavedSearchAction<OffreEmploiSavedSearch>) {
    return SavedSearchReducer<OffreEmploiSavedSearch>().reduceSavedSearchState(current, action);
  } else {
    return current;
  }
}

SavedSearchState<ImmersionSavedSearch> _immersionSavedSearchState(
    SavedSearchState<ImmersionSavedSearch> current, dynamic action) {
  if (action is SavedSearchAction<ImmersionSavedSearch>) {
    return SavedSearchReducer<ImmersionSavedSearch>().reduceSavedSearchState(current, action);
  } else {
    return current;
  }
}

ConfigurationState _configurationState(ConfigurationState current, dynamic action) {
  return current;
}

ImmersionSearchRequestState _immersionSearchRequestState(ImmersionSearchRequestState current, dynamic action) {
  if (action is ImmersionAction && action.isRequest()) {
    final ImmersionRequest request = action.getRequestOrThrow();
    return RequestedImmersionSearchRequestState(
      codeRome: request.codeRome,
      ville: request.location.libelle,
      latitude: request.location.latitude ?? 0,
      longitude: request.location.longitude ?? 0,
    );
  } else {
    return current;
  }
}
