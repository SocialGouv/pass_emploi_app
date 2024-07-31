import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/cgu/cgu_state.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_state.dart';
import 'package:pass_emploi_app/features/cv/cv_state.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_state.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/cgu.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/feature_flip.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../utils/test_setup.dart';

AppState givenState([Configuration? configuration]) => AppState.initialState(configuration: configuration);

AppState givenPassEmploiState({Configuration? baseConfiguration}) {
  return AppState.initialState(configuration: baseConfiguration ?? passEmploiConfiguration()).loggedInPoleEmploiUser();
}

extension AppStateDSL on AppState {
  Store<AppState> store([Function(TestStoreFactory)? foo]) {
    final factory = TestStoreFactory();
    if (foo != null) foo(factory);
    return factory.initializeReduxStore(initialState: this);
  }

  StoreSpy spyStore() => StoreSpy.withState(this);

  AppState loggedIn() => copyWith(loginState: successMiloUserState());

  AppState loggedInUser({LoginMode loginMode = LoginMode.MILO, Accompagnement accompagnement = Accompagnement.cej}) {
    return copyWith(loginState: successUserState(loginMode: loginMode, accompagnement: accompagnement));
  }

  AppState loggedInMiloUser() => copyWith(loginState: successMiloUserState());

  AppState loggedInPoleEmploiUser() => copyWith(loginState: successPoleEmploiCejUserState());

  AppState withDeepLink(DeepLinkState deepLinkState) => copyWith(deepLinkState: deepLinkState);

  AppState withHandleDeepLink(DeepLink deepLink) => withDeepLink(HandleDeepLinkState(
        deepLink,
        DeepLinkOrigin.inAppNavigation,
      ));

  AppState withDemoMode() => copyWith(demoState: true);

  AppState withFeatureFlip({
    bool? useCvm,
    bool? usePj,
    bool? withCampagneRecrutement,
  }) {
    return copyWith(
      featureFlipState: FeatureFlipState(
        FeatureFlip.initial().copyWith(useCvm: useCvm, usePj: usePj, withCampagneRecrutement: withCampagneRecrutement),
      ),
    );
  }

  AppState withCampagne(Campagne campagne) => copyWith(campagneState: CampagneState(campagne, []));

  AppState piecesJointesWithIdOneSuccess() =>
      copyWith(piecesJointesState: PiecesJointesState({"id-1": PieceJointeStatus.success}, {"id-1": "path"}));

  AppState piecesJointesLoading(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeStatus.loading}, {}));

  AppState piecesJointesFailure(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeStatus.failure}, {}));

  AppState piecesJointesUnavailable(String id) =>
      copyWith(piecesJointesState: PiecesJointesState({id: PieceJointeStatus.unavailable}, {}));

  AppState previewFileNotInit() => copyWith(previewFileState: PreviewFileNotInitializedState());

  AppState previewFile(String path) => copyWith(previewFileState: PreviewFileSuccessState(path));

  AppState chatBrouillon(String message) => copyWith(chatBrouillonState: ChatBrouillonState(message));

  AppState deeplinkToRendezvous(String id) {
    return copyWith(
      deepLinkState: HandleDeepLinkState(
        RendezvousDeepLink(id),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }

  AppState deeplinkToSessionMilo(String id) {
    return copyWith(
      deepLinkState: HandleDeepLinkState(
        SessionMiloDeepLink(id),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }

  AppState searchDemarchesSuccess(List<DemarcheDuReferentiel> demarches) {
    return copyWith(searchDemarcheState: SearchDemarcheSuccessState(demarches));
  }

  AppState chatSuccess(List<Message> messages) {
    return copyWith(chatState: ChatSuccessState(messages));
  }

  AppState offreEmploiDetailsLoading() {
    return copyWith(offreEmploiDetailsState: OffreEmploiDetailsLoadingState());
  }

  AppState offreEmploiDetailsSuccess({OffreEmploiDetails? offreEmploiDetails}) {
    return copyWith(
        offreEmploiDetailsState: OffreEmploiDetailsSuccessState(offreEmploiDetails ?? mockOffreEmploiDetails()));
  }

  AppState offreEmploiDetailsIncompleteData({OffreEmploi? offreEmploi}) {
    return copyWith(offreEmploiDetailsState: OffreEmploiDetailsIncompleteDataState(offreEmploi ?? mockOffreEmploi()));
  }

  AppState offreEmploiDetailsFailure() {
    return copyWith(offreEmploiDetailsState: OffreEmploiDetailsFailureState());
  }

  AppState serviceCiviqueDetailsLoading() {
    return copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailLoadingState());
  }

  AppState serviceCiviqueDetailsNotInitialized() {
    return copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailNotInitializedState());
  }

  AppState serviceCiviqueDetailsSuccess({ServiceCiviqueDetail? serviceCiviqueDetail}) {
    return copyWith(
        serviceCiviqueDetailState:
            ServiceCiviqueDetailSuccessState(serviceCiviqueDetail ?? mockServiceCiviqueDetail()));
  }

  AppState serviceCiviqueDetailsFailure() {
    return copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailFailureState());
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

  AppState monSuivi({Interval? interval, MonSuivi? monSuivi}) {
    return copyWith(
      monSuiviState: MonSuiviSuccessState(
        interval ?? Interval(DateTime(2022), DateTime(2023)),
        monSuivi ?? mockMonSuivi(),
      ),
    );
  }

  AppState withPendingUserActions(int count) {
    return copyWith(userActionCreatePendingState: UserActionCreatePendingSuccessState(count));
  }

  AppState withDemarches(List<Demarche> demarches) {
    return monSuivi(monSuivi: mockMonSuivi(demarches: demarches));
  }

  AppState updateDemarcheNotInit() {
    return copyWith(updateDemarcheState: UpdateDemarcheNotInitializedState());
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

  AppState withActions(List<UserAction> actions) {
    return monSuivi(monSuivi: mockMonSuivi(actions: actions));
  }

  AppState withAction(UserAction action) {
    return copyWith(userActionDetailsState: UserActionDetailsSuccessState(action));
  }

  AppState updateActionNotInit() {
    return copyWith(userActionUpdateState: UserActionUpdateNotInitializedState());
  }

  AppState updateActionSuccess(UserActionUpdateRequest request) {
    return copyWith(userActionUpdateState: UserActionUpdateSuccessState(request));
  }

  AppState updateActionLoading() {
    return copyWith(userActionUpdateState: UserActionUpdateLoadingState());
  }

  AppState updateActionFailure() {
    return copyWith(userActionUpdateState: UserActionUpdateFailureState());
  }

  AppState deleteActionNotInit() {
    return copyWith(userActionDeleteState: UserActionDeleteNotInitializedState());
  }

  AppState deleteActionSuccess() {
    return copyWith(userActionDeleteState: UserActionDeleteSuccessState());
  }

  AppState deleteActionLoading() {
    return copyWith(userActionDeleteState: UserActionDeleteLoadingState());
  }

  AppState deleteActionFailure() {
    return copyWith(userActionDeleteState: UserActionDeleteFailureState());
  }

  AppState withSuggestionsRecherche() {
    return copyWith(suggestionsRechercheState: SuggestionsRechercheSuccessState(mockSuggestionsRecherche()));
  }

  AppState emptySuggestionsRecherche() {
    return copyWith(suggestionsRechercheState: SuggestionsRechercheSuccessState([]));
  }

  AppState loadingSuggestionsRecherche() {
    return copyWith(suggestionsRechercheState: SuggestionsRechercheLoadingState());
  }

  AppState failedSuggestionsRecherche() {
    return copyWith(suggestionsRechercheState: SuggestionsRechercheFailureState());
  }

  AppState loadingTraiterSuggestionRecherche() {
    return copyWith(traiterSuggestionRechercheState: TraiterSuggestionRechercheLoadingState());
  }

  AppState notInitTraiterSuggestionRecherche() {
    return copyWith(traiterSuggestionRechercheState: TraiterSuggestionRechercheNotInitializedState());
  }

  AppState succeedAccepterSuggestionRecherche() {
    return copyWith(
      traiterSuggestionRechercheState: AccepterSuggestionRechercheSuccessState(offreEmploiAlerte()),
    );
  }

  AppState succeedRefuserSuggestionRecherche() {
    return copyWith(traiterSuggestionRechercheState: RefuserSuggestionRechercheSuccessState());
  }

  AppState failedTraiterSuggestionRecherche() {
    return copyWith(traiterSuggestionRechercheState: TraiterSuggestionRechercheFailureState());
  }

  AppState succeedEventList({
    List<Rendezvous> animationsCollectives = const [],
    List<SessionMilo> sessionsMilo = const [],
  }) {
    return copyWith(eventListState: EventListSuccessState(animationsCollectives, sessionsMilo));
  }

  AppState initialRechercheEmploiState() {
    return copyWith(rechercheEmploiState: RechercheState.initial());
  }

  AppState initialLoadingRechercheEmploiState() {
    return copyWith(
      rechercheEmploiState: RechercheEmploiState.initial().copyWith(status: RechercheStatus.initialLoading),
    );
  }

  AppState updateLoadingRechercheEmploiState() {
    return copyWith(
      rechercheEmploiState: RechercheEmploiState.initial().copyWith(status: RechercheStatus.updateLoading),
    );
  }

  AppState failureRechercheEmploiState() {
    return copyWith(
      rechercheEmploiState: RechercheEmploiState.initial().copyWith(status: RechercheStatus.failure),
    );
  }

  AppState withRechercheEmploiState({
    RechercheStatus status = RechercheStatus.nouvelleRecherche,
    List<OffreEmploi>? results,
    RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>? request,
    bool canLoadMore = true,
  }) {
    return copyWith(
      rechercheEmploiState: RechercheEmploiState.initial().copyWith(
        status: status,
        request: () => request ?? initialRechercheEmploiRequest(),
        results: () => results ?? mockOffresEmploi10(),
        canLoadMore: canLoadMore,
      ),
    );
  }

  AppState rechercheEmploiStateWithRequest({
    RechercheStatus status = RechercheStatus.nouvelleRecherche,
    EmploiCriteresRecherche? criteres,
    EmploiFiltresRecherche? filtres,
  }) {
    return withRechercheEmploiState(
      status: status,
      request: RechercheRequest(
        criteres ??
            EmploiCriteresRecherche(
              location: null,
              keyword: '',
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
        filtres ?? EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );
  }

  AppState successRechercheEmploiState({
    List<OffreEmploi>? results,
    RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>? request,
    bool canLoadMore = true,
  }) {
    return withRechercheEmploiState(
      status: RechercheStatus.success,
      results: results,
      request: request,
      canLoadMore: canLoadMore,
    );
  }

  AppState successRechercheEmploiStateWithRequest({
    EmploiCriteresRecherche? criteres,
    EmploiFiltresRecherche? filtres,
  }) {
    return rechercheEmploiStateWithRequest(
      status: RechercheStatus.success,
      criteres: criteres,
      filtres: filtres,
    );
  }

  AppState initialRechercheServiceCiviqueState() {
    return copyWith(rechercheServiceCiviqueState: RechercheState.initial());
  }

  AppState initialLoadingRechercheServiceCiviqueState() {
    return copyWith(
      rechercheServiceCiviqueState:
          RechercheServiceCiviqueState.initial().copyWith(status: RechercheStatus.initialLoading),
    );
  }

  AppState updateLoadingRechercheServiceCiviqueState() {
    return copyWith(
      rechercheServiceCiviqueState:
          RechercheServiceCiviqueState.initial().copyWith(status: RechercheStatus.updateLoading),
    );
  }

  AppState failureRechercheServiceCiviqueState() {
    return copyWith(
      rechercheServiceCiviqueState: RechercheServiceCiviqueState.initial().copyWith(status: RechercheStatus.failure),
    );
  }

  AppState successRechercheServiceCiviqueState({
    List<ServiceCivique>? results,
    RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>? request,
    bool canLoadMore = true,
  }) {
    return copyWith(
      rechercheServiceCiviqueState: RechercheServiceCiviqueState.initial().copyWith(
        status: RechercheStatus.success,
        request: () => request ?? initialRechercheServiceCiviqueRequest(),
        results: () => results ?? mockOffresServiceCivique10(),
        canLoadMore: canLoadMore,
      ),
    );
  }

  AppState successRechercheServiceCiviqueStateWithRequest({
    ServiceCiviqueCriteresRecherche? criteres,
    ServiceCiviqueFiltresRecherche? filtres,
  }) {
    return successRechercheServiceCiviqueState(
      request: RechercheRequest(
        criteres ?? ServiceCiviqueCriteresRecherche(location: null),
        filtres ?? ServiceCiviqueFiltresRecherche.noFiltre(),
        1,
      ),
    );
  }

  AppState initialRechercheImmersionState() {
    return copyWith(rechercheImmersionState: RechercheState.initial());
  }

  AppState initialLoadingRechercheImmersionState() {
    return copyWith(
      rechercheImmersionState: RechercheImmersionState.initial().copyWith(status: RechercheStatus.initialLoading),
    );
  }

  AppState updateLoadingRechercheImmersionState() {
    return copyWith(
      rechercheImmersionState: RechercheImmersionState.initial().copyWith(status: RechercheStatus.updateLoading),
    );
  }

  AppState failureRechercheImmersionState() {
    return copyWith(
      rechercheImmersionState: RechercheImmersionState.initial().copyWith(status: RechercheStatus.failure),
    );
  }

  AppState successRechercheImmersionState({
    List<Immersion>? results,
    RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche>? request,
    bool canLoadMore = true,
  }) {
    return copyWith(
      rechercheImmersionState: RechercheImmersionState.initial().copyWith(
        status: RechercheStatus.success,
        request: () => request ?? initialRechercheImmersionRequest(),
        results: () => results ?? mockOffresImmersion10(),
        canLoadMore: canLoadMore,
      ),
    );
  }

  AppState successRechercheImmersionStateWithRequest({
    ImmersionCriteresRecherche? criteres,
    ImmersionFiltresRecherche? filtres,
  }) {
    return successRechercheImmersionState(
      request: RechercheRequest(
        criteres ?? ImmersionCriteresRecherche(location: mockLocation(), metier: mockMetier()),
        filtres ?? ImmersionFiltresRecherche.noFiltre(),
        1,
      ),
    );
  }

  AppState initialRechercheEvenementEmploiState() {
    return copyWith(rechercheEvenementEmploiState: RechercheEvenementEmploiState.initial());
  }

  AppState initialLoadingRechercheEvenementEmploiState() {
    return copyWith(
      rechercheEvenementEmploiState:
          RechercheEvenementEmploiState.initial().copyWith(status: RechercheStatus.initialLoading),
    );
  }

  AppState updateLoadingRechercheEvenementEmploiState() {
    return copyWith(
      rechercheEvenementEmploiState:
          RechercheEvenementEmploiState.initial().copyWith(status: RechercheStatus.updateLoading),
    );
  }

  AppState failureRechercheEvenementEmploiState() {
    return copyWith(
      rechercheEvenementEmploiState: RechercheEvenementEmploiState.initial().copyWith(status: RechercheStatus.failure),
    );
  }

  AppState successRechercheEvenementEmploiState({
    List<EvenementEmploi>? results,
    RechercheRequest<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>? request,
    bool canLoadMore = true,
  }) {
    return copyWith(
      rechercheEvenementEmploiState: RechercheEvenementEmploiState.initial().copyWith(
        status: RechercheStatus.success,
        request: () => request ?? initialRechercheEvenementEmploiRequest(),
        results: () => results ?? mockEvenementsEmploi(),
        canLoadMore: canLoadMore,
      ),
    );
  }

  AppState successRechercheEvenementEmploiStateWithRequest({
    EvenementEmploiCriteresRecherche? criteres,
    EvenementEmploiFiltresRecherche? filtres,
  }) {
    return successRechercheEvenementEmploiState(
      request: RechercheRequest(
        criteres ?? EvenementEmploiCriteresRecherche(location: mockLocation(), secteurActivite: null),
        filtres ?? EvenementEmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );
  }

  AppState withImmersionDetailsSuccess({ImmersionDetails? immersionDetails}) {
    return copyWith(
      immersionDetailsState: ImmersionDetailsSuccessState(immersionDetails ?? mockImmersionDetails()),
    );
  }

  AppState withImmersionDetailsLoading() {
    return copyWith(immersionDetailsState: ImmersionDetailsLoadingState());
  }

  AppState withDiagorientePreferencesMetierLoadingState() =>
      copyWith(diagorientePreferencesMetierState: DiagorientePreferencesMetierLoadingState());

  AppState withDiagorientePreferencesMetierFailureState() =>
      copyWith(diagorientePreferencesMetierState: DiagorientePreferencesMetierFailureState());

  AppState withDiagorientePreferencesMetierSuccessState({List<Metier> metiersFavoris = const []}) {
    return copyWith(
      diagorientePreferencesMetierState: DiagorientePreferencesMetierSuccessState(
        mockDiagorienteUrls(),
        metiersFavoris,
      ),
    );
  }

  AppState favoriListLoadingState() => copyWith(favoriListState: FavoriListLoadingState());

  AppState favoriListFailureState() => copyWith(favoriListState: FavoriListFailureState());

  AppState favoriListSuccessState(List<Favori> favoris) => copyWith(favoriListState: FavoriListSuccessState(favoris));

  AppState withRecentsSearches(List<Alerte> recherchesRecentes) {
    return copyWith(recherchesRecentesState: RecherchesRecentesState(recherchesRecentes));
  }

  AppState withAccueilMiloSuccess([Accueil? accueil]) {
    return copyWith(accueilState: AccueilSuccessState(accueil ?? mockAccueilMilo()));
  }

  AppState withAccueilPoleEmploiSuccess() {
    return copyWith(accueilState: AccueilSuccessState(mockAccueilPoleEmploi()));
  }

  AppState withAccueilFailure() {
    return copyWith(accueilState: AccueilFailureState());
  }

  AppState withAccueilLoading() {
    return copyWith(accueilState: AccueilLoadingState());
  }

  AppState withCvLoading() {
    return copyWith(cvState: CvLoadingState());
  }

  AppState withCvFailure() {
    return copyWith(cvState: CvFailureState());
  }

  AppState withCvSuccess() {
    return copyWith(cvState: CvSuccessState(cvList: mockCvPoleEmploiList(), cvDownloadStatus: {}));
  }

  AppState withCvEmptySuccess() {
    return copyWith(cvState: CvSuccessState(cvList: [], cvDownloadStatus: {}));
  }

  AppState withCvDownloadInProgress() {
    return copyWith(
      cvState: CvSuccessState(
        cvList: mockCvPoleEmploiList(),
        cvDownloadStatus: {
          mockCvPoleEmploi().url: CvDownloadStatus.loading,
        },
      ),
    );
  }

  AppState withCvDownloadSuccess() {
    return copyWith(
      cvState: CvSuccessState(
        cvList: mockCvPoleEmploiList(),
        cvDownloadStatus: {
          mockCvPoleEmploi().url: CvDownloadStatus.success,
        },
      ),
    );
  }

  AppState withCvDownloadFailure() {
    return copyWith(
      cvState: CvSuccessState(
        cvList: mockCvPoleEmploiList(),
        cvDownloadStatus: {
          mockCvPoleEmploi().url: CvDownloadStatus.failure,
        },
      ),
    );
  }

  AppState withMatchingDemarcheNotInitializedState() {
    return copyWith(matchingDemarcheState: MatchingDemarcheNotInitializedState());
  }

  AppState withMatchingDemarcheLoadingState() {
    return copyWith(matchingDemarcheState: MatchingDemarcheLoadingState());
  }

  AppState withMatchingDemarcheSuccessState(MatchingDemarcheDuReferentiel? result) {
    return copyWith(matchingDemarcheState: MatchingDemarcheSuccessState(result));
  }

  AppState withMatchingDemarcheFailureState() {
    return copyWith(matchingDemarcheState: MatchingDemarcheFailureState());
  }

  AppState withThematiqueDemarcheNotInitializedState() {
    return copyWith(thematiquesDemarcheState: ThematiqueDemarcheNotInitializedState());
  }

  AppState withThematiqueDemarcheLoadingState() {
    return copyWith(thematiquesDemarcheState: ThematiqueDemarcheLoadingState());
  }

  AppState withThematiqueDemarcheFailureState() {
    return copyWith(thematiquesDemarcheState: ThematiqueDemarcheFailureState());
  }

  AppState withThematiqueDemarcheSuccessState({List<DemarcheDuReferentiel>? demarches}) {
    return copyWith(thematiquesDemarcheState: ThematiqueDemarcheSuccessState([dummyThematiqueDeDemarche(demarches)]));
  }

  AppState withTopDemarcheSuccessState({required List<DemarcheDuReferentiel> demarches}) {
    return copyWith(topDemarcheState: TopDemarcheSuccessState(demarches));
  }

  AppState withSuccessSessionMiloDetails({DateTime? dateDeDebut, DateTime? dateDeFin, bool? estInscrit}) {
    return copyWith(
        sessionMiloDetailsState: SessionMiloDetailsSuccessState(mockSessionMiloDetails(
      dateDeDebut: dateDeDebut,
      dateDeFin: dateDeFin,
      estInscrit: estInscrit,
    )));
  }

  AppState withLoadingSessionMiloDetails() {
    return copyWith(sessionMiloDetailsState: SessionMiloDetailsLoadingState());
  }

  AppState withConnectivity(ConnectivityResult result) {
    return copyWith(connectivityState: ConnectivityState.fromResults([result]));
  }

  AppState withOnboardingSuccessState(Onboarding onboarding) {
    return copyWith(onboardingState: OnboardingSuccessState(onboarding));
  }

  AppState withFirstLaunchOnboardingSuccessState(bool isFirstLaunch) {
    return copyWith(firstLaunchOnboardingState: FirstLaunchOnboardingSuccessState(isFirstLaunch));
  }

  AppState withFirstLaunchNotInitializedState() {
    return copyWith(firstLaunchOnboardingState: FirstLaunchOnboardingNotInitializedState());
  }

  AppState withCvmMessage({List<CvmMessage>? messages}) {
    return copyWith(cvmState: CvmSuccessState(messages ?? [mockCvmTextMessage()]));
  }

  AppState withCguNeverAccepted() {
    return copyWith(cguState: CguNeverAcceptedState());
  }

  AppState withCguUpdateRequired(Cgu updatedCgu) {
    return copyWith(cguState: CguUpdateRequiredState(updatedCgu));
  }
}
