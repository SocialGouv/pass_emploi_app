import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/auth/max_living_time_config.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:pass_emploi_app/repositories/auth/chat_security_repository.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_encryption_local_storage.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/service_civique_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';
/*AUTOGENERATE-REDUX-TEST-DUMMIES-REPOSITORY-IMPORT*/
import 'package:redux/redux.dart';
import 'package:synchronized/synchronized.dart';

import 'dio_mock.dart';
import 'fixtures.dart';
import 'mocks.dart';

class DummyPushNotificationManager extends PushNotificationManager {
  @override
  Future<String?> getToken() async => "";

  @override
  Future<void> init(Store<AppState> store) async {}
}

class DummyRegisterTokenRepository extends ConfigurationApplicationRepository {
  DummyRegisterTokenRepository() : super(DioMock(), DummyFirebaseInstanceIdGetter(), DummyPushNotificationManager());

  @override
  Future<void> configureApplication(String userId, String fuseauHoraire) async {}
}

class DummySharedPreferences extends FlutterSecureStorage {
  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return null;
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {}

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {}
}

class DummyAuthenticator extends Authenticator {
  DummyAuthenticator() : super(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), DummySharedPreferences());
}

class DummyAuthWrapper extends AuthWrapper {
  DummyAuthWrapper() : super(DummyFlutterAppAuth(), Lock());
}

class DummyMaxLivingTimeConfig extends MaxLivingTimeConfig {
  DummyMaxLivingTimeConfig() : super();

  @override
  int? maxLivingTimeInSecondsForMilo() => null;
}

class DummyFlutterAppAuth extends FlutterAppAuth {}

class DummyPageActionRepository extends PageActionRepository {
  DummyPageActionRepository() : super(DioMock());
}

class DummyPageDemarcheRepository extends PageDemarcheRepository {
  DummyPageDemarcheRepository() : super(DioMock());
}

class DummyRendezvousRepository extends RendezvousRepository {
  DummyRendezvousRepository() : super(DioMock());
}

class DummyChatRepository extends ChatRepository {
  DummyChatRepository() : super(DummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());

  @override
  Stream<List<Message>> messagesStream(String userId) async* {}

  @override
  Stream<ConseillerMessageInfo> chatStatusStream(String userId) async* {}
}

class DummyCrashlytics extends Crashlytics {
  @override
  void setCustomKey(String key, value) {}

  @override
  void setUserIdentifier(String identifier) {}

  @override
  void recordNonNetworkException(dynamic exception, [StackTrace? stack, Uri? failingEndpoint]) {}

  @override
  void recordNonNetworkExceptionUrl(dynamic exception, [StackTrace? stack, String? failingEndpoint]) {}
}

class DummyOffreEmploiRepository extends OffreEmploiRepository {
  DummyOffreEmploiRepository() : super(DioMock());
}

class DummyDetailedRepository extends OffreEmploiDetailsRepository {
  DummyDetailedRepository() : super(DioMock());
}

class DummyOffreEmploiFavorisRepository extends OffreEmploiFavorisRepository {
  DummyOffreEmploiFavorisRepository() : super(DioMock());
}

class DummySearchLocationRepository extends SearchLocationRepository {
  DummySearchLocationRepository() : super(DioMock());
}

class DummyChatSecurityRepository extends ChatSecurityRepository {
  DummyChatSecurityRepository() : super(DioMock());
}

class DummyFirebaseAuthWrapper extends FirebaseAuthWrapper {
  @override
  Future<bool> signInWithCustomToken(String token) async {
    return true;
  }

  @override
  Future<void> signOut() async {
    return;
  }
}

class DummyImmersionRepository extends ImmersionRepository {
  DummyImmersionRepository() : super(DioMock());
}

class DummyImmersionDetailsRepository extends ImmersionDetailsRepository {
  DummyImmersionDetailsRepository() : super(DioMock());
}

class DummyChatCrypto extends ChatCrypto {
  DummyChatCrypto() : super();
}

class DummyCryptoStorage extends Mock implements ChatEncryptionLocalStorage {
  @override
  Future<String> getChatEncryptionKey(String userId) async {
    return "";
  }

  @override
  Future<void> saveChatEncryptionKey(String secretKey, String userId) async {}
}

class NotInitializedDummyChatCrypto extends ChatCrypto {
  NotInitializedDummyChatCrypto() : super();

  @override
  bool isInitialized() {
    return false;
  }
}

class DummyTrackingEventRepository extends TrackingEventRepository {
  DummyTrackingEventRepository() : super(DioMock());
}

class DummyImmersionFavorisRepository extends ImmersionFavorisRepository {
  DummyImmersionFavorisRepository() : super(DioMock());
}

class DummyOffreEmploiSavedSearchRepository extends OffreEmploiSavedSearchRepository {
  DummyOffreEmploiSavedSearchRepository() : super(DioMock());
}

class DummyImmersionSavedSearchRepository extends ImmersionSavedSearchRepository {
  DummyImmersionSavedSearchRepository() : super(DioMock());
}

class DummyServiceCiviqueSavedSearchRepository extends ServiceCiviqueSavedSearchRepository {
  DummyServiceCiviqueSavedSearchRepository() : super(DioMock());
}

class DummyGetSavedSearchRepository extends GetSavedSearchRepository {
  DummyGetSavedSearchRepository() : super(DioMock(), null);
}

class DummySavedSearchDeleteRepository extends SavedSearchDeleteRepository {
  DummySavedSearchDeleteRepository() : super(DioMock());
}

class DummyServiceCiviqueRepository extends ServiceCiviqueRepository {
  DummyServiceCiviqueRepository() : super(DioMock());
}

class DummyServiceCiviqueDetailRepository extends ServiceCiviqueDetailRepository {
  DummyServiceCiviqueDetailRepository() : super(DioMock());
}

class DummyServiceCiviqueFavorisRepository extends ServiceCiviqueFavorisRepository {
  DummyServiceCiviqueFavorisRepository() : super(DioMock());
}

class DummyDetailsJeuneRepository extends DetailsJeuneRepository {
  DummyDetailsJeuneRepository() : super(DioMock());
}

class DummyLogoutRepository extends LogoutRepository {
  DummyLogoutRepository() : super(authIssuer: '', clientSecret: '', clientId: '');
}

class DummyPassEmploiCacheManager extends PassEmploiCacheManager {
  DummyPassEmploiCacheManager() : super(MockCacheStore(), '');

  @override
  Future<void> removeResource(CachedResource resourceToRemove, String userId) async {}

  @override
  Future<void> removeAllFavorisResources() async {}

  @override
  Future<void> removeActionCommentaireResource(String actionId) async {}

  @override
  Future<void> removeSuggestionsRechercheResource({required String userId}) async {}

  @override
  Future<void> emptyCache() => Future<void>.value();
}

class DummySuppressionCompteRepository extends SuppressionCompteRepository {
  DummySuppressionCompteRepository() : super(DioMock());
}

class DummyCampagneRepository extends CampagneRepository {
  DummyCampagneRepository() : super(DioMock());
}

class DummyUpdateDemarcheRepository extends UpdateDemarcheRepository {
  DummyUpdateDemarcheRepository() : super(DioMock());
}

class DummyPieceJointeRepository extends PieceJointeRepository {
  DummyPieceJointeRepository() : super(DioMock(), MockPieceJointeSaver());
}

class DummyTutorialRepository extends TutorialRepository {
  DummyTutorialRepository() : super(DummySharedPreferences());
}

class DummyPartageActiviteRepository extends PartageActiviteRepository {
  DummyPartageActiviteRepository() : super(DioMock());
}

class DummyModifyDemarcheRepository extends UpdateDemarcheRepository {
  DummyModifyDemarcheRepository() : super(DioMock());

  @override
  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    return null;
  }
}

class DummySuccessCreateDemarcheRepository extends CreateDemarcheRepository {
  DummySuccessCreateDemarcheRepository() : super(DioMock());
}

class DummyDemarcheDuReferentielRepository extends SearchDemarcheRepository {
  DummyDemarcheDuReferentielRepository() : super(DioMock());

  @override
  Future<List<DemarcheDuReferentiel>?> search(String query) async {
    return [];
  }
}

class DummyRatingRepository extends RatingRepository {
  DummyRatingRepository() : super(DummySharedPreferences());
}

class DummyActionCommentaireRepository extends ActionCommentaireRepository {
  DummyActionCommentaireRepository() : super(DioMock(), DummyPassEmploiCacheManager());
}

class DummyAgendaRepository extends AgendaRepository {
  DummyAgendaRepository() : super(DioMock());
}

class DummySuggestionsRechercheRepository extends SuggestionsRechercheRepository {
  DummySuggestionsRechercheRepository() : super(DioMock(), DummyPassEmploiCacheManager());
}

class DummyAnimationsCollectivesRepository extends AnimationsCollectivesRepository {
  DummyAnimationsCollectivesRepository() : super(DioMock());
}

class DummySessionMiloRepository extends SessionMiloRepository {
  DummySessionMiloRepository() : super(DioMock(), DummyDetailsJeuneRepository());
}

class DummyMetierRepository extends MetierRepository {
  DummyMetierRepository() : super(DioMock());
}

class DummyInstallationIdRepository extends InstallationIdRepository {
  DummyInstallationIdRepository() : super(DummySharedPreferences());
}

class DummyDiagorienteUrlsRepository extends DiagorienteUrlsRepository {
  DummyDiagorienteUrlsRepository() : super(DioMock());
}

class DummyDiagorienteMetiersFavorisRepository extends DiagorienteMetiersFavorisRepository {
  DummyDiagorienteMetiersFavorisRepository() : super(DioMock(), DummyPassEmploiCacheManager());
}

class DummyRecherchesRecentesRepository extends RecherchesRecentesRepository {
  DummyRecherchesRecentesRepository() : super(DummySharedPreferences());
}

class DummyFirebaseInstanceIdGetter extends FirebaseInstanceIdGetter {
  DummyFirebaseInstanceIdGetter() : super();
}

class DummyContactImmersionRepository extends ContactImmersionRepository {
  DummyContactImmersionRepository() : super(DioMock());
}

class DummyAccueilRepository extends AccueilRepository {
  DummyAccueilRepository() : super(DioMock());
}

class DummyCvRepository extends CvRepository {
  DummyCvRepository() : super(DioMock());
}

class DummyEvenementEmploiRepository extends EvenementEmploiRepository {
  DummyEvenementEmploiRepository()
      : super(
          DioMock(),
          MockSecteurActiviteQueryMapper(),
          MockEvenementEmploiTypeQueryMapper(),
        );
}

class DummyEvenementEmploiDetailsRepository extends EvenementEmploiDetailsRepository {
  DummyEvenementEmploiDetailsRepository() : super(DioMock());
}

class DummyThematiqueDemarcheRepository extends ThematiqueDemarcheRepository {
  DummyThematiqueDemarcheRepository() : super(DioMock());
}

class DummyTopDemarcheRepository extends TopDemarcheRepository {
  DummyTopDemarcheRepository() : super();
}

class DummyConnectivityWrapper extends Mock implements ConnectivityWrapper {}
/*AUTOGENERATE-REDUX-TEST-DUMMIES-REPOSITORY-DECLARATION*/
