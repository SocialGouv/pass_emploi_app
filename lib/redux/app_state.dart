import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_state.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/configuration/configuration_state.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_state.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_state.dart';
import 'package:pass_emploi_app/features/cv/cv_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_state.dart';
import 'package:pass_emploi_app/features/device_info/device_info_state.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/user.dart';
/*AUTOGENERATE-REDUX-APP-STATE-IMPORT*/

class AppState extends Equatable {
  final ConfigurationState configurationState;
  final LoginState loginState;
  final DeepLinkState deepLinkState;
  final UserActionListState userActionListState;
  final UserActionCreateState userActionCreateState;
  final UserActionCreatePendingState userActionCreatePendingState;
  final UserActionUpdateState userActionUpdateState;
  final UserActionDeleteState userActionDeleteState;
  final DemarcheListState demarcheListState;
  final CreateDemarcheState createDemarcheState;
  final SearchDemarcheState searchDemarcheState;
  final UpdateDemarcheState updateDemarcheState;
  final DetailsJeuneState detailsJeuneState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiDetailsState offreEmploiDetailsState;
  final FavoriListState favoriListState;
  final FavoriIdsState<OffreEmploi> offreEmploiFavorisIdsState;
  final FavoriIdsState<Immersion> immersionFavorisIdsState;
  final FavoriIdsState<ServiceCivique> serviceCiviqueFavorisIdsState;
  final FavoriUpdateState favoriUpdateState;
  final SearchLocationState searchLocationState;
  final SearchMetierState searchMetierState;
  final RendezvousListState rendezvousListState;
  final RendezvousDetailsState rendezvousDetailsState;
  final ImmersionDetailsState immersionDetailsState;
  final AlerteCreateState<OffreEmploiAlerte> offreEmploiAlerteCreateState;
  final AlerteCreateState<ImmersionAlerte> immersionAlerteCreateState;
  final AlerteCreateState<ServiceCiviqueAlerte> serviceCiviqueAlerteCreateState;
  final AlerteListState alerteListState;
  final AlerteDeleteState alerteDeleteState;
  final ServiceCiviqueDetailState serviceCiviqueDetailState;
  final bool demoState;
  final SuppressionCompteState suppressionCompteState;
  final CampagneState campagneState;
  final PiecesJointesState piecesJointesState;
  final DeveloperOptionsState developerOptionsState;
  final MatomoLoggingState matomoLoggingState;
  final PreviewFileState previewFileState;
  final ChatBrouillonState chatBrouillonState;
  final ChatPartageState chatPartageState;
  final TutorialState tutorialState;
  final PartageActiviteState partageActiviteState;
  final PartageActiviteUpdateState partageActiviteUpdateState;
  final RatingState ratingState;
  final ActionCommentaireListState actionCommentaireListState;
  final AgendaState agendaState;
  final SuggestionsRechercheState suggestionsRechercheState;
  final TraiterSuggestionRechercheState traiterSuggestionRechercheState;
  final EventListState eventListState;
  final DeviceInfoState deviceInfoState;
  final RechercheEmploiState rechercheEmploiState;
  final RechercheImmersionState rechercheImmersionState;
  final RechercheServiceCiviqueState rechercheServiceCiviqueState;
  final RechercheEvenementEmploiState rechercheEvenementEmploiState;
  final DiagorientePreferencesMetierState diagorientePreferencesMetierState;
  final RecherchesRecentesState recherchesRecentesState;
  final ContactImmersionState contactImmersionState;
  final AccueilState accueilState;
  final CvState cvState;
  final EvenementEmploiDetailsState evenementEmploiDetailsState;
  final ThematiqueDemarcheState thematiquesDemarcheState;
  final TopDemarcheState topDemarcheState;
  final SessionMiloDetailsState sessionMiloDetailsState;
  final ConnectivityState connectivityState;
  final MonSuiviState monSuiviState;

  /*AUTOGENERATE-REDUX-APP-STATE-PROPERTY*/

  AppState({
    required this.configurationState,
    required this.loginState,
    required this.deepLinkState,
    required this.userActionListState,
    required this.userActionCreateState,
    required this.userActionCreatePendingState,
    required this.userActionUpdateState,
    required this.userActionDeleteState,
    required this.demarcheListState,
    required this.createDemarcheState,
    required this.searchDemarcheState,
    required this.updateDemarcheState,
    required this.detailsJeuneState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiDetailsState,
    required this.favoriListState,
    required this.offreEmploiFavorisIdsState,
    required this.immersionFavorisIdsState,
    required this.serviceCiviqueFavorisIdsState,
    required this.favoriUpdateState,
    required this.searchLocationState,
    required this.searchMetierState,
    required this.rendezvousListState,
    required this.rendezvousDetailsState,
    required this.immersionDetailsState,
    required this.offreEmploiAlerteCreateState,
    required this.immersionAlerteCreateState,
    required this.serviceCiviqueAlerteCreateState,
    required this.alerteListState,
    required this.alerteDeleteState,
    required this.serviceCiviqueDetailState,
    required this.suppressionCompteState,
    required this.demoState,
    required this.campagneState,
    required this.piecesJointesState,
    required this.developerOptionsState,
    required this.matomoLoggingState,
    required this.previewFileState,
    required this.chatBrouillonState,
    required this.chatPartageState,
    required this.tutorialState,
    required this.partageActiviteState,
    required this.partageActiviteUpdateState,
    required this.ratingState,
    required this.actionCommentaireListState,
    required this.agendaState,
    required this.suggestionsRechercheState,
    required this.traiterSuggestionRechercheState,
    required this.eventListState,
    required this.deviceInfoState,
    required this.rechercheEmploiState,
    required this.rechercheImmersionState,
    required this.rechercheServiceCiviqueState,
    required this.rechercheEvenementEmploiState,
    required this.diagorientePreferencesMetierState,
    required this.recherchesRecentesState,
    required this.contactImmersionState,
    required this.accueilState,
    required this.cvState,
    required this.evenementEmploiDetailsState,
    required this.thematiquesDemarcheState,
    required this.topDemarcheState,
    required this.sessionMiloDetailsState,
    required this.connectivityState,
    required this.monSuiviState,
    /*AUTOGENERATE-REDUX-APP-STATE-CONSTRUCTOR*/
  });

  AppState copyWith({
    final LoginState? loginState,
    final UserActionListState? userActionListState,
    final UserActionCreateState? userActionCreateState,
    final UserActionCreatePendingState? userActionCreatePendingState,
    final UserActionUpdateState? userActionUpdateState,
    final UserActionDeleteState? userActionDeleteState,
    final DemarcheListState? demarcheListState,
    final CreateDemarcheState? createDemarcheState,
    final SearchDemarcheState? searchDemarcheState,
    final UpdateDemarcheState? updateDemarcheState,
    final DetailsJeuneState? detailsJeuneState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final DeepLinkState? deepLinkState,
    final FavoriListState? favoriListState,
    final FavoriIdsState<OffreEmploi>? offreEmploiFavorisIdsState,
    final FavoriIdsState<Immersion>? immersionFavorisIdsState,
    final FavoriIdsState<ServiceCivique>? serviceCiviqueFavorisIdsState,
    final FavoriUpdateState? favoriUpdateState,
    final SearchLocationState? searchLocationState,
    final SearchMetierState? searchMetierState,
    final RendezvousListState? rendezvousListState,
    final RendezvousDetailsState? rendezvousDetailsState,
    final OffreEmploiDetailsState? offreEmploiDetailsState,
    final ImmersionDetailsState? immersionDetailsState,
    final AlerteCreateState<OffreEmploiAlerte>? offreEmploiAlerteCreateState,
    final AlerteCreateState<ImmersionAlerte>? immersionAlerteCreateState,
    final AlerteCreateState<ServiceCiviqueAlerte>? serviceCiviqueAlerteCreateState,
    final ConfigurationState? configurationState,
    final AlerteListState? alerteListState,
    final AlerteDeleteState? alerteDeleteState,
    final ServiceCiviqueDetailState? serviceCiviqueDetailState,
    final SuppressionCompteState? suppressionCompteState,
    final bool? demoState,
    final CampagneState? campagneState,
    final PiecesJointesState? piecesJointesState,
    final DeveloperOptionsState? developerOptionsState,
    final MatomoLoggingState? matomoLoggingState,
    final PreviewFileState? previewFileState,
    final ChatBrouillonState? chatBrouillonState,
    final ChatPartageState? chatPartageState,
    final TutorialState? tutorialState,
    final PartageActiviteState? partageActiviteState,
    final PartageActiviteUpdateState? partageActiviteUpdateState,
    final RatingState? ratingState,
    final ActionCommentaireListState? actionCommentaireListState,
    final AgendaState? agendaState,
    final SuggestionsRechercheState? suggestionsRechercheState,
    final TraiterSuggestionRechercheState? traiterSuggestionRechercheState,
    final EventListState? eventListState,
    final DeviceInfoState? deviceInfoState,
    final RechercheEmploiState? rechercheEmploiState,
    final RechercheImmersionState? rechercheImmersionState,
    final RechercheServiceCiviqueState? rechercheServiceCiviqueState,
    final RechercheEvenementEmploiState? rechercheEvenementEmploiState,
    final DiagorientePreferencesMetierState? diagorientePreferencesMetierState,
    final RecherchesRecentesState? recherchesRecentesState,
    final ContactImmersionState? contactImmersionState,
    final AccueilState? accueilState,
    final CvState? cvState,
    final EvenementEmploiDetailsState? evenementEmploiDetailsState,
    final ThematiqueDemarcheState? thematiquesDemarcheState,
    final TopDemarcheState? topDemarcheState,
    final SessionMiloDetailsState? sessionMiloDetailsState,
    final ConnectivityState? connectivityState,
    final MonSuiviState? monSuiviState,
    /*AUTOGENERATE-REDUX-APP-STATE-COPYPARAM*/
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      deepLinkState: deepLinkState ?? this.deepLinkState,
      userActionListState: userActionListState ?? this.userActionListState,
      userActionCreateState: userActionCreateState ?? this.userActionCreateState,
      userActionCreatePendingState: userActionCreatePendingState ?? this.userActionCreatePendingState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      userActionDeleteState: userActionDeleteState ?? this.userActionDeleteState,
      demarcheListState: demarcheListState ?? this.demarcheListState,
      createDemarcheState: createDemarcheState ?? this.createDemarcheState,
      searchDemarcheState: searchDemarcheState ?? this.searchDemarcheState,
      updateDemarcheState: updateDemarcheState ?? this.updateDemarcheState,
      detailsJeuneState: detailsJeuneState ?? this.detailsJeuneState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiDetailsState: offreEmploiDetailsState ?? this.offreEmploiDetailsState,
      favoriListState: favoriListState ?? this.favoriListState,
      offreEmploiFavorisIdsState: offreEmploiFavorisIdsState ?? this.offreEmploiFavorisIdsState,
      immersionFavorisIdsState: immersionFavorisIdsState ?? this.immersionFavorisIdsState,
      serviceCiviqueFavorisIdsState: serviceCiviqueFavorisIdsState ?? this.serviceCiviqueFavorisIdsState,
      favoriUpdateState: favoriUpdateState ?? this.favoriUpdateState,
      searchLocationState: searchLocationState ?? this.searchLocationState,
      searchMetierState: searchMetierState ?? this.searchMetierState,
      rendezvousListState: rendezvousListState ?? this.rendezvousListState,
      rendezvousDetailsState: rendezvousDetailsState ?? this.rendezvousDetailsState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
      offreEmploiAlerteCreateState: offreEmploiAlerteCreateState ?? this.offreEmploiAlerteCreateState,
      immersionAlerteCreateState: immersionAlerteCreateState ?? this.immersionAlerteCreateState,
      serviceCiviqueAlerteCreateState: serviceCiviqueAlerteCreateState ?? this.serviceCiviqueAlerteCreateState,
      configurationState: configurationState ?? this.configurationState,
      alerteListState: alerteListState ?? this.alerteListState,
      alerteDeleteState: alerteDeleteState ?? this.alerteDeleteState,
      serviceCiviqueDetailState: serviceCiviqueDetailState ?? this.serviceCiviqueDetailState,
      suppressionCompteState: suppressionCompteState ?? this.suppressionCompteState,
      demoState: demoState ?? this.demoState,
      campagneState: campagneState ?? this.campagneState,
      piecesJointesState: piecesJointesState ?? this.piecesJointesState,
      developerOptionsState: developerOptionsState ?? this.developerOptionsState,
      matomoLoggingState: matomoLoggingState ?? this.matomoLoggingState,
      previewFileState: previewFileState ?? this.previewFileState,
      chatBrouillonState: chatBrouillonState ?? this.chatBrouillonState,
      chatPartageState: chatPartageState ?? this.chatPartageState,
      tutorialState: tutorialState ?? this.tutorialState,
      partageActiviteState: partageActiviteState ?? this.partageActiviteState,
      partageActiviteUpdateState: partageActiviteUpdateState ?? this.partageActiviteUpdateState,
      ratingState: ratingState ?? this.ratingState,
      actionCommentaireListState: actionCommentaireListState ?? this.actionCommentaireListState,
      agendaState: agendaState ?? this.agendaState,
      suggestionsRechercheState: suggestionsRechercheState ?? this.suggestionsRechercheState,
      traiterSuggestionRechercheState: traiterSuggestionRechercheState ?? this.traiterSuggestionRechercheState,
      eventListState: eventListState ?? this.eventListState,
      deviceInfoState: deviceInfoState ?? this.deviceInfoState,
      rechercheEmploiState: rechercheEmploiState ?? this.rechercheEmploiState,
      rechercheImmersionState: rechercheImmersionState ?? this.rechercheImmersionState,
      rechercheServiceCiviqueState: rechercheServiceCiviqueState ?? this.rechercheServiceCiviqueState,
      rechercheEvenementEmploiState: rechercheEvenementEmploiState ?? this.rechercheEvenementEmploiState,
      diagorientePreferencesMetierState: diagorientePreferencesMetierState ?? this.diagorientePreferencesMetierState,
      recherchesRecentesState: recherchesRecentesState ?? this.recherchesRecentesState,
      contactImmersionState: contactImmersionState ?? this.contactImmersionState,
      accueilState: accueilState ?? this.accueilState,
      cvState: cvState ?? this.cvState,
      evenementEmploiDetailsState: evenementEmploiDetailsState ?? this.evenementEmploiDetailsState,
      thematiquesDemarcheState: thematiquesDemarcheState ?? this.thematiquesDemarcheState,
      topDemarcheState: topDemarcheState ?? this.topDemarcheState,
      sessionMiloDetailsState: sessionMiloDetailsState ?? this.sessionMiloDetailsState,
      connectivityState: connectivityState ?? this.connectivityState,
      monSuiviState: monSuiviState ?? this.monSuiviState,
      /*AUTOGENERATE-REDUX-APP-STATE-COPYBODY*/
    );
  }

  factory AppState.initialState({Configuration? configuration}) {
    return AppState(
      loginState: LoginNotInitializedState(),
      deepLinkState: DeepLinkState.notInitialized(),
      userActionListState: UserActionListNotInitializedState(),
      userActionCreateState: UserActionCreateNotInitializedState(),
      userActionCreatePendingState: UserActionCreatePendingNotInitializedState(),
      userActionUpdateState: UserActionUpdateNotInitializedState(),
      userActionDeleteState: UserActionDeleteNotInitializedState(),
      demarcheListState: DemarcheListNotInitializedState(),
      detailsJeuneState: DetailsJeuneNotInitializedState(),
      createDemarcheState: CreateDemarcheNotInitializedState(),
      searchDemarcheState: SearchDemarcheNotInitializedState(),
      updateDemarcheState: UpdateDemarcheNotInitializedState(),
      chatStatusState: ChatStatusNotInitializedState(),
      chatState: ChatNotInitializedState(),
      offreEmploiDetailsState: OffreEmploiDetailsNotInitializedState(),
      favoriListState: FavoriListNotInitializedState(),
      offreEmploiFavorisIdsState: FavoriIdsState<OffreEmploi>.notInitialized(),
      immersionFavorisIdsState: FavoriIdsState<Immersion>.notInitialized(),
      serviceCiviqueFavorisIdsState: FavoriIdsState<ServiceCivique>.notInitialized(),
      favoriUpdateState: FavoriUpdateState({}),
      searchLocationState: SearchLocationState([]),
      searchMetierState: SearchMetierState([]),
      rendezvousListState: RendezvousListState.notInitialized(),
      rendezvousDetailsState: RendezvousDetailsNotInitializedState(),
      immersionDetailsState: ImmersionDetailsNotInitializedState(),
      offreEmploiAlerteCreateState: AlerteCreateState<OffreEmploiAlerte>.notInitialized(),
      immersionAlerteCreateState: AlerteCreateState<ImmersionAlerte>.notInitialized(),
      serviceCiviqueAlerteCreateState: AlerteCreateState<ServiceCiviqueAlerte>.notInitialized(),
      configurationState: ConfigurationState(configuration),
      alerteListState: AlerteListNotInitializedState(),
      alerteDeleteState: AlerteDeleteNotInitializedState(),
      serviceCiviqueDetailState: ServiceCiviqueDetailNotInitializedState(),
      demoState: false,
      suppressionCompteState: SuppressionCompteNotInitializedState(),
      campagneState: CampagneState(null, []),
      piecesJointesState: PiecesJointesState({}),
      developerOptionsState: DeveloperOptionsNotInitializedState(),
      matomoLoggingState: MatomoLoggingState([]),
      previewFileState: PreviewFileNotInitializedState(),
      chatBrouillonState: ChatBrouillonState(null),
      chatPartageState: ChatPartageNotInitializedState(),
      tutorialState: TutorialNotInitializedState(),
      partageActiviteState: PartageActiviteNotInitializedState(),
      partageActiviteUpdateState: PartageActiviteUpdateNotInitializedState(),
      ratingState: RatingNotInitializedState(),
      actionCommentaireListState: ActionCommentaireListNotInitializedState(),
      agendaState: AgendaNotInitializedState(),
      suggestionsRechercheState: SuggestionsRechercheNotInitializedState(),
      traiterSuggestionRechercheState: TraiterSuggestionRechercheNotInitializedState(),
      eventListState: EventListNotInitializedState(),
      deviceInfoState: DeviceInfoNotInitializedState(),
      rechercheEmploiState: RechercheState.initial(),
      rechercheImmersionState: RechercheState.initial(),
      rechercheServiceCiviqueState: RechercheState.initial(),
      rechercheEvenementEmploiState: RechercheState.initial(),
      diagorientePreferencesMetierState: DiagorientePreferencesMetierNotInitializedState(),
      recherchesRecentesState: RecherchesRecentesState([]),
      contactImmersionState: ContactImmersionNotInitializedState(),
      accueilState: AccueilNotInitializedState(),
      cvState: CvNotInitializedState(),
      evenementEmploiDetailsState: EvenementEmploiDetailsNotInitializedState(),
      thematiquesDemarcheState: ThematiqueDemarcheNotInitializedState(),
      topDemarcheState: TopDemarcheNotInitializedState(),
      sessionMiloDetailsState: SessionMiloDetailsNotInitializedState(),
      connectivityState: ConnectivityState.notInitialized(),
      monSuiviState: MonSuiviNotInitializedState(),
      /*AUTOGENERATE-REDUX-APP-STATE-FACTORY*/
    );
  }

  @override
  List<Object?> get props => [
        deepLinkState,
        userActionCreateState,
        userActionCreatePendingState,
        userActionUpdateState,
        userActionDeleteState,
        demarcheListState,
        createDemarcheState,
        searchDemarcheState,
        updateDemarcheState,
        detailsJeuneState,
        chatStatusState,
        chatState,
        offreEmploiDetailsState,
        offreEmploiFavorisIdsState,
        favoriUpdateState,
        searchLocationState,
        searchMetierState,
        loginState,
        userActionListState,
        rendezvousListState,
        rendezvousDetailsState,
        immersionDetailsState,
        offreEmploiAlerteCreateState,
        immersionAlerteCreateState,
        alerteListState,
        alerteDeleteState,
        serviceCiviqueDetailState,
        suppressionCompteState,
        demoState,
        campagneState,
        piecesJointesState,
        previewFileState,
        chatBrouillonState,
        chatPartageState,
        tutorialState,
        partageActiviteState,
        partageActiviteUpdateState,
        ratingState,
        actionCommentaireListState,
        agendaState,
        suggestionsRechercheState,
        traiterSuggestionRechercheState,
        eventListState,
        deviceInfoState,
        rechercheEmploiState,
        rechercheImmersionState,
        rechercheServiceCiviqueState,
        rechercheEvenementEmploiState,
        diagorientePreferencesMetierState,
        recherchesRecentesState,
        contactImmersionState,
        accueilState,
        cvState,
        evenementEmploiDetailsState,
        thematiquesDemarcheState,
        topDemarcheState,
        sessionMiloDetailsState,
        connectivityState,
        monSuiviState,
        /*AUTOGENERATE-REDUX-APP-STATE-EQUATABLE*/
      ];

  @override
  bool? get stringify => true;
}

extension AppStateUser on AppState {
  User? user() {
    final loginState = this.loginState;
    if (loginState is LoginSuccessState) {
      return loginState.user;
    }
    return null;
  }

  String? userId() => user()?.id;
}
