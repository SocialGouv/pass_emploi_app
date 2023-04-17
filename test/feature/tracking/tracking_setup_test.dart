import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockMatomoTracker _tracker;

  setUp(() => _tracker = MockMatomoTracker());

  test('on bootstrap should properly set user type dimension', () async {
    // Given
    final store = givenState().store((f) => f.matomoTracker = _tracker);

    // When
    await store.dispatch(BootstrapAction());

    // Then
    verify(() => _tracker.setDimension('1', 'jeune')).called(1);
  });

  test('when MILO user is logged in should properly set structure dimension', () async {
    // Given
    final store = givenState().store((f) => f.matomoTracker = _tracker);

    // When
    await store.dispatch(LoginSuccessAction(mockUser(loginMode: LoginMode.MILO)));

    // Then
    verify(() => _tracker.setDimension('2', 'Mission Locale')).called(1);
  });

  test('when POLE_EMPLOI user is logged in should properly set structure dimension', () async {
    // Given
    final store = givenState().store((f) => f.matomoTracker = _tracker);

    // When
    await store.dispatch(LoginSuccessAction(mockUser(loginMode: LoginMode.POLE_EMPLOI)));

    // Then
    verify(() => _tracker.setDimension('2', 'Pôle emploi')).called(1);
  });
}
