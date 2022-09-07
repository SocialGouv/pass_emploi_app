import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/expects.dart';

void main() {
  group('Agenda', () {
    group('when requesting agenda for Mission Local user', () {
      final sut = SUT();

      sut.whenDispatching = () => AgendaRequestAction(DateTime(2022, 7, 7));

      test('should load then succeed when request succeed', () async {
        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldSucceedForMissionLocaleUser]);
      });

      test('should load then fail when request fail', () async {
        sut.givenStore = givenState()
            .loggedInMiloUser() //
            .store((f) => {f.agendaRepository = AgendaRepositoryErrorStub()});

        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldFail]);
      });
    });

    group('when requesting agenda for Pole Emploi user', () {
      final sut = SUT();

      sut.whenDispatching = () => AgendaRequestAction(DateTime(2022, 7, 7));

      test('should load then succeed when request succeed', () async {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser() //
            .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldSucceedForPoleEmploiUser]);
      });

      test('should load then fail when request fail', () async {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser() //
            .store((f) => {f.agendaRepository = AgendaRepositoryErrorStub()});

        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldFail]);
      });
    });
  });
}

void _shouldLoad(AppState state) => expect(state.agendaState, AgendaLoadingState());

void _shouldFail(AppState state) => expect(state.agendaState, AgendaFailureState());

void _shouldSucceedForMissionLocaleUser(AppState state) {
  expectTypeThen(state.agendaState, (AgendaSuccessState agendaState) {
    expect(agendaState.agenda.actions.length, 1);
    expect(agendaState.agenda.rendezvous.length, 1);
  });
}

void _shouldSucceedForPoleEmploiUser(AppState state) {
  expectTypeThen(state.agendaState, (AgendaSuccessState agendaState) {
    expect(agendaState.agenda.demarches.length, 1);
    expect(agendaState.agenda.rendezvous.length, 1);
  });
}

class AgendaRepositorySuccessStub extends AgendaRepository {
  AgendaRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<Agenda?> getAgendaMissionLocale(String userId, DateTime maintenant) async {
    return Agenda(
      actions: [userActionStub()],
      demarches: [],
      rendezvous: [rendezvousStub()],
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
      delayedActions: 0,
      dateDeDebut: DateTime(2042),
    );
  }
}

class AgendaRepositoryErrorStub extends AgendaRepository {
  AgendaRepositoryErrorStub() : super("", DummyHttpClient());

  @override
  Future<Agenda?> getAgendaMissionLocale(String userId, DateTime maintenant) async {
    return null;
  }
}
