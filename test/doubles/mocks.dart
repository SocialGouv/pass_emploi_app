import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';

import 'dio_mock.dart';
import 'fixtures.dart';

class MockGetFavorisRepository extends Mock implements GetFavorisRepository {}

class MockServiceCiviqueDetailRepository extends Mock implements ServiceCiviqueDetailRepository {}

class MockImmersionDetailsRepository extends Mock implements ImmersionDetailsRepository {}

class MockOffreEmploiDetailsRepository extends Mock implements OffreEmploiDetailsRepository {}

class MockMatomoTracker extends Mock implements PassEmploiMatomoTracker {
  MockMatomoTracker() {
    when(() => setOptOut(optOut: any(named: 'optOut'))).thenAnswer((_) async => true);
  }
}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

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
    registerFallbackValue(dummyUserActionCreateRequest());
    when(() => getPendingActionCount()).thenAnswer((_) async => 0);
    when(() => save(any())).thenAnswer((_) async => 0);
    when(() => load()).thenAnswer((_) async => []);
  }
}
