import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';

import '../doubles/dummies.dart';
import '../utils/test_setup.dart';

void main() {
  group("rendezvous request action", () {
    test("if user is not logged in should do nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final store = testStoreFactory.initializeReduxStore(
        initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
      );

      final unchangedRendezvousState =
          store.onChange.any((element) => element.rendezvousState is RendezvousNotInitializedState);

      // When
      store.dispatch(RequestRendezvousAction());

      // Then
      expect(await unchangedRendezvousState, true);
    });

    group("if user is logged in should fetch rendezvous and…", () {
      final _user = User(id: "id", firstName: "f", lastName: "l");

      test("update state with success if repository returns something", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id");
        final store = testStoreFactory.initializeReduxStore(
          initialState: AppState.initialState().copyWith(loginState: LoginState.loggedIn(_user)),
        );

        final displayedLoading = store.onChange.any((element) => element.rendezvousState is RendezvousLoadingState);
        final successAppState =
            store.onChange.firstWhere((element) => element.rendezvousState is RendezvousSuccessState);

        // When
        store.dispatch(RequestRendezvousAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await successAppState;
        expect((appState.rendezvousState as RendezvousSuccessState).rendezvous.length, 1);
        expect((appState.rendezvousState as RendezvousSuccessState).rendezvous[0].date, DateTime(2022));
      });

      test("update state with failure if repository returns nothing", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id");
        final store = testStoreFactory.initializeReduxStore(
          initialState: AppState.initialState().copyWith(loginState: LoginState.loggedIn(_user)),
        );

        final displayedLoading = store.onChange.any((element) => element.rendezvousState is RendezvousLoadingState);
        final failureAppState =
            store.onChange.firstWhere((element) => element.rendezvousState is RendezvousFailureState);

        // When
        store.dispatch(RequestRendezvousAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await failureAppState;
        expect(appState.rendezvousState is RendezvousFailureState, true);
      });
    });
  });
}

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositorySuccessStub({required this.expectedUserId}) : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return [Rendezvous(id: '', date: DateTime(2022), title: '', subtitle: '', comment: '', duration: '', modality: '')];
  }
}

class RendezvousRepositoryFailureStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositoryFailureStub({required this.expectedUserId}) : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return null;
  }
}
