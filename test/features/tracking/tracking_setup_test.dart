import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockMatomoTracker tracker;

  setUp(() => tracker = MockMatomoTracker());

  group('on bootstrap', () {
    test('should properly set user type dimension', () async {
      // Given
      final store = givenState().store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(BootstrapAction());

      // Then
      verify(() => tracker.setDimension('1', 'jeune')).called(1);
    });
  });

  group('on login', () {
    test('with MILO user should properly set structure and produit dimension', () async {
      // Given
      final store = givenState(configuration()).store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(
        LoginSuccessAction(mockUser(loginMode: LoginMode.MILO, accompagnement: Accompagnement.cej)),
      );

      // Then
      verify(() => tracker.setDimension('2', 'Mission Locale')).called(1);
      verify(() => tracker.setDimension('matomoDimensionProduitId', 'CEJ')).called(1);
    });

    test('with POLE_EMPLOI in CEJ accompagnement user should properly set structure and produit dimension', () async {
      // Given
      final store = givenState(configuration()).store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(
        LoginSuccessAction(mockUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej)),
      );

      // Then
      verify(() => tracker.setDimension('2', 'Pôle emploi')).called(1);
      verify(() => tracker.setDimension('matomoDimensionProduitId', 'CEJ')).called(1);
    });

    test('with POLE_EMPLOI in RSA accompagnement user should properly set structure and produit dimension', () async {
      // Given
      final store = givenState(configuration()).store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(
        LoginSuccessAction(mockUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.rsaFranceTravail)),
      );

      // Then
      verify(() => tracker.setDimension('2', 'Pôle emploi')).called(1);
      verify(() => tracker.setDimension('matomoDimensionProduitId', 'BRSA')).called(1);
    });

    test('with POLE_EMPLOI in AIJ accompagnement user should properly set structure and produit dimension', () async {
      // Given
      final store = givenState(configuration()).store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(
        LoginSuccessAction(mockUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.aij)),
      );

      // Then
      verify(() => tracker.setDimension('2', 'Pôle emploi')).called(1);
      verify(() => tracker.setDimension('matomoDimensionProduitId', 'AIJ')).called(1);
    });
  });

  group('on connectivity updated', () {
    test('with connectivity should properly set avac connexion dimension', () async {
      // Given
      final store = givenState(configuration()).store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(ConnectivityUpdatedAction([ConnectivityResult.wifi]));

      // Then
      verify(() => tracker.setDimension('matomoDimensionAvecConnexionId', 'true')).called(1);
    });

    test('without connectivity should properly set avac connexion dimension', () async {
      // Given
      final store = givenState(configuration()).store((f) => f.matomoTracker = tracker);

      // When
      await store.dispatch(ConnectivityUpdatedAction([ConnectivityResult.none]));

      // Then
      verify(() => tracker.setDimension('matomoDimensionAvecConnexionId', 'false')).called(1);
    });
  });
}
