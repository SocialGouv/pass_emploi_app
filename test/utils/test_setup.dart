import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_factory.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/service_civique_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';

class TestStoreFactory {
  Authenticator authenticator = DummyAuthenticator();
  PageActionRepository pageActionRepository = DummyPageActionRepository();
  PageDemarcheRepository pageDemarcheRepository = DummyPageDemarcheRepository();
  RendezvousRepository rendezvousRepository = DummyRendezvousRepository();
  ChatRepository chatRepository = DummyChatRepository();
  OffreEmploiRepository offreEmploiRepository = DummyOffreEmploiRepository();
  OffreEmploiDetailsRepository detailedOfferRepository = DummyDetailedRepository();
  RegisterTokenRepository registerTokenRepository = DummyRegisterTokenRepository();
  Crashlytics crashlytics = DummyCrashlytics();
  OffreEmploiFavorisRepository offreEmploiFavorisRepository = DummyOffreEmploiFavorisRepository();
  SearchLocationRepository searchLocationRepository = DummySearchLocationRepository();
  MetierRepository metierRepository = MetierRepository();
  ImmersionRepository immersionRepository = DummyImmersionRepository();
  ImmersionDetailsRepository immersionDetailsRepository = DummyImmersionDetailsRepository();
  ImmersionFavorisRepository immersionFavorisRepository = DummyImmersionFavorisRepository();
  FirebaseAuthRepository firebaseAuthRepository = DummyFirebaseAuthRepository();
  FirebaseAuthWrapper firebaseAuthWrapper = DummyFirebaseAuthWrapper();
  ChatCrypto chatCrypto = DummyChatCrypto();
  TrackingEventRepository trackingEventRepository = DummyTrackingEventRepository();
  OffreEmploiSavedSearchRepository offreEmploiSavedSearchRepository = DummyOffreEmploiSavedSearchRepository();
  ImmersionSavedSearchRepository immersionSavedSearchRepository = DummyImmersionSavedSearchRepository();
  ServiceCiviqueSavedSearchRepository serviceCiviqueSavedSearchRepository = DummyServiceCiviqueSavedSearchRepository();
  GetSavedSearchRepository getSavedSearchRepository = DummyGetSavedSearchRepository();
  SavedSearchDeleteRepository savedSearchDeleteRepository = DummySavedSearchDeleteRepository();
  ServiceCiviqueRepository serviceCiviqueRepository = DummyServiceCiviqueRepository();
  ServiceCiviqueDetailRepository serviceCiviqueDetailRepository = DummyServiceCiviqueDetailRepository();
  ServiceCiviqueFavorisRepository serviceCiviqueFavorisRepository = DummyServiceCiviqueFavorisRepository();
  DetailsJeuneRepository detailsJeuneRepository = DummyDetailsJeuneRepository();
  SuppressionCompteRepository suppressionCompteRepository = DummySuppressionCompteRepository();
  CampagneRepository campagneRepository = DummyCampagneRepository();
  ModeDemoRepository demoRepository = ModeDemoRepository();
  MatomoTracker matomoTracker = DummyMatomoTracker();
  UpdateDemarcheRepository updateDemarcheRepository = DummyUpdateDemarcheRepository();
  CreateDemarcheRepository createDemarcheRepository = DummySuccessCreateDemarcheRepository();
  SearchDemarcheRepository searchDemarcheRepository = DummyDemarcheDuReferentielRepository();
  PieceJointeRepository pieceJointeRepository = DummyPieceJointeRepository();
  TutorialRepository tutorialRepository = DummyTutorialRepository();
  PartageActiviteRepository partageActiviteRepository = DummyPartageActiviteRepository();
  RatingRepository ratingRepository = DummyRatingRepository();
  ActionCommentaireRepository actionCommentaireRepository = DummyActionCommentaireRepository();
  AgendaRepository agendaRepository = DummyAgendaRepository();
  SuggestionsRechercheRepository suggestionsRechercheRepository = DummySuggestionsRechercheRepository();

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return StoreFactory(
      authenticator,
      crashlytics,
      chatCrypto,
      pageActionRepository,
      pageDemarcheRepository,
      rendezvousRepository,
      offreEmploiRepository,
      chatRepository,
      registerTokenRepository,
      detailedOfferRepository,
      offreEmploiFavorisRepository,
      immersionFavorisRepository,
      serviceCiviqueFavorisRepository,
      searchLocationRepository,
      metierRepository,
      immersionRepository,
      immersionDetailsRepository,
      firebaseAuthRepository,
      firebaseAuthWrapper,
      trackingEventRepository,
      offreEmploiSavedSearchRepository,
      immersionSavedSearchRepository,
      serviceCiviqueSavedSearchRepository,
      getSavedSearchRepository,
      savedSearchDeleteRepository,
      serviceCiviqueRepository,
      serviceCiviqueDetailRepository,
      detailsJeuneRepository,
      suppressionCompteRepository,
      demoRepository,
      campagneRepository,
      matomoTracker,
      updateDemarcheRepository,
      createDemarcheRepository,
      searchDemarcheRepository,
      pieceJointeRepository,
      tutorialRepository,
      partageActiviteRepository,
      ratingRepository,
      actionCommentaireRepository,
      agendaRepository,
      suggestionsRechercheRepository,
    ).initializeReduxStore(initialState: initialState);
  }
}
