import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/actions/immersion_search_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/chat_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/deep_link_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/immersion_search_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/login_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/rendezvous_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/search_location_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import 'offre_emploi_favoris_reducer.dart';
import 'offre_emploi_reducer.dart';

AppState reducer(AppState currentState, dynamic action) {
  if (action is DeepLinkAction) {
    return deepLinkReducer(currentState, action);
  } else if (action is LoginAction) {
    return loginReducer(currentState, action);
  } else if (action is UserActionAction) {
    return userActionReducer(currentState, action);
  } else if (action is RendezvousAction) {
    return rendezvousReducer(currentState, action);
  } else if (action is OffreEmploiAction) {
    return offreEmploiReducer(currentState, action);
  } else if (action is ChatAction) {
    return chatActionReducer(currentState, action);
  } else if (action is OffreEmploiDetailsAction) {
    return offreEmploiDetailsReducer(currentState, action);
  } else if (action is OffreEmploiFavorisAction) {
    return offreEmploiFavorisReducer(currentState, action);
  } else if (action is SearchLocationAction) {
    return searchLocationReducer(currentState, action);
  } else if (action is ImmersionSearchAction) {
    return immersionSearchReducer(currentState, action);
  } else {
    return currentState;
  }
}