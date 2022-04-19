import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  group("rendezvous request action", () {
    test("if user is not logged in should do nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final store = testStoreFactory.initializeReduxStore(
        initialState: AppState.initialState().copyWith(loginState: LoginFailureState()),
      );
      final unchangedRendezvousState = store.onChange.any((e) => e.rendezvousState is RendezvousNotInitializedState);

      // When
      store.dispatch(RendezvousRequestAction());

      // Then
      expect(await unchangedRendezvousState, true);
    });

    group("if user is logged in should fetch rendezvous and…", () {
      test("update state with success if repository returns something", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id");
        final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

        final displayedLoading = store.onChange.any((e) => e.rendezvousState is RendezvousLoadingState);
        final successAppState = store.onChange.firstWhere((e) => e.rendezvousState is RendezvousSuccessState);

        // When
        store.dispatch(RendezvousRequestAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await successAppState;
        expect((appState.rendezvousState as RendezvousSuccessState).rendezvous.length, 1);
        expect((appState.rendezvousState as RendezvousSuccessState).rendezvous.first.id, '1');
      });

      test("update state with failure if repository returns nothing", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id");
        final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

        final displayedLoading = store.onChange.any((e) => e.rendezvousState is RendezvousLoadingState);
        final failureAppState = store.onChange.firstWhere((e) => e.rendezvousState is RendezvousFailureState);

        // When
        store.dispatch(RendezvousRequestAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await failureAppState;
        expect(appState.rendezvousState is RendezvousFailureState, isTrue);
      });
    });
  });
}

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositorySuccessStub({required this.expectedUserId}) : super("", DummyHttpClient());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return [mockRendezvous(id: '1')];
  }
}

class RendezvousRepositoryFailureStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositoryFailureStub({required this.expectedUserId}) : super("", DummyHttpClient());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return null;
  }
}
