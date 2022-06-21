import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

AppState givenState() => AppState.initialState();

extension AppStateDSL on AppState {
  Store<AppState> store([Function(TestStoreFactory)? foo]) {
    final factory = TestStoreFactory();
    if (foo != null) foo(factory);
    return factory.initializeReduxStore(initialState: this);
  }

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

  AppState piecesJointesWithIdOneSuccess() =>
      copyWith(piecesJointesState: PiecesJointesState({"id-1": PieceJointeSuccessStatus()}));

  AppState piecesJointesLoading(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeLoadingStatus()}));

  AppState piecesJointesFailure(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeFailureStatus()}));

  AppState piecesJointesUnavailable(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeUnavailableStatus()}));

  AppState shareSheetNotInit() => copyWith(shareFileState: ShareFileNotInitializedState());

  AppState shareSheet(String path) => copyWith(shareFileState: ShareFileSuccessState(path));

  AppState deeplinkToRendezvous(String id) {
    return copyWith(deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now(), id));
  }

  AppState searchDemarchesSuccess(List<DemarcheDuReferentiel> demarches) {
    return copyWith(searchDemarcheState: SearchDemarcheSuccessState(demarches));
  }
}
