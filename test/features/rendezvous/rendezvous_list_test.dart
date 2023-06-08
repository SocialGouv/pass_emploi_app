import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous_list_result.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group("Rendez-vous list", () {
    final sut = StoreSut();

    group("when requesting in FUTUR", () {
      sut.when(() => RendezvousListRequestAction(RendezvousPeriod.FUTUR));

      test("should load and succeed when request succeeds", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldSucceedFutur()]);
      });

      test("shoud load and fail when request fails", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldFailFutur()]);
      });
    });

    group('when reloading in FUTUR', () {
      sut.when(() => RendezvousListRequestReloadAction(RendezvousPeriod.FUTUR));

      test("should reload and succeed when request succeeds", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldReloadFutur(), _shouldSucceedFutur()]);
      });

      test("shoud reload and fail when request fails", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldReloadFutur(), _shouldFailFutur()]);
      });
    });

    group("when requesting in PASSE", () {
      sut.when(() => RendezvousListRequestAction(RendezvousPeriod.PASSE));

      test("should load and succeed with concatenated rendezvous when request succeeds", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .rendezvousFutur([mockRendezvous(id: "futur")]) //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadPasse(), _shouldSucceedPasseAndKeepFutur()]);
      });

      test("shoud load and fail when request fails", () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryFailureStub(expectedUserId: "id")});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadPasse(), _shouldFailPasse()]);
      });
    });
  });
}

Matcher _shouldLoadFutur() =>
    StateMatch((state) => state.rendezvousListState.futurRendezVousStatus == RendezvousListStatus.LOADING);

Matcher _shouldReloadFutur() =>
    StateMatch((state) => state.rendezvousListState.futurRendezVousStatus == RendezvousListStatus.RELOADING);

Matcher _shouldLoadPasse() =>
    StateMatch((state) => state.rendezvousListState.pastRendezVousStatus == RendezvousListStatus.LOADING);

Matcher _shouldFailFutur() =>
    StateMatch((state) => state.rendezvousListState.futurRendezVousStatus == RendezvousListStatus.FAILURE);

Matcher _shouldFailPasse() =>
    StateMatch((state) => state.rendezvousListState.pastRendezVousStatus == RendezvousListStatus.FAILURE);

Matcher _shouldSucceedFutur() {
  return StateMatch(
    (state) => state.rendezvousListState.futurRendezVousStatus == RendezvousListStatus.SUCCESS,
    (state) {
      expect(state.rendezvousListState.rendezvous.length, 1);
      expect(state.rendezvousListState.rendezvous.first.id, 'futur');
      expect(state.rendezvousListState.dateDerniereMiseAJour, DateTime(2023, 1, 1));
    },
  );
}

Matcher _shouldSucceedPasseAndKeepFutur() {
  return StateMatch(
    (state) => state.rendezvousListState.futurRendezVousStatus == RendezvousListStatus.SUCCESS,
    (state) {
      expect(state.rendezvousListState.rendezvous.length, 2);
      expect(state.rendezvousListState.rendezvous[0].id, 'passe');
      expect(state.rendezvousListState.rendezvous[1].id, 'futur');
    },
  );
}

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositorySuccessStub({required this.expectedUserId}) : super(DioMock());

  @override
  Future<RendezvousListResult?> getRendezvousList(String userId, RendezvousPeriod period) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    final id = period == RendezvousPeriod.FUTUR ? "futur" : "passe";
    return RendezvousListResult(
      rendezvous: [mockRendezvous(id: id)],
      dateDerniereMiseAJour: period == RendezvousPeriod.FUTUR ? DateTime(2023, 1, 1) : null,
    );
  }
}

class RendezvousRepositoryFailureStub extends RendezvousRepository {
  final String expectedUserId;

  RendezvousRepositoryFailureStub({required this.expectedUserId}) : super(DioMock());

  @override
  Future<RendezvousListResult?> getRendezvousList(String userId, RendezvousPeriod period) async {
    if (userId != expectedUserId) throw Exception("Unexpected user ID: $userId");
    return null;
  }
}
