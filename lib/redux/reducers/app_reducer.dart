import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/chat_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/deep_link_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/login_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/reducers/search_location_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/requests/rendezvous_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import 'offre_emploi_favoris_reducer.dart';
import 'offre_emploi_reducer.dart';

final Reducer<List<Rendezvous>> rendezvousReducer = Reducer<List<Rendezvous>>();
final Reducer<List<Immersion>> immersionReducer = Reducer<List<Immersion>>();

AppState reducer(AppState current, dynamic action) {
  if (action is DeepLinkAction) {
    return deepLinkReducer(current, action);
  } else if (action is LoginAction) {
    return loginReducer(current, action);
  } else if (action is UserActionAction) {
    return userActionReducer(current, action);
  } else if (action is OffreEmploiAction) {
    return offreEmploiReducer(current, action);
  } else if (action is ChatAction) {
    return chatActionReducer(current, action);
  } else if (action is OffreEmploiDetailsAction) {
    return offreEmploiDetailsReducer(current, action);
  } else if (action is OffreEmploiFavorisAction) {
    return offreEmploiFavorisReducer(current, action);
  } else if (action is SearchLocationAction) {
    return searchLocationReducer(current, action);
  } else if (action is Action<RendezvousRequest, List<Rendezvous>>) {
    return current.copyWith(rendezvousState: rendezvousReducer.reduce(current.rendezvousState, action));
  } else if (action is Action<ImmersionRequest, List<Immersion>>) {
    return current.copyWith(immersionSearchState: immersionReducer.reduce(current.immersionSearchState, action));
  } else {
    return current;
  }
}
