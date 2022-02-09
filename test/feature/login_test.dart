import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/bootstrap_action.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';
import 'offre_emploi_favoris_test.dart';

void main() {
  late TestStoreFactory factory;

  setUp(() {
    factory = TestStoreFactory();
    factory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  });

  group('On bootstrap…', () {
    test('user is properly logged in if she was previously logged in', () async {
      // Given
      factory.authenticator = AuthenticatorLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final result = store.onChange.firstWhere((element) => element.loginState.isSuccess());
      store.dispatch(BootstrapAction());

      // When
      final AppState resultState = await result;

      // Then
      final loginState = resultState.loginState;
      expect(loginState.isSuccess(), isTrue);
      expect(
          loginState.getResultOrThrow(),
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
      final result = store.onChange.firstWhere((element) => element.loginState is UserNotLoggedInState);
      store.dispatch(BootstrapAction());

      // When
      final AppState resultState = await result;

      // Then
      expect(resultState.loginState, isA<UserNotLoggedInState>());
    });
  });

  group('On request login…', () {
    test('user is properly logged in when login successes in GENERIC authentication mode', () async {
      // Given
      factory.authenticator =
          AuthenticatorLoggedInStub(expectedMode: AuthenticationMode.GENERIC, authIdTokenLoginMode: "---");
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((element) => element.loginState.isLoading());
      final result = store.onChange.firstWhere((element) => element.loginState.isSuccess());
      store.dispatch(RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(
          loginState.getResultOrThrow(),
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
      final displayedLoading = store.onChange.any((element) => element.loginState.isLoading());
      final result = store.onChange.firstWhere((element) => element.loginState.isSuccess());
      store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(
          loginState.getResultOrThrow(),
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
      final displayedLoading = store.onChange.any((element) => element.loginState.isLoading());
      final result = store.onChange.firstWhere((element) => element.loginState.isSuccess());
      store.dispatch(RequestLoginAction(RequestLoginMode.POLE_EMPLOI));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(
          loginState.getResultOrThrow(),
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
      final displayedLoading = store.onChange.any((element) => element.loginState.isLoading());
      final result = store.onChange.firstWhere((element) => element.loginState.isFailure());
      store.dispatch(RequestLoginAction(RequestLoginMode.PASS_EMPLOI));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      expect(resultState.loginState.isFailure(), isTrue);
    });
  });

  test("On SYSTEM logout, state is fully reset except for configuration", () async {
    // Given
    final authenticatorSpy = AuthenticatorSpy();
    factory.authenticator = authenticatorSpy;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState(configuration: configuration(flavor: Flavor.PROD)).copyWith(
        loginState: UserNotLoggedInState(),
        rendezvousState: State<List<Rendezvous>>.loading(),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(RequestLogoutAction(LogoutRequester.SYSTEM));

    // Then
    final newState = await newStateFuture;
    expect(newState.loginState.isNotInitialized(), isTrue);
    expect(newState.rendezvousState.isNotInitialized(), isTrue);
    expect(newState.configurationState.getFlavor(), Flavor.PROD);
    expect(authenticatorSpy.logoutCalled, isFalse);
  });

  test("On USER logout, user is logged out from authenticator and state is fully reset except for configuration",
      () async {
    // Given
    final authenticatorSpy = AuthenticatorSpy();
    factory.authenticator = authenticatorSpy;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState(configuration: configuration(flavor: Flavor.PROD)).copyWith(
        loginState: UserNotLoggedInState(),
        rendezvousState: State<List<Rendezvous>>.loading(),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(RequestLogoutAction(LogoutRequester.USER));

    // Then
    final newState = await newStateFuture;
    expect(newState.loginState.isNotInitialized(), isTrue);
    expect(newState.rendezvousState.isNotInitialized(), isTrue);
    expect(newState.configurationState.getFlavor(), Flavor.PROD);
    expect(authenticatorSpy.logoutCalled, isTrue);
  });
}

class AuthenticatorSpy extends Authenticator {
  bool logoutCalled = false;

  AuthenticatorSpy() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

  @override
  Future<bool> logout() {
    logoutCalled = true;
    return Future.value(true);
  }
}
