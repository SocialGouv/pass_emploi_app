import 'dart:ffi';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

void main() {
  group("rendezvous request action", () {
    test("if user is not logged in should do nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final store = testStoreFactory.initializeReduxStore(
        initialState: AppState.initialState().copyWith(loginState: State<User>.failure()),
      );

      final unchangedRendezvousState = store.onChange.any((element) => element.rendezvousState.isNotInitialized());

      // When
      store.dispatch(RendezvousAction.request(Void));

      // Then
      expect(await unchangedRendezvousState, true);
    });

    group("if user is logged in should fetch rendezvous and…", () {
      test("update state with success if repository returns something", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id");
        final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

        final displayedLoading = store.onChange.any((element) => element.rendezvousState.isLoading());
        final successAppState = store.onChange.firstWhere((element) => element.rendezvousState.isSuccess());

        // When
        store.dispatch(RendezvousAction.request(Void));

        // Then
        expect(await displayedLoading, true);
        final appState = await successAppState;
        expect(appState.rendezvousState.getDataOrThrow().length, 1);
        expect(appState.rendezvousState.getDataOrThrow()[0].date, DateTime(2022));
      });

      test("update state with failure if repository returns nothing", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id");
        final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

        final displayedLoading = store.onChange.any((element) => element.rendezvousState.isLoading());
        final failureAppState = store.onChange.firstWhere((element) => element.rendezvousState.isFailure());

        // When
        store.dispatch(RendezvousAction.request(Void));

        // Then
        expect(await displayedLoading, true);
        final appState = await failureAppState;
        expect(appState.rendezvousState.isFailure(), isTrue);
      });
    });
  });
}

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositorySuccessStub({required this.expectedUserId}) : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Rendezvous>?> fetch(String userId, void request) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return [Rendezvous(id: '', date: DateTime(2022), title: '', subtitle: '', comment: '', duration: '', modality: '')];
  }
}

class RendezvousRepositoryFailureStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositoryFailureStub({required this.expectedUserId}) : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Rendezvous>?> fetch(String userId, void request) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return null;
  }
}
