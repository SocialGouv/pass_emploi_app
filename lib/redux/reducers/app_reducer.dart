import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/actions/search_metier_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/chat_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/deep_link_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/favoris/favoris_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/immersion_details_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/login_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/reducers/saved_search/saved_search_delete_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/saved_search/saved_search_list_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/saved_search/saved_search_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/search_location_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/search_metier_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../models/saved_search/saved_search.dart';
import 'favoris/favoris_update_reducer.dart';
import 'offre_emploi_reducer.dart';

final _rendezvousReducer = Reducer<List<Rendezvous>>();
final _immersionReducer = Reducer<List<Immersion>>();
final _immersionDetailsReducer = ImmersionDetailsReducer();
final _loginReducer = LoginReducer();
final _offreEmploiDetailsReducer = OffreEmploiDetailsReducer();
final _offreEmploiFavorisReducer = FavorisReducer<OffreEmploi>();
final _immersionFavorisReducer = FavorisReducer<Immersion>();
final _favorisUpdateReducer = FavorisUpdateReducer();
final _offreEmploiSavedSearchReducer = SavedSearchReducer<OffreEmploiSavedSearch>();
final _immersionSavedSearchReducer = SavedSearchReducer<ImmersionSavedSearch>();
final _savedSearchListReducer = SavedSearchListReducer();
final _savedSearchDeleteReducer = SavedSearchDeleteReducer();

State<List<SavedSearch>> _updateSavedSearchListIfNeeded(SavedSearchAction<SavedSearch> action, AppState current) {
  if (action is SavedSearchSuccessAction<SavedSearch> && current.savedSearchesState.isSuccess()) {
    final List<SavedSearch> newList = current.savedSearchesState.getResultOrThrow();
    newList.add(action.search);
    return State.success(newList);
  } else {
    return current.savedSearchesState;
  }
}

AppState reducer(AppState current, dynamic action) {
  if (action is GetSavedSearchAction) {
    return current.copyWith(deepLinkState: DeepLinkState.used());
  }
  if (action is DeepLinkAction) {
    return deepLinkReducer(current, action);
  } else if (action is LoginAction) {
    return _loginReducer.reduce(current, action);
  } else if (action is UserActionAction) {
    return userActionReducer(current, action);
  } else if (action is OffreEmploiAction) {
    return offreEmploiReducer(current, action);
  } else if (action is ChatAction) {
    return chatActionReducer(current, action);
  } else if (action is OffreEmploiDetailsAction) {
    return current.copyWith(
      offreEmploiDetailsState: _offreEmploiDetailsReducer.reduce(current.offreEmploiDetailsState, action),
    );
  } else if (action is FavorisAction<OffreEmploi>) {
    return current.copyWith(
      offreEmploiFavorisState: _offreEmploiFavorisReducer.reduceFavorisState(current.offreEmploiFavorisState, action),
      favorisUpdateState: _favorisUpdateReducer.reduceUpdateState(current.favorisUpdateState, action),
    );
  } else if (action is FavorisAction<Immersion>) {
    return current.copyWith(
      immersionFavorisState: _immersionFavorisReducer.reduceFavorisState(current.immersionFavorisState, action),
      favorisUpdateState: _favorisUpdateReducer.reduceUpdateState(current.favorisUpdateState, action),
    );
  } else if (action is SearchLocationAction) {
    return searchLocationReducer(current, action);
  } else if (action is SearchMetierAction) {
    return searchMetierReducer(current, action);
  } else if (action is RendezvousAction) {
    return current.copyWith(rendezvousState: _rendezvousReducer.reduce(current.rendezvousState, action));
  } else if (action is ImmersionAction) {
    RequestedImmersionSearchRequestState? immersionSearchRequestState;
    if (action.isRequest()) {
      final ImmersionRequest request = action.getRequestOrThrow();
      immersionSearchRequestState = RequestedImmersionSearchRequestState(
        codeRome: request.codeRome,
        ville: request.location.libelle,
        latitude: request.location.latitude ?? 0,
        longitude: request.location.longitude ?? 0,
      );
    }
    return current.copyWith(
      immersionSearchState: _immersionReducer.reduce(current.immersionSearchState, action),
      immersionSearchRequestState: immersionSearchRequestState,
    );
  } else if (action is ImmersionDetailsAction) {
    return current.copyWith(
      immersionDetailsState: _immersionDetailsReducer.reduce(current.immersionDetailsState, action),
    );
  } else if (action is SavedSearchAction<OffreEmploiSavedSearch>) {
    return current.copyWith(
      savedSearchesState: _updateSavedSearchListIfNeeded(action, current),
      offreEmploiSavedSearchState:
          _offreEmploiSavedSearchReducer.reduceSavedSearchState(current.offreEmploiSavedSearchState, action),
    );
  } else if (action is SavedSearchAction<ImmersionSavedSearch>) {
    return current.copyWith(
      savedSearchesState: _updateSavedSearchListIfNeeded(action, current),
      immersionSavedSearchState:
          _immersionSavedSearchReducer.reduceSavedSearchState(current.immersionSavedSearchState, action),
    );
  } else if (action is SavedSearchListAction) {
    return current.copyWith(savedSearchesState: _savedSearchListReducer.reduce(action));
  } else if (action is SavedSearchDeleteAction) {
    return _savedSearchDeleteReducer.reduce(current, action);
  } else {
    return current;
  }
}
