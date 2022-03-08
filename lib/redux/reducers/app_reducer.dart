import 'package:pass_emploi_app/features/chat/messages/chat_reducer.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_reducer.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_reducer.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_reducer.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_reducer.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_reducer.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_reducer.dart';
import 'package:pass_emploi_app/features/location/search_location_reducer.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_reducer.dart';
import 'package:pass_emploi_app/features/metier/search_metier_reducer.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_reducer.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_reducer.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_reducer.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_reducer.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_reducer.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_reducer.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_reducer.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_reducer.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';

import '../../features/favori/update/favori_update_reducer.dart';
import '../../features/service_civique/detail/service_civique_detail_reducer.dart';

AppState reducer(AppState current, dynamic action) {
  if (action is RequestLogoutAction) {
    return AppState.initialState(configuration: current.configurationState.configuration);
  }
  return AppState(
    configurationState: current.configurationState,
    userActionListState: userActionListReducer(current.userActionListState, action),
    userActionCreateState: userActionCreateReducer(current.userActionCreateState, action),
    userActionUpdateState: userActionUpdateReducer(current.userActionUpdateState, action),
    userActionDeleteState: userActionDeleteReducer(current.userActionDeleteState, action),
    chatStatusState: chatStatusReducer(current.chatStatusState, action),
    chatState: chatReducer(current.chatState, action),
    offreEmploiSearchState: offreEmploiSearchReducer(current.offreEmploiSearchState, action),
    deepLinkState: deepLinkReducer(current.deepLinkState, action),
    offreEmploiListState: offreEmploiListReducer(current.offreEmploiListState, action),
    offreEmploiSearchParametersState: _offreEmploiSearchParametersState(
      current.offreEmploiSearchParametersState,
      action,
    ),
    offreEmploiDetailsState: offreEmploiDetailsReducer(current.offreEmploiDetailsState, action),
    offreEmploiFavorisState: FavoriListReducer<OffreEmploi>().reduceFavorisState(
      current.offreEmploiFavorisState,
      action,
    ),
    immersionFavorisState: FavoriListReducer<Immersion>().reduceFavorisState(current.immersionFavorisState, action),
    favoriUpdateState: favoriUpdateReducer(current.favoriUpdateState, action),
    searchLocationState: searchLocationReducer(current.searchLocationState, action),
    searchMetierState: searchMetierReducer(current.searchMetierState, action),
    loginState: loginReducer(current.loginState, action),
    rendezvousState: rendezvousReducer(current.rendezvousState, action),
    immersionSearchRequestState: immersionSearchReducer(current.immersionSearchRequestState, action),
    immersionListState: immersionListReducer(current.immersionListState, action),
    immersionDetailsState: immersionDetailsReducer(current.immersionDetailsState, action),
    offreEmploiSavedSearchCreateState: savedSearchCreateReducer<OffreEmploiSavedSearch>(
      current.offreEmploiSavedSearchCreateState,
      action,
    ),
    immersionSavedSearchCreateState: savedSearchCreateReducer<ImmersionSavedSearch>(
      current.immersionSavedSearchCreateState,
      action,
    ),
    savedSearchListState: savedSearchListReducer(current.savedSearchListState, action),
    savedSearchDeleteState: savedSearchDeleteReducer(current.savedSearchDeleteState, action),
    serviceCiviqueSearchResultState: serviceCiviqueReducer(current.serviceCiviqueSearchResultState, action),
    serviceCiviqueDetailState: serviceCiviqueDetailReducer(current.serviceCiviqueDetailState, action),
  );
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
  } else if (action is OffreEmploiSearchRequestAction) {
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
