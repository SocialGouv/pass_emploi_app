import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_alerting_repository.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_bridge.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_token_repository.dart';
import 'package:pass_emploi_app/repositories/date_consultation_offre_repository.dart';
import 'package:pass_emploi_app/repositories/derniere_offre_consultee_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/developer_option_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_engagement/evenement_engagement_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/first_launch_onboarding_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/in_app_feedback_repository.dart';
import 'package:pass_emploi_app/repositories/matching_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/onboarding_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';
import 'package:pass_emploi_app/repositories/preferred_login_mode_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/usecases/piece_jointe/piece_jointe_use_case.dart';
import 'package:pass_emploi_app/utils/compress_image.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';

/*AUTOGENERATE-REDUX-TEST-MOCKS-REPOSITORY-IMPORT*/

import 'dio_mock.dart';
import 'fixtures.dart';

class MockAuthenticator extends Mock implements Authenticator {
  static MockAuthenticator successful() {
    final authenticator = MockAuthenticator();
    registerFallbackValue(AuthenticationMode.SIMILO);
    when(() => authenticator.login(any())).thenAnswer((_) async => SuccessAuthenticatorResponse());
    return authenticator;
  }
}

class MockAuthWrapper extends Mock implements AuthWrapper {}

class MockDetailsJeuneRepository extends Mock implements DetailsJeuneRepository {
  MockDetailsJeuneRepository() {
    when(() => get(any())).thenAnswer((_) async => null);
  }
}

class MockGetFavorisRepository extends Mock implements GetFavorisRepository {}

class MockServiceCiviqueDetailRepository extends Mock implements ServiceCiviqueDetailRepository {}

class MockImmersionDetailsRepository extends Mock implements ImmersionDetailsRepository {}

class MockOffreEmploiDetailsRepository extends Mock implements OffreEmploiDetailsRepository {}

class MockMatomoTracker extends Mock implements PassEmploiMatomoTracker {
  MockMatomoTracker() {
    when(() => setOptOut(optOut: any(named: 'optOut'))).thenAnswer((_) async => true);
  }
}

class MockTutorialRepository extends Mock implements TutorialRepository {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  MockFlutterSecureStorage() {
    when(() => read(key: any(named: "key"))).thenAnswer((_) async => null);
    when(() => write(key: any(named: "key"), value: any(named: "value"))).thenAnswer((_) async {});
    when(() => delete(key: any(named: "key"))).thenAnswer((_) async {});
    when(() => readAll()).thenAnswer((_) async => {});
  }

  void withAnyRead(String? value) {
    when(() => read(key: any(named: "key"))).thenAnswer((_) async => value);
  }
}

class MockSecteurActiviteQueryMapper extends Mock implements SecteurActiviteQueryMapper {}

class MockEvenementEmploiTypeQueryMapper extends Mock implements EvenementEmploiTypeQueryMapper {}

class MockPieceJointeSaver extends Mock implements PieceJointeSaver {
  void mockSaveFile() {
    registerFallbackValue(DioFakeResponse());
    when(
      () => saveFile(
        fileName: any(named: "fileName"),
        fileId: any(named: "fileId"),
        response: any(named: "response"),
      ),
    ).thenAnswer((_) async => "saved_path");
  }
}

class MockFirebaseInstanceIdGetter extends Mock implements FirebaseInstanceIdGetter {
  void mockGetFirebaseInstanceId() {
    when(() => getFirebaseInstanceId()).thenAnswer((_) async => "firebaseId");
  }
}

class MockPushNotificationManager extends Mock implements PushNotificationManager {
  void mockGetToken() {
    when(() => getToken()).thenAnswer((_) async => "token");
  }

  void mockHasNotificationBeenRequested(bool value) {
    when(() => hasNotificationBeenRequested()).thenAnswer((invocation) async => value);
  }

  void mockRequestPermission() {
    when(() => requestPermission()).thenAnswer((invocation) async {});
  }

  void mockOpenAppSettings() {
    when(() => openAppSettings()).thenAnswer((invocation) async {});
  }
}

class MockSessionMiloRepository extends Mock implements SessionMiloRepository {
  void mockGetListSuccess() {
    when(() => getList(userId: any(named: "userId"), filtrerEstInscrit: any(named: "filtrerEstInscrit")))
        .thenAnswer((_) async => [mockSessionMilo()]);
  }

  void mockGetListFailure() {
    when(() => getList(userId: any(named: "userId"), filtrerEstInscrit: any(named: "filtrerEstInscrit")))
        .thenAnswer((_) async => null);
  }

  void mockGetDetailsFailure() {
    when(() => getDetails(sessionId: any(named: "sessionId"), userId: any(named: "userId")))
        .thenAnswer((_) async => null);
  }

  void mockGetDetailsSuccess() {
    when(() => getDetails(sessionId: any(named: "sessionId"), userId: any(named: "userId")))
        .thenAnswer((_) async => mockSessionMiloDetails());
  }
}

class MockCacheStore extends Mock implements CacheStore {}

class MockConnectivityWrapper extends Mock implements ConnectivityWrapper {}

class MockMonSuiviRepository extends Mock implements MonSuiviRepository {}

class MockUserActionPendingCreationRepository extends Mock implements UserActionPendingCreationRepository {
  MockUserActionPendingCreationRepository() {
    registerFallbackValue(mockUserActionCreateRequest());
    when(() => getPendingActionCount()).thenAnswer((_) async => 0);
    when(() => save(any())).thenAnswer((_) async => 0);
    when(() => load()).thenAnswer((_) async => []);
  }
}

class MockRendezvousRepository extends Mock implements RendezvousRepository {}

class MockUserActionRepository extends Mock implements UserActionRepository {}

class MockEvenementEngagementRepository extends Mock implements EvenementEngagementRepository {}

class MockCvmBridge extends Mock implements CvmBridge {}

class MockCvmTokenRepository extends Mock implements CvmTokenRepository {}

class MockCvmAlertingRepository extends Mock implements CvmAlertingRepository {
  MockCvmAlertingRepository() {
    when(() => traceFailure()).thenAnswer((_) async {});
  }
}

class MockCampagneRecrutementRepository extends Mock implements CampagneRecrutementRepository {
  MockCampagneRecrutementRepository() {
    when(() => shouldShowCampagneRecrutement()).thenAnswer((_) async => false);
    when(() => dismissCampagneRecrutement()).thenAnswer((_) async => true);
    when(() => isFirstLaunch()).thenAnswer((_) async => true);
    when(() => setCampagneRecrutementInitialRead()).thenAnswer((_) async => true);
  }

  void withIsFirstLaunch(bool value) {
    when(() => isFirstLaunch()).thenAnswer((_) async => value);
  }

  void withShouldShowCampagneRecrutement(bool value) {
    when(() => shouldShowCampagneRecrutement()).thenAnswer((_) async => value);
  }
}

class MockPreferredLoginModeRepository extends Mock implements PreferredLoginModeRepository {
  MockPreferredLoginModeRepository() {
    registerFallbackValue(LoginMode.MILO);
    when(() => getPreferredMode()).thenAnswer((_) async => null);
    when(() => save(any())).thenAnswer((_) async {});
  }

  void verifySaveCalled() {
    verify(() => save(any())).called(1);
  }
}

class MockOnboardingRepository extends Mock implements OnboardingRepository {
  MockOnboardingRepository() {
    when(() => get()).thenAnswer((_) async => Onboarding());
  }
}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {
  MockRemoteConfigRepository() {
    when(() => maxLivingTimeInSecondsForMilo()).thenReturn(null);
    when(() => lastCampagneRecrutementId()).thenReturn(null);
    when(() => cvmActivationByAccompagnement()).thenReturn({});
    when(() => getIdsConseillerCvmEarlyAdopters()).thenReturn([]);
    when(() => monSuiviPoleEmploiStartDateInMonths()).thenReturn(1);
    when(() => withCje()).thenReturn(false);
  }
}

class MockFirstLaunchOnboardingRepository extends Mock implements FirstLaunchOnboardingRepository {
  MockFirstLaunchOnboardingRepository() {
    when(() => showFirstLaunchOnboarding()).thenAnswer((_) async => false);
  }
}

class MockDeveloperOptionRepository extends Mock implements DeveloperOptionRepository {}

class MockImageCompressor extends Mock implements ImageCompressor {}

class MockPieceJointeUseCase extends Mock implements PieceJointeUseCase {}

class MockMatchingDemarcheRepository extends Mock implements MatchingDemarcheRepository {}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

class MockDateConsultationOffreRepository extends Mock implements DateConsultationOffreRepository {
  MockDateConsultationOffreRepository() {
    when(() => get()).thenAnswer((_) async => {});
    when(() => set(any(), any())).thenAnswer((_) async {});
  }
}

class FakeOffreEmploiDto extends Mock implements OffreEmploiDto {}

class MockDerniereOffreConsulteeRepository extends Mock implements DerniereOffreConsulteeRepository {
  MockDerniereOffreConsulteeRepository() {
    registerFallbackValue(FakeOffreEmploiDto());
    when(() => get()).thenAnswer((_) async => null);
    when(() => set(any())).thenAnswer((_) async {});
  }
}

class MockInAppFeedbackRepository extends Mock implements InAppFeedbackRepository {}
/*AUTOGENERATE-REDUX-TEST-MOCKS-REPOSITORY-DECLARATION*/
