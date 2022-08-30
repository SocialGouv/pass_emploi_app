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

    group('when requesting agenda', () {
      final sut = SUT();

      sut.whenDispatching = () => AgendaRequestAction(DateTime(2022, 7, 7));

      test('should load then succeed when request succeed', () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldSucceed]);
      });

      test('should load then fail when request fail', () async {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.agendaRepository = AgendaRepositoryErrorStub()});

        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldFail]);
      });
    });
  });
}

void _shouldLoad(AppState state) => expect(state.agendaState, AgendaLoadingState());

void _shouldFail(AppState state) => expect(state.agendaState, AgendaFailureState());

void _shouldSucceed(AppState state) {
  expectTypeThen(state.agendaState, (AgendaSuccessState agendaState) {
    expect(agendaState.agenda.actions.length, 1);
    expect(agendaState.agenda.rendezvous.length, 1);
  });
}

class AgendaRepositorySuccessStub extends AgendaRepository {
  AgendaRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<Agenda?> getAgenda(String userId, DateTime maintenant) async {
    return Agenda(actions: [userActionStub()], rendezvous: [rendezvousStub()], delayedActions: 0);
  }
}

class AgendaRepositoryErrorStub extends AgendaRepository {
  AgendaRepositoryErrorStub() : super("", DummyHttpClient());

  @override
  Future<Agenda?> getAgenda(String userId, DateTime maintenant) async {
    return null;
  }
}
