import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockFirebaseAuthWrapper _firebaseAuthWrapper;
  late MockMatomoTracker _tracker;

  setUp(() {
    _firebaseAuthWrapper = MockFirebaseAuthWrapper();
    when(() => _firebaseAuthWrapper.signOut()).thenAnswer((_) async => true);
    _tracker = MockMatomoTracker();
    when(() => _tracker.setOptOut(optout: any(named: 'optout'))).thenAnswer((_) async => true);
  });

  test("After logout user should be signed out from Firebase Auth", () async {
    // Given
    final store = givenState().store((f) {
      f.matomoTracker = _tracker;
      f.firebaseAuthWrapper = _firebaseAuthWrapper;
    });

    // When
    await store.dispatch(RequestLogoutAction());

    // Then
    verify(() => _firebaseAuthWrapper.signOut()).called(1);
  });
}

class MockFirebaseAuthWrapper extends Mock implements FirebaseAuthWrapper {}
