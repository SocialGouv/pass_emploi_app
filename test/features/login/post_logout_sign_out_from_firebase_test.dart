import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockFirebaseAuthWrapper firebaseAuthWrapper;

  setUp(() {
    firebaseAuthWrapper = MockFirebaseAuthWrapper();
    when(() => firebaseAuthWrapper.signOut()).thenAnswer((_) async => true);
  });

  test("After logout user should be signed out from Firebase Auth", () async {
    // Given
    final store = givenState().store((f) {
      f.matomoTracker = MockMatomoTracker();
      f.firebaseAuthWrapper = firebaseAuthWrapper;
    });

    // When
    await store.dispatch(RequestLogoutAction(LogoutReason.userLogout));

    // Then
    verify(() => firebaseAuthWrapper.signOut()).called(1);
  });
}

class MockFirebaseAuthWrapper extends Mock implements FirebaseAuthWrapper {}
