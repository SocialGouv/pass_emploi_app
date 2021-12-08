import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';

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
    test('user is properly logged in when login successes', () async {
      // Given
      factory.authenticator = AuthenticatorLoggedInStub();
      final store = factory.initializeReduxStore(initialState: AppState.initialState());
      final displayedLoading = store.onChange.any((element) => element.loginState is LoginLoadingState);
      final result = store.onChange.firstWhere((element) => element.loginState is LoggedInState);
      store.dispatch(RequestLoginAction());

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
      store.dispatch(RequestLoginAction());

      // When
      final AppState resultState = await result;

      // Then
      expect(await displayedLoading, true);
      expect(resultState.loginState, isA<LoginFailureState>());
    });
  });

  test("On logout, state is fully reset", () async {
    // Given
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginState.notLoggedIn(),
        rendezvousState: RendezvousState.loading(),
      ),
    );
    final result = store.onChange.firstWhere((element) => element is AppState);
    store.dispatch(RequestLogoutAction());

    // When
    final AppState resultState = await result;

    // Then
    expect(resultState.loginState, isA<LoginNotInitializedState>());
    expect(resultState.rendezvousState, isA<RendezvousNotInitializedState>());
  });
}
