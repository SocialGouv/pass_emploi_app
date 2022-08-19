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
    // todo : je pourrais faire des groupes aussi comme le repo

    test('should load successful data', () async {
      final sut = SUT();

      sut.givenStore = givenState()
          .loggedInUser() //
          .store((f) => {f.agendaRepository = AgendaRepositorySuccessStub()});

      sut.whenDispatching = () => AgendaRequestAction(DateTime(2022, 7, 7));

      sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldSucceed]);
    });
  });
}

void _shouldLoad(AppState state) => expect(state.agendaState, AgendaStateLoading());

void _shouldSucceed(AppState state) {
  expectTypeThen(state.agendaState, (AgendaStateSuccess agendaState) {
    expect(agendaState.agenda.actions.length, 1);
    expect(agendaState.agenda.rendezVous.length, 1);
  });
}

class AgendaRepositorySuccessStub extends AgendaRepository {
  AgendaRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<Agenda?> getAgenda(String userId, DateTime maintenant) async {
    return Agenda(actions: [userActionStub()], rendezVous: [rendezvousStub()]);
  }
}
