import 'package:pass_emploi_app/features/accueil/accueil_reducer.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_reducer.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_reducer.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_reducer.dart';
import 'package:pass_emploi_app/features/campagne/campagne_reducer.dart';
import 'package:pass_emploi_app/features/cgu/cgu_reducer.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_reducer.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_reducer.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_reducer.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_reducer.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_reducer.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_reducer.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_reducer.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_reducer.dart';
import 'package:pass_emploi_app/features/cv/cv_reducer.dart';
import 'package:pass_emploi_app/features/cvm/cvm_reducer.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_reducer.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_reducer.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_reducer.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_reducer.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_reducer.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_reducer.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_reducer.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_reducer.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_reducer.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_reducer.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_reducer.dart';
import 'package:pass_emploi_app/features/events/list/event_list_reducer.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_reducer.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_reducer.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_reducer.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_reducer.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_reducer.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_reducer.dart';
import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_reducer.dart';
import 'package:pass_emploi_app/features/location/search_location_reducer.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_reducer.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_reducer.dart';
import 'package:pass_emploi_app/features/message_important/message_important_reducer.dart';
import 'package:pass_emploi_app/features/metier/search_metier_reducer.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_reducer.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_reducer.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_reducer.dart';
import 'package:pass_emploi_app/features/preferences/preferences_reducer.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_reducer.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_reducer.dart';
import 'package:pass_emploi_app/features/rating/rating_reducer.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_reducer.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_reducer.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_reducer.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_reducer.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_reducer.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_reducer.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_reducer.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_reducer.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_reducer.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_reducer.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_reducer.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_reducer.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_reducer.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_reducer.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_reducer.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_reducer.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_reducer.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
/*AUTOGENERATE-REDUX-APP-REDUCER-IMPORT*/

AppState reducer(AppState current, dynamic action) {
  if (action is RequestLogoutAction) {
    return AppState.initialState(configuration: current.configurationState.configuration);
  }
  return AppState(
    configurationState: current.configurationState,
    featureFlipState: featureFlipReducer(current.featureFlipState, action),
    userActionDetailsState: userActionDetailsReducer(current.userActionDetailsState, action),
    userActionCreateState: userActionCreateReducer(current.userActionCreateState, action),
    userActionCreatePendingState: userActionCreatePendingReducer(current.userActionCreatePendingState, action),
    userActionUpdateState: userActionUpdateReducer(current.userActionUpdateState, action),
    userActionDeleteState: userActionDeleteReducer(current.userActionDeleteState, action),
    createDemarcheState: createDemarcheReducer(current.createDemarcheState, action),
    searchDemarcheState: searchDemarcheReducer(current.searchDemarcheState, action),
    updateDemarcheState: updateDemarcheReducer(current.updateDemarcheState, action),
    detailsJeuneState: detailsJeuneReducer(current.detailsJeuneState, action),
    chatStatusState: chatStatusReducer(current.chatStatusState, action),
    chatState: chatReducer(current.chatState, action),
    deepLinkState: deepLinkReducer(current.deepLinkState, action),
    offreEmploiDetailsState: offreEmploiDetailsReducer(current.offreEmploiDetailsState, action),
    favoriListState: favoriListReducer(current.favoriListState, action),
    offreEmploiFavorisIdsState: FavoriIdsReducer<OffreEmploi>().reduceFavorisState(
      current.offreEmploiFavorisIdsState,
      action,
    ),
    immersionFavorisIdsState:
        FavoriIdsReducer<Immersion>().reduceFavorisState(current.immersionFavorisIdsState, action),
    serviceCiviqueFavorisIdsState: FavoriIdsReducer<ServiceCivique>().reduceFavorisState(
      current.serviceCiviqueFavorisIdsState,
      action,
    ),
    favoriUpdateState: favoriUpdateReducer(current.favoriUpdateState, action),
    searchLocationState: searchLocationReducer(current.searchLocationState, action),
    searchMetierState: searchMetierReducer(current.searchMetierState, action),
    loginState: loginReducer(current.loginState, action),
    rendezvousDetailsState: rendezvousDetailsReducer(current.rendezvousDetailsState, action),
    immersionDetailsState: immersionDetailsReducer(current.immersionDetailsState, action),
    offreEmploiAlerteCreateState: alerteCreateReducer<OffreEmploiAlerte>(
      current.offreEmploiAlerteCreateState,
      action,
    ),
    immersionAlerteCreateState: alerteCreateReducer<ImmersionAlerte>(
      current.immersionAlerteCreateState,
      action,
    ),
    serviceCiviqueAlerteCreateState: alerteCreateReducer<ServiceCiviqueAlerte>(
      current.serviceCiviqueAlerteCreateState,
      action,
    ),
    alerteListState: alerteListReducer(current.alerteListState, action),
    alerteDeleteState: alerteDeleteReducer(current.alerteDeleteState, action),
    serviceCiviqueDetailState: serviceCiviqueDetailReducer(current.serviceCiviqueDetailState, action),
    suppressionCompteState: suppressionCompteReducer(current.suppressionCompteState, action),
    demoState: modeDemoReducer(current, action),
    campagneState: campagneReducer(current.campagneState, action),
    piecesJointesState: pieceJointeReducer(current.piecesJointesState, action),
    developerOptionsState: developerOptionsReducer(current.developerOptionsState, action),
    matomoLoggingState: matomoLoggingReducer(current.matomoLoggingState, action),
    previewFileState: previewFileReducer(current.previewFileState, action),
    chatBrouillonState: chatBrouillonReducer(current.chatBrouillonState, action),
    chatPartageState: chatPartageReducer(current.chatPartageState, action),
    tutorialState: tutorialReducer(current.tutorialState, action),
    preferencesState: preferencesReducer(current.preferencesState, action),
    preferencesUpdateState: preferencesUpdateReducer(current.preferencesUpdateState, action),
    ratingState: ratingReducer(current.ratingState, action),
    actionCommentaireListState: actionCommentaireListReducer(current.actionCommentaireListState, action),
    suggestionsRechercheState: suggestionsRechercheReducer(current.suggestionsRechercheState, action),
    traiterSuggestionRechercheState: traiterSuggestionRechercheReducer(current.traiterSuggestionRechercheState, action),
    eventListState: eventListReducer(current.eventListState, action),
    rechercheEmploiState: rechercheReducer<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi>(
      current.rechercheEmploiState,
      action,
    ),
    rechercheImmersionState: rechercheReducer<ImmersionCriteresRecherche, ImmersionFiltresRecherche, Immersion>(
      current.rechercheImmersionState,
      action,
    ),
    rechercheServiceCiviqueState:
        rechercheReducer<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique>(
      current.rechercheServiceCiviqueState,
      action,
    ),
    rechercheEvenementEmploiState:
        rechercheReducer<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche, EvenementEmploi>(
      current.rechercheEvenementEmploiState,
      action,
    ),
    diagorientePreferencesMetierState:
        diagorientePreferencesMetierReducer(current.diagorientePreferencesMetierState, action),
    recherchesRecentesState: recherchesRecentesReducer(current.recherchesRecentesState, action),
    contactImmersionState: contactImmersionReducer(current.contactImmersionState, action),
    accueilState: accueilReducer(current.accueilState, action),
    cvState: cvReducer(current.cvState, action),
    evenementEmploiDetailsState: evenementEmploiDetailsReducer(current.evenementEmploiDetailsState, action),
    thematiquesDemarcheState: thematiquesDemarcheReducer(current.thematiquesDemarcheState, action),
    topDemarcheState: topDemarcheReducer(current.topDemarcheState, action),
    sessionMiloDetailsState: sessionMiloDetailsReducer(current.sessionMiloDetailsState, action),
    connectivityState: connectivityReducer(current.connectivityState, action),
    monSuiviState: monSuiviReducer(current.monSuiviState, action),
    cvmState: cvmReducer(current.cvmState, action),
    preferredLoginModeState: preferredLoginModeReducer(current.preferredLoginModeState, action),
    onboardingState: onboardingReducer(current.onboardingState, action),
    firstLaunchOnboardingState: firstLaunchOnboardingReducer(current.firstLaunchOnboardingState, action),
    messageImportantState: messageImportantReducer(current.messageImportantState, action),
    matchingDemarcheState: matchingDemarcheReducer(current.matchingDemarcheState, action),
    cguState: cguReducer(current.cguState, action),
    dateConsultationOffreState: dateConsultationOffreReducer(current.dateConsultationOffreState, action),
    derniereOffreConsulteeState: derniereOffreConsulteeReducer(current.derniereOffreConsulteeState, action),
    inAppFeedbackState: inAppFeedbackReducer(current.inAppFeedbackState, action),
    /*AUTOGENERATE-REDUX-APP-REDUCER-STATE*/
  );
}
