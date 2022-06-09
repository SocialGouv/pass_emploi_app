import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

AppState givenState() => AppState.initialState();

extension AppStateDSL on AppState {
  Store<AppState> store() => TestStoreFactory().initializeReduxStore(initialState: this);

  AppState loggedInUser() => copyWith(loginState: successMiloUserState());

  AppState loggedInMiloUser() => copyWith(loginState: successMiloUserState());

  AppState loggedInPoleEmploiUser() => copyWith(loginState: successPoleEmploiUserState());

  AppState rendezvous(List<Rendezvous> rendezvous) => copyWith(rendezvousState: RendezvousState.successful(rendezvous));

  AppState rendezvousNotInitialized() => copyWith(rendezvousState: RendezvousState.notInitialized());

  AppState loadingFutureRendezvous() => copyWith(rendezvousState: RendezvousState.loadingFuture());

  AppState failedFutureRendezvous() => copyWith(rendezvousState: RendezvousState.failedFuture());

  AppState loadingPastRendezvous() => copyWith(rendezvousState: RendezvousState.loadingPast());

  AppState failedPastRendezvous() => copyWith(rendezvousState: RendezvousState.failedPast());

  AppState campagne(Campagne campagne) => copyWith(campagneState: CampagneState(campagne, []));

  AppState attachedFilesWithIdOneSuccess() =>
      copyWith(attachedFilesState: AttachedFilesState({"id-1": AttachedFileSuccessStatus("id-1-path")}));

  AppState deeplinkToRendezvous(String id) =>
      copyWith(deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now(), id));
}
