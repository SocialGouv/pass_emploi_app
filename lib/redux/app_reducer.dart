import 'package:pass_emploi_app/features/accueil/accueil_reducer.dart';
import 'package:pass_emploi_app/features/agenda/agenda_reducer.dart';
import 'package:pass_emploi_app/features/campagne/campagne_reducer.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_reducer.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_reducer.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_reducer.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_reducer.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_reducer.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_reducer.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_reducer.dart';
import 'package:pass_emploi_app/features/cv/cv_reducer.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_reducer.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_reducer.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_reducer.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_reducer.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_reducer.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_reducer.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_reducer.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_reducer.dart';
import 'package:pass_emploi_app/features/device_info/device_info_reducer.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_reducer.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_reducer.dart';
import 'package:pass_emploi_app/features/events/list/event_list_reducer.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_reducer.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_reducer.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_reducer.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_reducer.dart';
import 'package:pass_emploi_app/features/location/search_location_reducer.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_reducer.dart';
import 'package:pass_emploi_app/features/metier/search_metier_reducer.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_reducer.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_reducer.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_reducer.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_reducer.dart';
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
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_reducer.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_reducer.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_reducer.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_reducer.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_reducer.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_reducer.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_reducer.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_reducer.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_reducer.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_reducer.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_reducer.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_reducer.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_reducer.dart';
import 'package:pass_emploi_app/models/evenement_emploi.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
/*AUTOGENERATE-REDUX-APP-REDUCER-IMPORT*/

AppState reducer(AppState current, dynamic action) {
  if (action is RequestLogoutAction) {
    return AppState.initialState(configuration: current.configurationState.configuration);
  }
  return AppState(
    configurationState: current.configurationState,
    userActionListState: userActionListReducer(current.userActionListState, action),
    userActionCreateState: userActionCreateReducer(current.userActionCreateState, action),
    userActionUpdateState: userActionUpdateReducer(current.userActionUpdateState, action),
    userActionDeleteState: userActionDeleteReducer(current.userActionDeleteState, action),
    demarcheListState: demarcheListReducer(current.demarcheListState, action),
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
    rendezvousListState: rendezvousListReducer(current.rendezvousListState, action),
    rendezvousDetailsState: rendezvousDetailsReducer(current.rendezvousDetailsState, action),
    immersionDetailsState: immersionDetailsReducer(current.immersionDetailsState, action),
    offreEmploiSavedSearchCreateState: savedSearchCreateReducer<OffreEmploiSavedSearch>(
      current.offreEmploiSavedSearchCreateState,
      action,
    ),
    immersionSavedSearchCreateState: savedSearchCreateReducer<ImmersionSavedSearch>(
      current.immersionSavedSearchCreateState,
      action,
    ),
    serviceCiviqueSavedSearchCreateState: savedSearchCreateReducer<ServiceCiviqueSavedSearch>(
      current.serviceCiviqueSavedSearchCreateState,
      action,
    ),
    savedSearchListState: savedSearchListReducer(current.savedSearchListState, action),
    savedSearchDeleteState: savedSearchDeleteReducer(current.savedSearchDeleteState, action),
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
    partageActiviteState: partageActiviteReducer(current.partageActiviteState, action),
    partageActiviteUpdateState: partageActiviteUpdateReducer(current.partageActiviteUpdateState, action),
    ratingState: ratingReducer(current.ratingState, action),
    actionCommentaireListState: actionCommentaireListReducer(current.actionCommentaireListState, action),
    actionCommentaireCreateState: actionCommentaireCreateReducer(current.actionCommentaireCreateState, action),
    agendaState: agendaReducer(current.agendaState, action),
    suggestionsRechercheState: suggestionsRechercheReducer(current.suggestionsRechercheState, action),
    traiterSuggestionRechercheState: traiterSuggestionRechercheReducer(current.traiterSuggestionRechercheState, action),
    eventListState: eventListReducer(current.eventListState, action),
    deviceInfoState: deviceInfoReducer(current.deviceInfoState, action),
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
    /*AUTOGENERATE-REDUX-APP-REDUCER-STATE*/
  );
}
