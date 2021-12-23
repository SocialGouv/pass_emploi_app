import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
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
      final result = store.onChange.firstWhere((element) => element.loginState is LoggedInState);
      store.dispatch(BootstrapAction());

      // When
      final AppState resultState = await result;

      // Then
      final loginState = resultState.loginState;
      expect(loginState, isA<LoggedInState>());
      expect((loginState as LoggedInState).user, User(id: "id", firstName: "F", lastName: "L"));
    });

    test('user is not logged in if she was not previously logged in', () async {
      // Given
      factory.authenticator = AuthenticatorNotLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final result = store.onChange.firstWhere((element) => element.loginState is NotLoggedInState);
      store.dispatch(BootstrapAction());

      // When
      final AppState resultState = await result;

      // Then
      expect(resultState.loginState, isA<NotLoggedInState>());
    });
  });

  group('On request login…', () {
    test('user is properly logged in when login successes in GENERIC authentication mode', () async {
      // Given
      factory.authenticator = AuthenticatorLoggedInStub(expectedMode: AuthenticationMode.GENERIC);
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((element) => element.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((element) => element.loginState is LoggedInState);
      store.dispatch(RequestLoginAction(RequestLoginMode.GENERIC));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(loginState, isA<LoggedInState>());
      expect((loginState as LoggedInState).user, User(id: "id", firstName: "F", lastName: "L"));
    });

    test('user is properly logged in when login successes in SIMILO authentication mode', () async {
      // Given
      factory.authenticator = AuthenticatorLoggedInStub(expectedMode: AuthenticationMode.SIMILO);
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((element) => element.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((element) => element.loginState is LoggedInState);
      store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      final loginState = resultState.loginState;
      expect(loginState, isA<LoggedInState>());
      expect((loginState as LoggedInState).user, User(id: "id", firstName: "F", lastName: "L"));
    });

    test('user is not logged in when login fails', () async {
      // Given
      factory.authenticator = AuthenticatorNotLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((element) => element.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((element) => element.loginState is LoginFailureState);
      store.dispatch(RequestLoginAction(RequestLoginMode.GENERIC));

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      expect(resultState.loginState, isA<LoginFailureState>());
    });
  });

  test("On SYSTEM logout, state is fully reset", () async {
    // Given
    final authenticatorSpy = AuthenticatorSpy();
    factory.authenticator = authenticatorSpy;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginState.notLoggedIn(),
        rendezvousState: State<List<Rendezvous>>.loading(),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(RequestLogoutAction(LogoutRequester.SYSTEM));

    // Then
    final newState = await newStateFuture;
    expect(newState.loginState, isA<LoginNotInitializedState>());
    expect(newState.rendezvousState.isNotInitialized(), isTrue);
    expect(authenticatorSpy.logoutCalled, isFalse);
  });

  test("On USER logout, user is logged out from authenticator and state is fully reset", () async {
    // Given
    final authenticatorSpy = AuthenticatorSpy();
    factory.authenticator = authenticatorSpy;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginState.notLoggedIn(),
        rendezvousState: State<List<Rendezvous>>.loading(),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(RequestLogoutAction(LogoutRequester.USER));

    // Then
    final newState = await newStateFuture;
    expect(newState.loginState, isA<LoginNotInitializedState>());
    expect(newState.rendezvousState.isNotInitialized(), isTrue);
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
