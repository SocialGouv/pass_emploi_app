import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/tutorial.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../utils/test_setup.dart';

AppState givenState([Configuration? configuration]) => AppState.initialState(configuration: configuration);

AppState givenBrsaState() {
  return AppState.initialState(configuration: configuration(flavor: Flavor.STAGING, brand: Brand.BRSA))
      .loggedInPoleEmploiUser();
}

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

  AppState withDemoMode() => copyWith(demoState: true);

  AppState rendezvousFutur(List<Rendezvous> rendezvous) =>
      copyWith(rendezvousListState: RendezvousListState.successfulFuture(rendezvous));

  AppState rendezvous(List<Rendezvous> rendezvous, [DateTime? dateDerniereMiseAJour]) =>
      copyWith(rendezvousListState: RendezvousListState.successful(rendezvous, dateDerniereMiseAJour));

  AppState rendezvousNotInitialized() => copyWith(rendezvousListState: RendezvousListState.notInitialized());

  AppState loadingFutureRendezvous() => copyWith(rendezvousListState: RendezvousListState.loadingFuture());

  AppState reloadingFutureRendezvous() => copyWith(rendezvousListState: RendezvousListState.reloadingFuture());

  AppState failedFutureRendezvous() => copyWith(rendezvousListState: RendezvousListState.failedFuture());

  AppState loadingPastRendezvous() => copyWith(rendezvousListState: RendezvousListState.loadingPast());

  AppState failedPastRendezvous() => copyWith(rendezvousListState: RendezvousListState.failedPast());

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

  AppState emptyAgenda() {
    final agenda = Agenda(actions: [], demarches: [], rendezvous: [], delayedActions: 0, dateDeDebut: DateTime(2042));
    return copyWith(agendaState: AgendaSuccessState(agenda));
  }

  AppState agenda({
    List<UserAction>? actions,
    List<Demarche>? demarches,
    List<Rendezvous>? rendezvous,
    int delayedActions = 0,
    DateTime? dateDeDebut,
    DateTime? dateDerniereMiseAjour,
  }) {
    return copyWith(
      agendaState: AgendaSuccessState(Agenda(
        actions: actions ?? [],
        demarches: demarches ?? [],
        rendezvous: rendezvous ?? [],
        delayedActions: delayedActions,
        dateDeDebut: dateDeDebut ?? DateTime(2042),
        dateDerniereMiseAJour: dateDerniereMiseAjour,
      )),
    );
  }

  AppState withUserActions(List<UserAction> userActions) {
    return copyWith(userActionListState: UserActionListSuccessState(userActions));
  }

  AppState withDemarches(List<Demarche> demarches) {
    return copyWith(demarcheListState: DemarcheListSuccessState(demarches));
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
    return copyWith(userActionListState: UserActionListSuccessState(actions));
  }

  AppState withAction(UserAction action) {
    return copyWith(userActionListState: UserActionListSuccessState([action]));
  }

  AppState updateActionNotInit() {
    return copyWith(userActionUpdateState: UserActionUpdateNotInitializedState());
  }

  AppState updateActionSuccess(UserActionStatus newStatus) {
    return copyWith(userActionUpdateState: UserActionUpdateSuccessState(newStatus));
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
      traiterSuggestionRechercheState: AccepterSuggestionRechercheSuccessState(offreEmploiSavedSearch()),
    );
  }

  AppState succeedRefuserSuggestionRecherche() {
    return copyWith(traiterSuggestionRechercheState: RefuserSuggestionRechercheSuccessState());
  }

  AppState failedTraiterSuggestionRecherche() {
    return copyWith(traiterSuggestionRechercheState: TraiterSuggestionRechercheFailureState());
  }

  AppState succeedEventList(List<Rendezvous> events) {
    return copyWith(eventListState: EventListSuccessState(events));
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
    final _results = results ?? mockOffresEmploi10();
    final _request = request ?? initialRechercheEmploiRequest();
    return copyWith(
      rechercheEmploiState: RechercheEmploiState.initial().copyWith(
        status: status,
        request: () => _request,
        results: () => _results,
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
        criteres ?? EmploiCriteresRecherche(location: null, keyword: '', onlyAlternance: false),
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
    final _results = results ?? mockOffresServiceCivique10();
    final _request = request ?? initialRechercheServiceCiviqueRequest();
    return copyWith(
      rechercheServiceCiviqueState: RechercheServiceCiviqueState.initial().copyWith(
        status: RechercheStatus.success,
        request: () => _request,
        results: () => _results,
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
    final _results = results ?? mockOffresImmersion10();
    final _request = request ?? initialRechercheImmersionRequest();
    return copyWith(
      rechercheImmersionState: RechercheImmersionState.initial().copyWith(
        status: RechercheStatus.success,
        request: () => _request,
        results: () => _results,
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

  AppState withRecentsSearches(List<SavedSearch> recherchesRecentes) {
    return copyWith(recherchesRecentesState: RecherchesRecentesState(recherchesRecentes));
  }

  AppState withAccueilMiloSuccess() {
    return copyWith(accueilState: AccueilSuccessState(mockAccueilMilo()));
  }

  AppState withAccueilFailure() {
    return copyWith(accueilState: AccueilFailureState());
  }

  AppState withAccueilLoading() {
    return copyWith(accueilState: AccueilLoadingState());
  }
}
