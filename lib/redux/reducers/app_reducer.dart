import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/chat_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/deep_link_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/favoris_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/login_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/reducers/search_location_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import 'favoris_update_reducer.dart';
import 'offre_emploi_reducer.dart';

final Reducer<List<Rendezvous>> _rendezvousReducer = Reducer<List<Rendezvous>>();
final Reducer<List<Immersion>> _immersionReducer = Reducer<List<Immersion>>();
final Reducer<ImmersionDetails> _immersionDetailsReducer = Reducer<ImmersionDetails>();
final LoginReducer _loginReducer = LoginReducer();
final OffreEmploiDetailsReducer _offreEmploiDetailsReducer = OffreEmploiDetailsReducer();
final FavorisReducer<OffreEmploi> _offreEmploiFavorisReducer = FavorisReducer<OffreEmploi>();
final FavorisUpdateReducer _favorisUpdateReducer = FavorisUpdateReducer();

AppState reducer(AppState current, dynamic action) {
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
  } else if (action is OffreEmploiFavorisAction) {
    return current.copyWith(
      offreEmploiFavorisState: _offreEmploiFavorisReducer.reduceFavorisState(current.offreEmploiFavorisState, action),
      favorisUpdateState: _favorisUpdateReducer.reduceUpdateState(current.favorisUpdateState, action),
    );
  } else if (action is SearchLocationAction) {
    return searchLocationReducer(current, action);
  } else if (action is RendezvousAction) {
    return current.copyWith(rendezvousState: _rendezvousReducer.reduce(current.rendezvousState, action));
  } else if (action is ImmersionAction) {
    return current.copyWith(immersionSearchState: _immersionReducer.reduce(current.immersionSearchState, action));
  } else if (action is ImmersionDetailsAction) {
    return current.copyWith(
      immersionDetailsState: _immersionDetailsReducer.reduce(current.immersionDetailsState, action),
    );
  } else {
    return current;
  }
}
