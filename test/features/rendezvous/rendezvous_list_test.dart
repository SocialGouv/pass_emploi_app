import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous_list_result.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group("Rendez-vous list", () {
    final sut = StoreSut();
    final repository = MockRendezvousRepository();

    group("when requesting in FUTURE", () {
      sut.whenDispatchingAction(() => RendezvousListRequestAction(RendezvousPeriod.FUTUR));

      test("should load and succeed when both requests succeeds", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer(
          (_) async => RendezvousListResult(
            rendezvous: [mockRendezvous(id: 'futur')],
            dateDerniereMiseAJour: DateTime(2023, 1, 1),
          ),
        );

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListSuccess();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldSucceedFutur()]);
      });

      test("shoud load and fail when one request fails", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListSuccess();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldFailFutur()]);
      });

      test("should load and fail when both request fails", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListFailure();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldFailFutur()]);
      });
    });

    group('when reloading in FUTURE', () {
      sut.whenDispatchingAction(() => RendezvousListRequestReloadAction(RendezvousPeriod.FUTUR));

      test("should reload and succeed when both request succeeds", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer(
          (_) async => RendezvousListResult(
            rendezvous: [mockRendezvous(id: 'futur')],
            dateDerniereMiseAJour: DateTime(2023, 1, 1),
          ),
        );

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListSuccess();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldReloadFutur(), _shouldSucceedFutur()]);
      });

      test("shoud reload and fail when one request fails", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListFailure();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldReloadFutur(), _shouldFailFutur()]);
      });

      test("should reload and fail when both request fails", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListFailure();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldReloadFutur(), _shouldFailFutur()]);
      });
    });

    group("when requesting in PASSE", () {
      sut.whenDispatchingAction(() => RendezvousListRequestAction(RendezvousPeriod.PASSE));

      test("should load and succeed with concatenated rendezvous when request succeeds", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.PASSE)).thenAnswer(
          (_) async => RendezvousListResult(
            rendezvous: [mockRendezvous(id: 'passe')],
          ),
        );

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .rendezvousFutur(rendezvous: [mockRendezvous(id: "futur")], sessionsMilo: [mockSessionMilo()]) //
            .store((f) {
          f.rendezvousRepository = repository;
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadPasse(), _shouldSucceedPasseAndKeepFutur()]);
      });

      test("shoud load and fail when request fails", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.PASSE)).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) {
          f.rendezvousRepository = repository;
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadPasse(), _shouldFailPasse()]);
      });
    });

    group("when requesting with PE", () {
      sut.whenDispatchingAction(() => RendezvousListRequestAction(RendezvousPeriod.FUTUR));

      test("should have rendezvous only (no milo sessions)", () async {
        when(() => repository.getRendezvousList('id', RendezvousPeriod.FUTUR)).thenAnswer(
          (_) async => RendezvousListResult(
            rendezvous: [mockRendezvous(id: 'futur')],
            dateDerniereMiseAJour: DateTime(2023, 1, 1),
          ),
        );

        sut.givenStore = givenState()
            .loggedInPoleEmploiUser() //
            .store((f) {
          f.rendezvousRepository = repository;
          f.sessionMiloRepository = MockSessionMiloRepository()..mockGetListSuccess();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadFutur(), _shouldSucceedFuturWithOnlyRendezvous()]);
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
      expect(state.rendezvousListState.sessionsMilo, [mockSessionMilo()]);
    },
  );
}

Matcher _shouldSucceedFuturWithOnlyRendezvous() {
  return StateMatch(
    (state) => state.rendezvousListState.futurRendezVousStatus == RendezvousListStatus.SUCCESS,
    (state) {
      expect(state.rendezvousListState.rendezvous.length, 1);
      expect(state.rendezvousListState.rendezvous.first.id, 'futur');
      expect(state.rendezvousListState.dateDerniereMiseAJour, DateTime(2023, 1, 1));
      expect(state.rendezvousListState.sessionsMilo.isEmpty, true);
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
      expect(state.rendezvousListState.sessionsMilo, [mockSessionMilo()]);
    },
  );
}
