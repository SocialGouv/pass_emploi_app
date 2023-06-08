import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockMatomoTracker _tracker;

  setUp(() => _tracker = MockMatomoTracker());

  group('on bootstrap', () {
    test('should properly set user type dimension', () async {
      // Given
      final store = givenState(configuration(brand: Brand.cej)) //
          .store((f) => f.matomoTracker = _tracker);

      // When
      await store.dispatch(BootstrapAction());

      // Then
      verify(() => _tracker.setDimension('1', 'jeune')).called(1);
    });

    test('in CEJ app should properly set brand dimension', () async {
      // Given
      final store = givenState(configuration(brand: Brand.cej)) //
          .store((f) => f.matomoTracker = _tracker);

      // When
      await store.dispatch(BootstrapAction());

      // Then
      verify(() => _tracker.setDimension('matomoDimensionProduitId', 'CEJ')).called(1);
    });

    test('in BRSA app should properly set brand dimension', () async {
      // Given
      final store = givenState(configuration(brand: Brand.brsa)) //
          .store((f) => f.matomoTracker = _tracker);

      // When
      await store.dispatch(BootstrapAction());

      // Then
      verify(() => _tracker.setDimension('matomoDimensionProduitId', 'BRSA')).called(1);
    });
  });

  group('on login', () {
    test('with MILO user should properly set structure dimension', () async {
      // Given
      final store = givenState().store((f) => f.matomoTracker = _tracker);

      // When
      await store.dispatch(LoginSuccessAction(mockUser(loginMode: LoginMode.MILO)));

      // Then
      verify(() => _tracker.setDimension('2', 'Mission Locale')).called(1);
    });

    test('with POLE_EMPLOI user should properly set structure dimension', () async {
      // Given
      final store = givenState().store((f) => f.matomoTracker = _tracker);

      // When
      await store.dispatch(LoginSuccessAction(mockUser(loginMode: LoginMode.POLE_EMPLOI)));

      // Then
      verify(() => _tracker.setDimension('2', 'Pôle emploi')).called(1);
    });
  });
}
