import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';
import '../favoris/offre_emploi_favoris_test.dart';

void main() {
  late TestStoreFactory factory;

  setUp(() {
    factory = TestStoreFactory();
    factory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  });

  group('On bootstrapâ€¦', () {
    test('user is properly logged in if she was previously logged in', () async {
      // Given
      factory.authenticator = AuthenticatorLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final result = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);
      store.dispatch(BootstrapAction());

      // When
      final AppState resultState = await result;

      // Then
      final loginState = resultState.loginState;
      expect(loginState is LoginSuccessState, isTrue);
      expect(
          (loginState as LoginSuccessState).user,
          User(
            id: "id",
            firstName: "F",
            lastName: "L",
            email: "first.last@milo.fr",
            loginMode: LoginMode.MILO,
          ));
    });

    test('user is not logged in if she was not previously logged in', () async {
      // Given
      factory.authenticator = AuthenticatorNotLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final result = store.onChange.firstWhere((e) => e.loginState is UserNotLoggedInState);
      store.dispatch(BootstrapAction());

      // When
      final AppState resultState = await result;

      // Then
      expect(resultState.loginState, isA<UserNotLoggedInState>());
    });
  });

  group('On request loginâ€¦', () {
    test('user is properly logged in when login successes in GENERIC authentication mode', () async {
      // Given
      factory.authenticator =
          AuthenticatorLoggedInStub(expectedMode: AuthenticationMode.GENERIC, authIdTokenLoginMode: "---");
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((e) => e.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);
      store.dispatch(RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(
          (loginState as LoginSuccessState).user,
          User(
            id: "id",
            firstName: "F",
            lastName: "L",
            email: "first.last@milo.fr",
            loginMode: LoginMode.PASS_EMPLOI,
          ));
    });

    test('user is properly logged in when login successes in SIMILO authentication mode', () async {
      // Given
      factory.authenticator =
          AuthenticatorLoggedInStub(expectedMode: AuthenticationMode.SIMILO, authIdTokenLoginMode: "MILO");
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((e) => e.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);
      store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(
          (loginState as LoginSuccessState).user,
          User(
            id: "id",
            firstName: "F",
            lastName: "L",
            email: "first.last@milo.fr",
            loginMode: LoginMode.MILO,
          ));
    });

    test('user is properly logged in when login successes in POLE_EMPLOI authentication mode', () async {
      // Given
      factory.authenticator =
          AuthenticatorLoggedInStub(expectedMode: AuthenticationMode.POLE_EMPLOI, authIdTokenLoginMode: "POLE_EMPLOI");
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((e) => e.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);
      store.dispatch(RequestLoginAction(RequestLoginMode.POLE_EMPLOI));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(
          (loginState as LoginSuccessState).user,
          User(
            id: "id",
            firstName: "F",
            lastName: "L",
            email: "first.last@milo.fr",
            loginMode: LoginMode.POLE_EMPLOI,
          ));
    });

    test('user is not logged in when login fails', () async {
      // Given
      factory.authenticator = AuthenticatorNotLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((e) => e.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((e) => e.loginState is LoginFailureState);
      store.dispatch(RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      expect(resultState.loginState is LoginFailureState, isTrue);
    });
  });

  test("On logout, user is logged out from authenticator and state is fully reset except for configuration", () async {
    // Given
    final authenticatorSpy = AuthenticatorSpy();
    factory.authenticator = authenticatorSpy;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState(configuration: configuration(flavor: Flavor.PROD)).copyWith(
        loginState: UserNotLoggedInState(),
        rendezvousState: RendezvousState.loadingFuture(),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(RequestLogoutAction());

    // Then
    final newState = await newStateFuture;
    expect(newState.loginState is LoginNotInitializedState, isTrue);
    expect(newState.rendezvousState.isNotInitialized(), isTrue);
    expect(newState.configurationState.getFlavor(), Flavor.PROD);
    expect(authenticatorSpy.logoutCalled, isTrue);
  });
}

class AuthenticatorSpy extends Authenticator {
  bool logoutCalled = false;

  AuthenticatorSpy() : super(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), SharedPreferencesSpy());

  @override
  Future<bool> logout() async {
    logoutCalled = true;
    return true;
  }
}
