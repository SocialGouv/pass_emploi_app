import 'package:collection/collection.dart';
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
          return; // todo : ne marche pas chez moi, timeout

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

        test("should update to success state 71", () async {
          // Idée : écrire le moins de technique / détails dans le test, n'avoir qu'un tableau d'expect
          // ne pas delay 10ms, sur 1000 tests ça commencera à peser
          // avec des lambdas, je peux contrôler quand est exécuté quoi, pour derrière, dans la boite noire, faire les bons setup et obsrve et await... dans l'ordre que je veux, caché pour ici
          // aussi, je skip le 1er state, parce qu'au final ce n'est pas ce comportement qu'on veut tester. Parce que on pourrait aussi partir d'autres states (comme succes) et lancer le dispatch, ça doit fonctionner. Et parce que le onChange stream l'état initiale, on s'en fout nous, on veut voir ce qui change, pas la base, c'est du given. et ça fait écrire une ligne en moins.

          final sut = SUT71(); // note : ça pourrait être seyup pour tous les tests

          sut.given = () {
            return givenState()
                .loggedInUser() //
                .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});
          };

          sut.when = () => RendezvousRequestAction(RendezvousPeriod.FUTUR);

          sut.then = () {
            return [
              (AppState state) => expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.LOADING),
              (AppState state) {
                expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.SUCCESS);
                expect(state.rendezvousState.rendezvous.length, 1);
                expect(state.rendezvousState.rendezvous.first.id, 'futur');
              },
            ];
          };

          await sut.execute();
        });

        test("should update to success state 5", () async {
          // Idée : j'ai remarqué que 3 et 4 tournait vite. JE me suis demandé si on pouvait s'enlever le delay, et le faire marcher en inversant le then et when.

          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // Then
          store.thenExpectStateChanges(
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

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.FUTUR));
        });

        test("should update to success state 57", () async {
          // Idée : l'expérimentation 5 marche, et a le meilleur temps d'exec. J'essaie d'écrire le then comme mon SUT71.
          // Comme ça, on a les meilleurs en critère lisiblité et temps réunis.
          // aussi, je skip le 1er state
          // léger probleme restant : then et when inversé. ça pourrait se régler en passant par des lambdas pour given et when, et le then est une fonction qui prend le tableau, setup avec les autres lambdas, puis execute (on mix le then et execute de mon SUT71)

          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // Then
          store.then57([
            (AppState state) => expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.LOADING),
            (AppState state) {
              expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.SUCCESS);
              expect(state.rendezvousState.rendezvous.length, 1);
              expect(state.rendezvousState.rendezvous.first.id, 'futur');
            },
          ]);

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.FUTUR));
        });

        test("should update to success state 572", () async {
          // Idée : j'ai essayé de ne pas appeler la méthode expect ici pour avoir un predicate qui return le bool écris dans le test,
          // mais en cas d'erreur, le log est illisible

          // Given
          final Store<AppState> store = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          // Then
          store.then572([
            (AppState state) => state.rendezvousState.futurRendezVousStatus == RendezvousStatus.LOADING,
            (AppState state) {
              return state.rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS &&
                  state.rendezvousState.rendezvous.length == 1 &&
                  state.rendezvousState.rendezvous.first.id == 'futur';
            },
          ]);

          // When
          store.dispatch(RendezvousRequestAction(RendezvousPeriod.FUTUR));
        });

        test("should update to success state 573", () async {
          // Idée : avoir les benefices du 57, et enlever le problème d'ordre

          final sut = SUT573();

          sut.givenStore = givenState()
              .loggedInUser() //
              .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

          sut.whenDispatching = () => RendezvousRequestAction(RendezvousPeriod.FUTUR);

          sut.thenExpectChangingStatesInOrder([
            (AppState state) => expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.LOADING),
            (AppState state) {
              expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.SUCCESS);
              expect(state.rendezvousState.rendezvous.length, 1);
              expect(state.rendezvousState.rendezvous.first.id, 'futur');
            },
          ]);
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

// TODO : intérêt à voir aussi, les temps d'exécution, un critère pour adopter ou non également.
// (je dirais critère 1 : lisibilité. et critère 2 : le temps)
// (si on a une solution qui est positive dans les deux, ou juste dans l'un des deux, c'est ok)
// - notre base : 160ms
// - 3 et 4 : 30ms (5.5 fois plus rapide)
// - 5 : 16ms (10 fois plus rapide !!!)
// - SUT 71 : 23ms (7 fois plus rapide)

typedef LambdaExpect71 = Function(AppState);

class SUT71 {
  late Store<AppState> Function() given;
  late dynamic Function() when;
  late List<LambdaExpect71> Function() then;

  Future<void> execute() async {
    final store = given();

    var thens = then();

    var changesStream = store.onChange.skip(1).take(thens.length).toList();

    store.dispatch(when());

    var changes = await changesStream;

    for (final pairs in IterableZip([changes, thens])) {
      var appState = pairs[0] as AppState;
      var expectationLambda = pairs[1] as LambdaExpect71;
      expectationLambda(appState);
    }
  }
}

class SUT573 {
  late Store<AppState> givenStore;
  late dynamic Function() whenDispatching;

  Future<void> thenExpectChangingStatesInOrder(List<LambdaExpect71> thens) async {
    givenStore.then57(thens);
    givenStore.dispatch(whenDispatching());
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

  Future<void> then57<S>(List<Function(AppState)> expects) async {
    var matchers = expects.map((unExpect) => predicate<AppState>((state) {
          unExpect(state);
          return true;
        }));

    return expect(onChange.skip(1), emitsInOrder(matchers));
  }

  Future<void> then572<S>(List<bool Function(AppState)> expects) async {
    var matchers = expects.map((unExpect) => predicate<AppState>((state) {
          return unExpect(state);
        }));
    return expect(onChange.skip(1), emitsInOrder(matchers));
  }
}

Matcher expectState<T>(Function(T) f, dynamic matcher, {Function(T)? additionalAssertions}) {
  return predicate<T>((state) {
    expect(f(state), matcher);
    additionalAssertions?.call(state);
    return true;
  });
}
