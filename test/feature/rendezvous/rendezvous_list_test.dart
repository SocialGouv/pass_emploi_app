import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
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
        test("should update to success state 0", () async {
          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

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

        test("should update to success state 1", () async {
          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // When
          store.whenActionIsDispatched(RendezvousRequestAction(RendezvousPeriod.FUTUR));

          // Then
          expect(await store.onChange.any((e) => e.rendezvousState.futurRendezVousStatus == RendezvousStatus.LOADING),
              true);
          final appState = await store.onChange
              .firstWhere((e) => e.rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS);
          expect(appState.rendezvousState.rendezvous.length, 1);
          expect(appState.rendezvousState.rendezvous.first.id, 'futur');
        });

        test("should update to success state 2", () async {
          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // When
          store.whenActionIsDispatched(RendezvousRequestAction(RendezvousPeriod.FUTUR));

          // Then
          await expectLater(
            store.onChange.map((state) => state.rendezvousState),
            emitsInOrder([
              predicate<RendezvousState>((state) {
                expect(state.futurRendezVousStatus, RendezvousStatus.NOT_INITIALIZED);
                return true;
              }),
              predicate<RendezvousState>((state) {
                expect(state.futurRendezVousStatus, RendezvousStatus.LOADING);
                return true;
              }),
              predicate<RendezvousState>((state) {
                expect(state.futurRendezVousStatus, RendezvousStatus.SUCCESS);
                expect(state.rendezvous.length, 1);
                expect(state.rendezvous.first.id, 'futur');
                return true;
              })
            ]),
          );
        });

        test("should update to success state 3", () async {
          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // When
          store.whenActionIsDispatched(RendezvousRequestAction(RendezvousPeriod.FUTUR));

          // Then
          await expectLater(
            store.observe((state) => state.rendezvousState),
            emitsInOrder([
              expectState<RendezvousState>((state) => state.futurRendezVousStatus, RendezvousStatus.NOT_INITIALIZED),
              expectState<RendezvousState>((state) => state.futurRendezVousStatus, RendezvousStatus.LOADING),
              expectState<RendezvousState>(
                (state) => state.futurRendezVousStatus,
                RendezvousStatus.SUCCESS,
                additionalAssertions: (state) {
                  expect(state.rendezvous.length, 1);
                  expect(state.rendezvous.first.id, 'futur');
                },
              ),
            ]),
          );
        });

        test("should update to success state 4", () async {
          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // When
          store.whenActionIsDispatched(RendezvousRequestAction(RendezvousPeriod.FUTUR));

          // Then
          await store.thenExpectStateChanges(
            (state) => state.rendezvousState,
            [
              expectState<RendezvousState>((state) => state.futurRendezVousStatus, RendezvousStatus.NOT_INITIALIZED),
              expectState<RendezvousState>((state) => state.futurRendezVousStatus, RendezvousStatus.LOADING),
              expectState<RendezvousState>(
                (state) => state.futurRendezVousStatus,
                RendezvousStatus.SUCCESS,
                additionalAssertions: (state) {
                  expect(state.rendezvous.length, 1);
                  expect(state.rendezvous.first.id, 'futur');
                },
              ),
            ],
          );
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

      group("when fetching rendez-vous passés", () {
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

extension StoreTestExtension on Store<AppState> {
  Future<dynamic> whenActionIsDispatched(dynamic action) {
    return Future.delayed(Duration(milliseconds: 10)).then((_) => dispatch(action));
  }

  Stream<S> observe<S>(S Function(AppState state) convert) {
    return onChange.map((event) => convert(event));
  }

  Future<void> thenExpectStateChanges<S>(S Function(AppState state) convert, Iterable matchers) async {
    return expectLater(observe(convert), emitsInOrder(matchers));
  }
}

Matcher expectState<T>(Function(T) f, dynamic matcher, {Function(T)? additionalAssertions}) {
  return predicate<T>((state) {
    expect(f(state), matcher);
    additionalAssertions?.call(state);
    return true;
  });
}
