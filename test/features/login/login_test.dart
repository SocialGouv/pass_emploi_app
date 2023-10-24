import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
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

  setUp(() {
    when(() => matomoTracker.setOptOut(optOut: any(named: 'optout'))).thenAnswer((_) async => true);
  });

  group('On bootstrap…', () {
    sut.when(() => BootstrapAction());

    test('user is properly logged in if she was previously logged in', () async {
      // Given
      when(() => authenticator.isLoggedIn()).thenAnswer((_) async => true);
      when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('MILO'));
      sut.givenStore = givenState().store((f) => f.authenticator = authenticator);

      // Then
      sut.thenExpectChangingStatesThroughOrder([_shouldBeLoggedInWithMode(LoginMode.MILO)]);
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
    group('with mode PASS_EMPLOI', () {
      sut.when(() => RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      test('user is properly logged in with GENERIC authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.GENERIC))
            .thenAnswer((_) async => AuthenticatorResponse.SUCCESS);
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('---'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldBeLoggedInWithMode(LoginMode.PASS_EMPLOI)]);
      });
    });

    group('with mode SIMILO', () {
      sut.when(() => RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      test('user is properly logged in with SIMILO authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.SIMILO))
            .thenAnswer((_) async => AuthenticatorResponse.SUCCESS);
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('MILO'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldBeLoggedInWithMode(LoginMode.MILO)]);
      });
    });

    group('with mode POLE_EMPLOI in CEJ application', () {
      sut.when(() => RequestLoginAction(RequestLoginMode.POLE_EMPLOI));

      test('user is properly logged in with POLE_EMPLOI authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.POLE_EMPLOI))
            .thenAnswer((_) async => AuthenticatorResponse.SUCCESS);
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('POLE_EMPLOI'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldBeLoggedInWithMode(LoginMode.POLE_EMPLOI)]);
      });
    });

    group('with mode POLE_EMPLOI in BRSA application', () {
      sut.when(() => RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      test('user is properly logged in with POLE_EMPLOI authentication mode', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.POLE_EMPLOI))
            .thenAnswer((_) async => AuthenticatorResponse.SUCCESS);
        when(() => authenticator.idToken()).thenAnswer((_) async => authIdToken('POLE_EMPLOI_BRSA'));
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldBeLoggedInWithMode(LoginMode.POLE_EMPLOI)]);
      });
    });

    group('when login fails', () {
      sut.when(() => RequestLoginAction(RequestLoginMode.SIMILO));

      test('user is not logged in', () async {
        // Given
        when(() => authenticator.login(AuthenticationMode.SIMILO))
            .thenAnswer((_) async => AuthenticatorResponse.FAILURE);
        sut.givenStore = givenState().store((f) {
          f.authenticator = authenticator;
          f.matomoTracker = matomoTracker;
        });

        // Then
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });

  group('On logout…', () {
    test('user is logged out from authenticator and state is fully reset except for configuration', () async {
      // Given
      when(() => authenticator.logout()).thenAnswer((_) async => true);
      final Store<AppState> store =
          givenState(configuration(flavor: Flavor.PROD)).loggedInUser().loadingFutureRendezvous().store((f) {
        f.authenticator = authenticator;
        f.matomoTracker = matomoTracker;
      });

      // When
      await store.dispatch(RequestLogoutAction());

      // Then
      expect(store.state.loginState is LoginNotInitializedState, isTrue);
      expect(store.state.rendezvousListState.isNotInitialized(), isTrue);
      expect(store.state.configurationState.getFlavor(), Flavor.PROD);
      verify(() => authenticator.logout()).called(1);
    });
  });
}

Matcher _shouldBeLoggedInWithMode(LoginMode loginMode) {
  return StateIs<LoginSuccessState>(
    (state) => state.loginState,
    (state) => expect(state.user, user(loginMode)),
  );
}

Matcher _shouldNotBeLoggedIn() => StateIs<UserNotLoggedInState>((state) => state.loginState);

Matcher _shouldLoad() => StateIs<LoginLoadingState>((state) => state.loginState);

Matcher _shouldFail() => StateIs<LoginFailureState>((state) => state.loginState);

AuthIdToken authIdToken(String loginMode) => AuthIdToken(
      userId: 'id',
      firstName: 'F',
      lastName: 'L',
      email: 'first.last@mail.fr',
      issuedAt: 90000000,
      expiresAt: 100000000,
      loginMode: loginMode,
    );

User user(LoginMode loginMode) => User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: "first.last@mail.fr",
      loginMode: loginMode,
    );

class MockAuthenticator extends Mock implements Authenticator {}
