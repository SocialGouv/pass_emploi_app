import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/message.dart';
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
      copyWith(piecesJointesState: PiecesJointesState({"id-1": PieceJointeStatus.success}));

  AppState piecesJointesLoading(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeStatus.loading}));

  AppState piecesJointesFailure(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeStatus.failure}));

  AppState piecesJointesUnavailable(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeStatus.unavailable}));

  AppState previewFileNotInit() => copyWith(previewFileState: PreviewFileNotInitializedState());

  AppState previewFile(String path) => copyWith(previewFileState: PreviewFileSuccessState(path));

  AppState chatBrouillon(String message) => copyWith(chatBrouillonState: ChatBrouillonState(message));

  AppState deeplinkToRendezvous(String id) {
    return copyWith(deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now(), id));
  }

  AppState searchDemarchesSuccess(List<DemarcheDuReferentiel> demarches) {
    return copyWith(searchDemarcheState: SearchDemarcheSuccessState(demarches));
  }

  AppState chatSuccess(List<Message> messages) {
    return copyWith(chatState: ChatSuccessState(messages));
  }

  AppState offreEmploiDetailsSuccess() {
    return copyWith(offreEmploiDetailsState: OffreEmploiDetailsSuccessState(mockOffreEmploiDetails()));
  }
}
