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
    test("when user is not logged in should do nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final store = testStoreFactory.initializeReduxStore(
        initialState: AppState.initialState().copyWith(loginState: LoginFailureState()),
      );
      final unchangedRendezvousState = store.onChange.any((e) => e.rendezvousState.isNotInitialized());

      // When
      store.dispatch(RendezvousRequestAction(RendezvousPeriod.FUTUR));

      // Then
      expect(await unchangedRendezvousState, true);
    });

    group("when user is logged in", () {
      group("when fetching rendez-vous futurs", () {
        test("should update to success state", () async {
          // Given
          final testStoreFactory = TestStoreFactory();
          testStoreFactory.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id");
          final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

          final displayedLoading =
              store.onChange.any((e) => e.rendezvousState.futurRendezVousStatus == RendezvousStatus.LOADING);
          final successAppState =
              store.onChange.firstWhere((e) => e.rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS);

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.FUTUR));

          // Then
          expect(await displayedLoading, true);
          final appState = await successAppState;
          expect(appState.rendezvousState.rendezvous.length, 1);
          expect(appState.rendezvousState.rendezvous.first.id, 'futur');
        });

        test("should update to failure state", () async {
          // Given
          final testStoreFactory = TestStoreFactory();
          testStoreFactory.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id");
          final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

          final displayedLoading =
              store.onChange.any((e) => e.rendezvousState.futurRendezVousStatus == RendezvousStatus.LOADING);
          final failureAppState =
              store.onChange.firstWhere((e) => e.rendezvousState.futurRendezVousStatus == RendezvousStatus.FAILURE);

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.FUTUR));

          // Then
          expect(await displayedLoading, true);
          final appState = await failureAppState;
          expect(appState.rendezvousState.futurRendezVousStatus == RendezvousStatus.FAILURE, isTrue);
        });
      });

      group("when fetching rendez-vous pass??s", () {
        test("should update to success state and concatenate rendezvous", () async {
          // Given
          final testStoreFactory = TestStoreFactory();
          testStoreFactory.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id");
          final rendezvousState = RendezvousState.successfulFuture([mockRendezvous(id: "futur")]);
          final store = testStoreFactory.initializeReduxStore(
            initialState: loggedInState().copyWith(rendezvousState: rendezvousState),
          );

          final displayedLoading =
              store.onChange.any((e) => e.rendezvousState.pastRendezVousStatus == RendezvousStatus.LOADING);
          final successAppState =
              store.onChange.firstWhere((e) => e.rendezvousState.pastRendezVousStatus == RendezvousStatus.SUCCESS);

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.PASSE));

          // Then
          expect(await displayedLoading, true);
          final appState = await successAppState;
          expect(appState.rendezvousState.rendezvous.length, 2);
          expect(appState.rendezvousState.rendezvous[0].id, 'passe');
          expect(appState.rendezvousState.rendezvous[1].id, 'futur');
        });

        test("should update to failure state", () async {
          // Given
          final testStoreFactory = TestStoreFactory();
          testStoreFactory.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id");
          final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

          final displayedLoading =
              store.onChange.any((e) => e.rendezvousState.pastRendezVousStatus == RendezvousStatus.LOADING);
          final failureAppState =
              store.onChange.firstWhere((e) => e.rendezvousState.pastRendezVousStatus == RendezvousStatus.FAILURE);

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.PASSE));

          // Then
          expect(await displayedLoading, true);
          final appState = await failureAppState;
          expect(appState.rendezvousState.pastRendezVousStatus == RendezvousStatus.FAILURE, isTrue);
        });
      });
    });
  });
}

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositorySuccessStub({required this.expectedUserId}) : super("", DummyHttpClient());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId, RendezvousPeriod period) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    final id = period == RendezvousPeriod.PASSE ? "passe" : "futur";
    return [mockRendezvous(id: id)];
  }
}

class RendezvousRepositoryFailureStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositoryFailureStub({required this.expectedUserId}) : super("", DummyHttpClient());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId, RendezvousPeriod period) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return null;
  }
}
