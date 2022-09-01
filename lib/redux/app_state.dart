import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/partage_offre/partage_offre_state.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/configuration/configuration_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/user.dart';

class AppState extends Equatable {
  final ConfigurationState configurationState;
  final LoginState loginState;
  final DeepLinkState deepLinkState;
  final UserActionListState userActionListState;
  final UserActionCreateState userActionCreateState;
  final UserActionUpdateState userActionUpdateState;
  final UserActionDeleteState userActionDeleteState;
  final DemarcheListState demarcheListState;
  final CreateDemarcheState createDemarcheState;
  final SearchDemarcheState searchDemarcheState;
  final UpdateDemarcheState updateDemarcheState;
  final DetailsJeuneState detailsJeuneState;
  final ChatStatusState chatStatusState;
  final ChatState chatState;
  final OffreEmploiSearchState offreEmploiSearchState;
  final OffreEmploiDetailsState offreEmploiDetailsState;
  final OffreEmploiListState offreEmploiListState;
  final OffreEmploiSearchParametersState offreEmploiSearchParametersState;
  final FavoriListState<OffreEmploi> offreEmploiFavorisState;
  final FavoriListState<Immersion> immersionFavorisState;
  final FavoriListState<ServiceCivique> serviceCiviqueFavorisState;
  final FavoriUpdateState favoriUpdateState;
  final SearchLocationState searchLocationState;
  final SearchMetierState searchMetierState;
  final RendezvousState rendezvousState;
  final ImmersionListState immersionListState;
  final ImmersionDetailsState immersionDetailsState;
  final SavedSearchCreateState<OffreEmploiSavedSearch> offreEmploiSavedSearchCreateState;
  final SavedSearchCreateState<ImmersionSavedSearch> immersionSavedSearchCreateState;
  final SavedSearchCreateState<ServiceCiviqueSavedSearch> serviceCiviqueSavedSearchCreateState;
  final ImmersionSearchParametersState immersionSearchParametersState;
  final SavedSearchListState savedSearchListState;
  final SavedSearchDeleteState savedSearchDeleteState;
  final ServiceCiviqueSearchResultState serviceCiviqueSearchResultState;
  final ServiceCiviqueDetailState serviceCiviqueDetailState;
  final bool demoState;
  final SuppressionCompteState suppressionCompteState;
  final CampagneState campagneState;
  final PiecesJointesState piecesJointesState;
  final DeveloperOptionsState developerOptionsState;
  final MatomoLoggingState matomoLoggingState;
  final PreviewFileState previewFileState;
  final ChatBrouillonState chatBrouillonState;
  final ChatPartageOffreState chatPartageOffreState;
  final TutorialState tutorialState;
  final PartageActiviteState partageActiviteState;
  final PartageActiviteUpdateState partageActiviteUpdateState;
  final RatingState ratingState;
  final ActionCommentaireListState actionCommentaireListState;
  final ActionCommentaireCreateState actionCommentaireCreateState;
  final AgendaState agendaState;

  AppState({
    required this.configurationState,
    required this.loginState,
    required this.deepLinkState,
    required this.userActionListState,
    required this.userActionCreateState,
    required this.userActionUpdateState,
    required this.userActionDeleteState,
    required this.demarcheListState,
    required this.createDemarcheState,
    required this.searchDemarcheState,
    required this.updateDemarcheState,
    required this.detailsJeuneState,
    required this.chatStatusState,
    required this.chatState,
    required this.offreEmploiSearchState,
    required this.offreEmploiDetailsState,
    required this.offreEmploiListState,
    required this.offreEmploiSearchParametersState,
    required this.offreEmploiFavorisState,
    required this.immersionFavorisState,
    required this.serviceCiviqueFavorisState,
    required this.favoriUpdateState,
    required this.searchLocationState,
    required this.searchMetierState,
    required this.rendezvousState,
    required this.immersionListState,
    required this.immersionDetailsState,
    required this.offreEmploiSavedSearchCreateState,
    required this.immersionSavedSearchCreateState,
    required this.serviceCiviqueSavedSearchCreateState,
    required this.immersionSearchParametersState,
    required this.savedSearchListState,
    required this.savedSearchDeleteState,
    required this.serviceCiviqueSearchResultState,
    required this.serviceCiviqueDetailState,
    required this.suppressionCompteState,
    required this.demoState,
    required this.campagneState,
    required this.piecesJointesState,
    required this.developerOptionsState,
    required this.matomoLoggingState,
    required this.previewFileState,
    required this.chatBrouillonState,
    required this.chatPartageOffreState,
    required this.tutorialState,
    required this.partageActiviteState,
    required this.partageActiviteUpdateState,
    required this.ratingState,
    required this.actionCommentaireListState,
    required this.actionCommentaireCreateState,
    required this.agendaState,
  });

  AppState copyWith({
    final LoginState? loginState,
    final UserActionListState? userActionListState,
    final UserActionCreateState? userActionCreateState,
    final UserActionUpdateState? userActionUpdateState,
    final UserActionDeleteState? userActionDeleteState,
    final DemarcheListState? demarcheListState,
    final CreateDemarcheState? createDemarcheState,
    final SearchDemarcheState? searchDemarcheState,
    final UpdateDemarcheState? updateDemarcheState,
    final DetailsJeuneState? detailsJeuneState,
    final ChatStatusState? chatStatusState,
    final ChatState? chatState,
    final OffreEmploiSearchState? offreEmploiSearchState,
    final DeepLinkState? deepLinkState,
    final OffreEmploiListState? offreEmploiListState,
    final OffreEmploiSearchParametersState? offreEmploiSearchParametersState,
    final FavoriListState<OffreEmploi>? offreEmploiFavorisState,
    final FavoriListState<Immersion>? immersionFavorisState,
    final FavoriListState<ServiceCivique>? serviceCiviqueFavorisState,
    final FavoriUpdateState? favoriUpdateState,
    final SearchLocationState? searchLocationState,
    final SearchMetierState? searchMetierState,
    final RendezvousState? rendezvousState,
    final OffreEmploiDetailsState? offreEmploiDetailsState,
    final ImmersionListState? immersionListState,
    final ImmersionDetailsState? immersionDetailsState,
    final SavedSearchCreateState<OffreEmploiSavedSearch>? offreEmploiSavedSearchCreateState,
    final SavedSearchCreateState<ImmersionSavedSearch>? immersionSavedSearchCreateState,
    final SavedSearchCreateState<ServiceCiviqueSavedSearch>? serviceCiviqueSavedSearchCreateState,
    final ConfigurationState? configurationState,
    final ImmersionSearchParametersState? immersionSearchParametersState,
    final SavedSearchListState? savedSearchListState,
    final SavedSearchDeleteState? savedSearchDeleteState,
    final ServiceCiviqueSearchResultState? serviceCiviqueSearchResultState,
    final ServiceCiviqueDetailState? serviceCiviqueDetailState,
    final SuppressionCompteState? suppressionCompteState,
    final bool? demoState,
    final CampagneState? campagneState,
    final PiecesJointesState? piecesJointesState,
    final DeveloperOptionsState? developerOptionsState,
    final MatomoLoggingState? matomoLoggingState,
    final PreviewFileState? previewFileState,
    final ChatBrouillonState? chatBrouillonState,
    final ChatPartageOffreState? chatPartageOffreState,
    final TutorialState? tutorialState,
    final PartageActiviteState? partageActiviteState,
    final PartageActiviteUpdateState? partageActiviteUpdateState,
    final RatingState? ratingState,
    final ActionCommentaireListState? actionCommentaireListState,
    final ActionCommentaireCreateState? actionCommentaireCreateState,
    final AgendaState? agendaState,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      deepLinkState: deepLinkState ?? this.deepLinkState,
      userActionListState: userActionListState ?? this.userActionListState,
      userActionCreateState: userActionCreateState ?? this.userActionCreateState,
      userActionUpdateState: userActionUpdateState ?? this.userActionUpdateState,
      userActionDeleteState: userActionDeleteState ?? this.userActionDeleteState,
      demarcheListState: demarcheListState ?? this.demarcheListState,
      createDemarcheState: createDemarcheState ?? this.createDemarcheState,
      searchDemarcheState: searchDemarcheState ?? this.searchDemarcheState,
      updateDemarcheState: updateDemarcheState ?? this.updateDemarcheState,
      detailsJeuneState: detailsJeuneState ?? this.detailsJeuneState,
      chatStatusState: chatStatusState ?? this.chatStatusState,
      chatState: chatState ?? this.chatState,
      offreEmploiSearchState: offreEmploiSearchState ?? this.offreEmploiSearchState,
      offreEmploiDetailsState: offreEmploiDetailsState ?? this.offreEmploiDetailsState,
      offreEmploiListState: offreEmploiListState ?? this.offreEmploiListState,
      offreEmploiSearchParametersState: offreEmploiSearchParametersState ?? this.offreEmploiSearchParametersState,
      offreEmploiFavorisState: offreEmploiFavorisState ?? this.offreEmploiFavorisState,
      immersionFavorisState: immersionFavorisState ?? this.immersionFavorisState,
      serviceCiviqueFavorisState: serviceCiviqueFavorisState ?? this.serviceCiviqueFavorisState,
      favoriUpdateState: favoriUpdateState ?? this.favoriUpdateState,
      searchLocationState: searchLocationState ?? this.searchLocationState,
      searchMetierState: searchMetierState ?? this.searchMetierState,
      rendezvousState: rendezvousState ?? this.rendezvousState,
      immersionListState: immersionListState ?? this.immersionListState,
      immersionDetailsState: immersionDetailsState ?? this.immersionDetailsState,
      offreEmploiSavedSearchCreateState: offreEmploiSavedSearchCreateState ?? this.offreEmploiSavedSearchCreateState,
      immersionSavedSearchCreateState: immersionSavedSearchCreateState ?? this.immersionSavedSearchCreateState,
      serviceCiviqueSavedSearchCreateState:
          serviceCiviqueSavedSearchCreateState ?? this.serviceCiviqueSavedSearchCreateState,
      configurationState: configurationState ?? this.configurationState,
      immersionSearchParametersState: immersionSearchParametersState ?? this.immersionSearchParametersState,
      savedSearchListState: savedSearchListState ?? this.savedSearchListState,
      savedSearchDeleteState: savedSearchDeleteState ?? this.savedSearchDeleteState,
      serviceCiviqueSearchResultState: serviceCiviqueSearchResultState ?? this.serviceCiviqueSearchResultState,
      serviceCiviqueDetailState: serviceCiviqueDetailState ?? this.serviceCiviqueDetailState,
      suppressionCompteState: suppressionCompteState ?? this.suppressionCompteState,
      demoState: demoState ?? this.demoState,
      campagneState: campagneState ?? this.campagneState,
      piecesJointesState: piecesJointesState ?? this.piecesJointesState,
      developerOptionsState: developerOptionsState ?? this.developerOptionsState,
      matomoLoggingState: matomoLoggingState ?? this.matomoLoggingState,
      previewFileState: previewFileState ?? this.previewFileState,
      chatBrouillonState: chatBrouillonState ?? this.chatBrouillonState,
      chatPartageOffreState: chatPartageOffreState ?? this.chatPartageOffreState,
      tutorialState: tutorialState ?? this.tutorialState,
      partageActiviteState: partageActiviteState ?? this.partageActiviteState,
      partageActiviteUpdateState: partageActiviteUpdateState ?? this.partageActiviteUpdateState,
      ratingState: ratingState ?? this.ratingState,
      actionCommentaireListState: actionCommentaireListState ?? this.actionCommentaireListState,
      actionCommentaireCreateState: actionCommentaireCreateState ?? this.actionCommentaireCreateState,
      agendaState: agendaState ?? this.agendaState,
    );
  }

  factory AppState.initialState({Configuration? configuration}) {
    return AppState(
      loginState: LoginNotInitializedState(),
      deepLinkState: DeepLinkState.notInitialized(),
      userActionListState: UserActionListNotInitializedState(),
      userActionCreateState: UserActionCreateNotInitializedState(),
      userActionUpdateState: UserActionUpdateNotInitializedState(),
      userActionDeleteState: UserActionDeleteNotInitializedState(),
      demarcheListState: DemarcheListNotInitializedState(),
      detailsJeuneState: DetailsJeuneNotInitializedState(),
      createDemarcheState: CreateDemarcheNotInitializedState(),
      searchDemarcheState: SearchDemarcheNotInitializedState(),
      updateDemarcheState: UpdateDemarcheNotInitializedState(),
      chatStatusState: ChatStatusNotInitializedState(),
      chatState: ChatNotInitializedState(),
      offreEmploiSearchState: OffreEmploiSearchState.notInitialized(),
      offreEmploiDetailsState: OffreEmploiDetailsNotInitializedState(),
      offreEmploiListState: OffreEmploiListState.notInitialized(),
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.notInitialized(),
      offreEmploiFavorisState: FavoriListState<OffreEmploi>.notInitialized(),
      immersionFavorisState: FavoriListState<Immersion>.notInitialized(),
      serviceCiviqueFavorisState: FavoriListState<ServiceCivique>.notInitialized(),
      favoriUpdateState: FavoriUpdateState({}),
      searchLocationState: SearchLocationState([]),
      searchMetierState: SearchMetierState([]),
      rendezvousState: RendezvousState.notInitialized(),
      immersionListState: ImmersionListNotInitializedState(),
      immersionDetailsState: ImmersionDetailsNotInitializedState(),
      offreEmploiSavedSearchCreateState: SavedSearchCreateState<OffreEmploiSavedSearch>.notInitialized(),
      immersionSavedSearchCreateState: SavedSearchCreateState<ImmersionSavedSearch>.notInitialized(),
      serviceCiviqueSavedSearchCreateState: SavedSearchCreateState<ServiceCiviqueSavedSearch>.notInitialized(),
      configurationState: ConfigurationState(configuration),
      immersionSearchParametersState: ImmersionSearchParametersNotInitializedState(),
      savedSearchListState: SavedSearchListNotInitializedState(),
      savedSearchDeleteState: SavedSearchDeleteNotInitializedState(),
      serviceCiviqueSearchResultState: ServiceCiviqueSearchResultNotInitializedState(),
      serviceCiviqueDetailState: ServiceCiviqueDetailNotInitializedState(),
      demoState: false,
      suppressionCompteState: SuppressionCompteNotInitializedState(),
      campagneState: CampagneState(null, []),
      piecesJointesState: PiecesJointesState({}),
      developerOptionsState: DeveloperOptionsNotInitializedState(),
      matomoLoggingState: MatomoLoggingState([]),
      previewFileState: PreviewFileNotInitializedState(),
      chatBrouillonState: ChatBrouillonState(null),
      chatPartageOffreState: ChatPartageOffreState.notInitialized,
      tutorialState: TutorialNotInitializedState(),
      partageActiviteState: PartageActiviteNotInitializedState(),
      partageActiviteUpdateState: PartageActiviteUpdateNotInitializedState(),
      ratingState: RatingNotInitializedState(),
      actionCommentaireListState: ActionCommentaireListNotInitializedState(),
      actionCommentaireCreateState: ActionCommentaireCreateNotInitializedState(),
      agendaState: AgendaNotInitializedState(),
    );
  }

  @override
  List<Object?> get props => [
        deepLinkState,
        userActionCreateState,
        userActionUpdateState,
        userActionDeleteState,
        demarcheListState,
        createDemarcheState,
        searchDemarcheState,
        updateDemarcheState,
        detailsJeuneState,
        chatStatusState,
        chatState,
        offreEmploiSearchState,
        offreEmploiDetailsState,
        offreEmploiListState,
        offreEmploiSearchParametersState,
        offreEmploiFavorisState,
        favoriUpdateState,
        searchLocationState,
        searchMetierState,
        loginState,
        userActionListState,
        rendezvousState,
        immersionListState,
        immersionDetailsState,
        offreEmploiSavedSearchCreateState,
        immersionSavedSearchCreateState,
        immersionSearchParametersState,
        savedSearchListState,
        savedSearchDeleteState,
        serviceCiviqueDetailState,
        suppressionCompteState,
        demoState,
        campagneState,
        piecesJointesState,
        previewFileState,
        chatBrouillonState,
        chatPartageOffreState,
        tutorialState,
        partageActiviteState,
        partageActiviteUpdateState,
        ratingState,
        actionCommentaireListState,
        actionCommentaireCreateState,
        agendaState,
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