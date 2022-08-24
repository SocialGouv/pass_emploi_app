import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarhce_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/tutorial.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../utils/test_setup.dart';

AppState givenState([Configuration? configuration]) => AppState.initialState(configuration: configuration);

extension AppStateDSL on AppState {
  Store<AppState> store([Function(TestStoreFactory)? foo]) {
    final factory = TestStoreFactory();
    if (foo != null) foo(factory);
    return factory.initializeReduxStore(initialState: this);
  }

  StoreSpy spyStore() => StoreSpy.withState(this);

  AppState loggedInUser() => copyWith(loginState: successMiloUserState());

  AppState deepLink(DeepLinkState deepLinkState) => copyWith(deepLinkState: deepLinkState);

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
    return copyWith(deepLinkState: DetailRendezvousDeepLinkState(idRendezvous: id));
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

  AppState showTutorial() {
    return copyWith(tutorialState: ShowTutorialState(Tutorial.milo));
  }

  AppState partageActiviteSuccess({required bool favori}) {
    return copyWith(partageActiviteState: PartageActiviteSuccessState(mockPartageActivite(favoriShared: favori)));
  }

  AppState partageActiviteLoading() {
    return copyWith(partageActiviteState: PartageActiviteLoadingState());
  }

  AppState partageActiviteFailure() {
    return copyWith(partageActiviteState: PartageActiviteFailureState());
  }

  AppState partageActiviteUpdateSuccess({required bool favori}) {
    return copyWith(partageActiviteUpdateState: PartageActiviteUpdateSuccessState(favori));
  }

  AppState partageActiviteUpdateLoading() {
    return copyWith(partageActiviteUpdateState: PartageActiviteUpdateLoadingState());
  }

  AppState partageActiviteUpdateFailure() {
    return copyWith(partageActiviteUpdateState: PartageActiviteUpdateFailureState());
  }

  AppState showRating() {
    return copyWith(ratingState: ShowRatingState());
  }

  AppState dontShowRating() {
    return copyWith(ratingState: RatingNotInitializedState());
  }

  AppState actionWithComments() {
    return copyWith(actionCommentaireListState: ActionCommentaireListSuccessState(mockCommentaires()));
  }

  AppState actionWithoutComments() {
    return copyWith(actionCommentaireListState: ActionCommentaireListSuccessState([]));
  }

  AppState actionCommentsFailureState() {
    return copyWith(actionCommentaireListState: ActionCommentaireListFailureState());
  }

  AppState actionCommentsLoadingState() {
    return copyWith(actionCommentaireListState: ActionCommentaireListLoadingState());
  }

  AppState actionCommentsNotInitState() {
    return copyWith(actionCommentaireListState: ActionCommentaireListNotInitializedState());
  }

  AppState createCommentSuccessState() {
    return copyWith(actionCommentaireCreateState: ActionCommentaireCreateSuccessState());
  }

  AppState createCommentFailureState([String? comment]) {
    return copyWith(actionCommentaireCreateState: ActionCommentaireCreateFailureState(comment ?? ""));
  }

  AppState createCommentLoadingState() {
    return copyWith(actionCommentaireCreateState: ActionCommentaireCreateLoadingState());
  }

  AppState createCommentNotInitState() {
    return copyWith(actionCommentaireCreateState: ActionCommentaireCreateNotInitializedState());
  }

  AppState withDemarches(List<Demarche> demarches) {
    return copyWith(demarcheListState: DemarcheListSuccessState(demarches, true));
  }

  AppState updateDemarcheSuccess() {
    return copyWith(updateDemarcheState: UpdateDemarcheSuccessState());
  }

  AppState updateDemarcheLoading() {
    return copyWith(updateDemarcheState: UpdateDemarcheLoadingState());
  }

  AppState updateDemarcheFailure() {
    return copyWith(updateDemarcheState: UpdateDemarcheFailureState());
  }
}
