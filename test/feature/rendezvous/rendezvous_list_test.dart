import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group("Rendez-vous list", () {
    final sut = StoreSut();

    group("when requesting in FUTUR", () {
      sut.when(() => RendezvousRequestAction(RendezvousPeriod.FUTUR));

      test("should load and succeed when request succeed", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldSucceedFutur()]);
      });

      test("shoud load and fail when request fail", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldFailFutur()]);
      });
    });

    group("when requesting in PASSE", () {
      sut.when(() => RendezvousRequestAction(RendezvousPeriod.PASSE));

      test("should load and succeed with concatenated rendezvous when request succeed", () async {
        sut.givenStore = givenState().loggedInUser() //
            .rendezvousFutur([mockRendezvous(id: "futur")]) //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadPasse(), _shouldSucceedPasseAndKeepFutur()]);
      });

      test("shoud load and fail when request fail", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadPasse(), _shouldFailPasse()]);
      });
    });
  });
}

Matcher _shouldLoadFutur() =>
    StateMatch((state) => state.rendezvousState.futurRendezVousStatus == RendezvousStatus.LOADING);

Matcher _shouldLoadPasse() =>
    StateMatch((state) => state.rendezvousState.pastRendezVousStatus == RendezvousStatus.LOADING);

Matcher _shouldFailFutur() =>
    StateMatch((state) => state.rendezvousState.futurRendezVousStatus == RendezvousStatus.FAILURE);

Matcher _shouldFailPasse() =>
    StateMatch((state) => state.rendezvousState.pastRendezVousStatus == RendezvousStatus.FAILURE);

Matcher _shouldSucceedFutur() {
  return StateMatch(
    (state) => state.rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS,
    (state) {
      expect(state.rendezvousState.rendezvous.length, 1);
      expect(state.rendezvousState.rendezvous.first.id, 'futur');
    },
  );
}

Matcher _shouldSucceedPasseAndKeepFutur() {
  return StateMatch(
    (state) => state.rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS,
    (state) {
      expect(state.rendezvousState.rendezvous.length, 2);
      expect(state.rendezvousState.rendezvous[0].id, 'passe');
      expect(state.rendezvousState.rendezvous[1].id, 'futur');
    },
  );
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
