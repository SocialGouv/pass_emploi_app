import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();
  final authenticator = MockAuthenticator();
  final matomoTracker = MockMatomoTracker();
  final preferredLoginModeRepository = MockPreferredLoginModeRepository();

  group('On bootstrap…', () {
    sut.whenDispatchingAction(() => BootstrapAction());

    test('user is properly logged in if she was previously logged in', () async {
      // Given
      when(() => authenticator.isLoggedIn()).thenAnswer((_) async => true);
      when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('MILO'));
      sut.givenStore = givenState().store((f) => f.authenticator = authenticator);

      // Then
      sut.thenExpectChangingStatesThroughOrder(
        [_shouldBeLoggedInWith(mode: LoginMode.MILO, accompagnement: Accompagnement.cej)],
      );
    });

    test('user is not logged in if she was not previously logged in', () async {
      // Given
      when(() => authenticator.isLoggedIn()).thenAnswer((_) async => false);
      sut.givenStore = givenState().store((f) => f.authenticator = authenticator);

      // Then
      sut.thenExpectChangingStatesThroughOrder([_shouldNotBeLoggedIn()]);
    });

    test('user is not logged in if she was previously logged in with a corrupted ID token & token should be deleted',
        () async {
      // Given
      final preferences = MockFlutterSecureStorage();
      when(() => preferences.read(key: 'idToken')).thenAnswer((_) async => 'CORRUPTED ID TOKEN');
      when(() => preferences.delete(key: 'idToken')).thenAnswer((_) async => true);
      final authenticator = Authenticator(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), preferences);
      sut.givenStore = givenState().store((f) => f.authenticator = authenticator);

      // Then
      sut.thenExpectChangingStatesThroughOrder([_shouldNotBeLoggedIn()]);
      await untilCalled(() => preferences.delete(key: any(named: 'key')));
      verify(() => preferences.delete(key: 'idToken')).called(1);
    });
  });

  group('On request login…', () {
    group('with mode SIMILO in CEJ accompagnement', () {
      sut.whenDispatchingAction(() => RequestLoginAction(LoginMode.MILO));

      test('user is properly logged in with SIMILO authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.SIMILO))
            .thenAnswer((_) async => SuccessAuthenticatorResponse());
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('MILO'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
          f.preferredLoginModeRepository = preferredLoginModeRepository;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([
          _shouldLoad(),
          _shouldBeLoggedInWith(mode: LoginMode.MILO, accompagnement: Accompagnement.cej),
        ]);
        preferredLoginModeRepository.verifySaveCalled();
      });
    });

    group('with mode POLE_EMPLOI in CEJ accompagnement', () {
      sut.whenDispatchingAction(() => RequestLoginAction(LoginMode.POLE_EMPLOI));

      test('user is properly logged in with POLE_EMPLOI authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.POLE_EMPLOI))
            .thenAnswer((_) async => SuccessAuthenticatorResponse());
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('POLE_EMPLOI'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
          f.preferredLoginModeRepository = preferredLoginModeRepository;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([
          _shouldLoad(),
          _shouldBeLoggedInWith(mode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej),
        ]);
        preferredLoginModeRepository.verifySaveCalled();
      });
    });

    group('with mode POLE_EMPLOI in RSA accompagnement', () {
      sut.whenDispatchingAction(() => RequestLoginAction(LoginMode.POLE_EMPLOI));

      test('user is properly logged in with POLE_EMPLOI authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.POLE_EMPLOI))
            .thenAnswer((_) async => SuccessAuthenticatorResponse());
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('POLE_EMPLOI_BRSA'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
          f.preferredLoginModeRepository = preferredLoginModeRepository;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([
          _shouldLoad(),
          _shouldBeLoggedInWith(mode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.rsaFranceTravail),
        ]);
        preferredLoginModeRepository.verifySaveCalled();
      });
    });

    group('with mode POLE_EMPLOI in AIJ accompagnement', () {
      sut.whenDispatchingAction(() => RequestLoginAction(LoginMode.POLE_EMPLOI));

      test('user is properly logged in with POLE_EMPLOI authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.POLE_EMPLOI))
            .thenAnswer((_) async => SuccessAuthenticatorResponse());
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('POLE_EMPLOI_AIJ'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
          f.preferredLoginModeRepository = preferredLoginModeRepository;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([
          _shouldLoad(),
          _shouldBeLoggedInWith(mode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.aij),
        ]);
        preferredLoginModeRepository.verifySaveCalled();
      });
    });

    group('when login fails for a generic reason', () {
      sut.whenDispatchingAction(() => RequestLoginAction(LoginMode.MILO));

      test('user is not logged in', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.SIMILO))
            .thenAnswer((_) async => FailureAuthenticatorResponse('error-message'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
          f.preferredLoginModeRepository = preferredLoginModeRepository;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFailWithMessage()]);
        preferredLoginModeRepository.verifySaveCalled();
      });
    });

    group('when login fails for a wrong clock device reason', () {
      sut.whenDispatchingAction(() => RequestLoginAction(LoginMode.MILO));

      test('user is not logged in', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.SIMILO))
            .thenAnswer((_) async => WrongDeviceClockAuthenticatorResponse());
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
          f.preferredLoginModeRepository = preferredLoginModeRepository;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFailBecauseOfWrongClock()]);
        preferredLoginModeRepository.verifySaveCalled();
      });
    });
  });

  group('On logout…', () {
    test('user is logged out from authenticator and state is fully reset except for configuration', () async {
      // Given
      when(() => authenticator.logout('id', LogoutReason.apiResponse401)).thenAnswer((_) async => true);
      final Store<AppState> store = givenState(configuration(flavor: Flavor.PROD)).loggedIn().store((f) {
        f.authenticator = authenticator;
        f.matomoTracker = matomoTracker;
      });

      // When
      await store.dispatch(RequestLogoutAction(LogoutReason.apiResponse401));

      // Then
      expect(store.state.loginState is LoginNotInitializedState, isTrue);
      expect(store.state.configurationState.getFlavor(), Flavor.PROD);
      verify(() => authenticator.logout('id', LogoutReason.apiResponse401)).called(1);
    });
  });
}

Matcher _shouldBeLoggedInWith({required LoginMode mode, required Accompagnement accompagnement}) {
  return StateIs<LoginSuccessState>(
    (state) => state.loginState,
    (state) => expect(state.user, user(mode, accompagnement)),
  );
}

Matcher _shouldNotBeLoggedIn() => StateIs<UserNotLoggedInState>((state) => state.loginState);

Matcher _shouldLoad() => StateIs<LoginLoadingState>((state) => state.loginState);

Matcher _shouldFailBecauseOfWrongClock() => StateIs<LoginWrongDeviceClockState>((state) => state.loginState);

Matcher _shouldFailWithMessage() {
  return StateIs<LoginGenericFailureState>(
    (state) => state.loginState,
    (state) => expect(state.message, 'error-message'),
  );
}

AuthIdToken authIdToken(String structure) => AuthIdToken(
      userId: 'id',
      firstName: 'F',
      lastName: 'L',
      email: 'first.last@mail.fr',
      issuedAt: 90000000,
      expiresAt: 100000000,
      structure: structure,
    );

User user(LoginMode loginMode, Accompagnement accompagnement) => User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: "first.last@mail.fr",
      loginMode: loginMode,
      accompagnement: accompagnement,
    );
