import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group("Rendez-vous list", () {
    final sut = StoreSut();
    sut.setSkipFirstChange(true);

    group("when requesting in FUTUR", () {
      sut.when(() => RendezvousRequestAction(RendezvousPeriod.FUTUR));

      test("should load and succeed when request succeed", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesInOrder([_shouldLoadFutur, _shouldSucceedFutur]);
      });

      test("shoud load and fail when request fail", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesInOrder([_shouldLoadFutur, _shouldFailFutur]);
      });
    });

    group("when requesting in PASSE", () {
      sut.when(() => RendezvousRequestAction(RendezvousPeriod.PASSE));

      test("should load and succeed with concatenated rendezvous when request succeed", () async {
        sut.givenStore = givenState().loggedInUser() //
            .rendezvousFutur([mockRendezvous(id: "futur")]) //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesInOrder([_shouldLoadPasse, _shouldSucceedPasse]);
      });

      test("shoud load and fail when request fail", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesInOrder([_shouldLoadPasse, _shouldFailPasse]);
      });
    });
  });
}

void _shouldLoadFutur(AppState state) => expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.LOADING);

void _shouldLoadPasse(AppState state) => expect(state.rendezvousState.pastRendezVousStatus, RendezvousStatus.LOADING);

void _shouldFailFutur(AppState state) => expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.FAILURE);

void _shouldFailPasse(AppState state) => expect(state.rendezvousState.pastRendezVousStatus, RendezvousStatus.FAILURE);

void _shouldSucceedFutur(AppState state) {
  expect(state.rendezvousState.futurRendezVousStatus, RendezvousStatus.SUCCESS);
  expect(state.rendezvousState.rendezvous.length, 1);
  expect(state.rendezvousState.rendezvous.first.id, 'futur');
}

void _shouldSucceedPasse(AppState state) {
  expect(state.rendezvousState.pastRendezVousStatus, RendezvousStatus.SUCCESS);
  expect(state.rendezvousState.rendezvous.length, 2);
  expect(state.rendezvousState.rendezvous[0].id, 'passe');
  expect(state.rendezvousState.rendezvous[1].id, 'futur');
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
