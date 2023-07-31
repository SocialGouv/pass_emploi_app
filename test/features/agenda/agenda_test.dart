import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Agenda', () {
    final sut = StoreSut();

    group("when requesting agenda", () {
      sut.when(() => AgendaRequestAction(DateTime(2022, 7, 7)));

      group('for Mission Local user', () {
        test('should load then succeed when request succeed', () {
          sut.givenStore = givenState()
              .loggedInMiloUser() //
              .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForMissionLocaleUser()]);
        });

        test('should load then fail when request fail', () {
          sut.givenStore = givenState()
              .loggedInMiloUser() //
              .store((f) => {f.agendaRepository = AgendaRepositoryErrorStub()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
        });
      });

      group('for Pole Emploi user', () {
        test('should load then succeed when request succeed', () {
          sut.givenStore = givenState()
              .loggedInPoleEmploiUser() //
              .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForPoleEmploiUser()]);
        });

        test('should load then fail when request fail', () {
          sut.givenStore = givenState()
              .loggedInPoleEmploiUser() //
              .store((f) => {f.agendaRepository = AgendaRepositoryErrorStub()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
        });
      });
    });
    group('when reloading agenda', () {
      sut.when(() => AgendaRequestReloadAction(DateTime(2022, 7, 7)));

      test('should reload then succeed when request succeed', () {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser() //
            .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldReload(), _shouldSucceedForPoleEmploiUser()]);
      });

      test('should reload then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser() //
            .store((f) => {f.agendaRepository = AgendaRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldReload(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<AgendaLoadingState>((state) => state.agendaState);

Matcher _shouldReload() => StateIs<AgendaReloadingState>((state) => state.agendaState);

Matcher _shouldFail() => StateIs<AgendaFailureState>((state) => state.agendaState);

Matcher _shouldSucceedForMissionLocaleUser() {
  return StateIs<AgendaSuccessState>(
    (state) => state.agendaState,
    (state) {
      expect(state.agenda.actions.length, 1);
      expect(state.agenda.rendezvous.length, 1);
      expect(state.agenda.sessionsMilo.length, 1);
    },
  );
}

Matcher _shouldSucceedForPoleEmploiUser() {
  return StateIs<AgendaSuccessState>(
    (state) => state.agendaState,
    (state) {
      expect(state.agenda.demarches.length, 1);
      expect(state.agenda.rendezvous.length, 1);
    },
  );
}

class AgendaRepositorySuccessStub extends AgendaRepository {
  AgendaRepositorySuccessStub() : super(DioMock());

  @override
  Future<Agenda?> getAgendaMissionLocale(String userId, DateTime maintenant) async {
    return Agenda(
      actions: [userActionStub()],
      demarches: [],
      rendezvous: [rendezvousStub()],
      sessionsMilo: [mockSessionMiloAtelierCv()],
      delayedActions: 0,
      dateDeDebut: DateTime(2042),
    );
  }

  @override
  Future<Agenda?> getAgendaPoleEmploi(String userId, DateTime maintenant) async {
    return Agenda(
      actions: [],
      demarches: [demarcheStub()],
      rendezvous: [rendezvousStub()],
      sessionsMilo: [],
      delayedActions: 0,
      dateDeDebut: DateTime(2042),
    );
  }
}

class AgendaRepositoryErrorStub extends AgendaRepository {
  AgendaRepositoryErrorStub() : super(DioMock());

  @override
  Future<Agenda?> getAgendaMissionLocale(String userId, DateTime maintenant) async {
    return null;
  }
}
