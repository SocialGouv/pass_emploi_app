import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';

void main() {
  test("update demarche when repo succeeds should display loading and then update demarche", () async {
    // Given
    final now = DateTime.now();
    final repository = UpdateDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', DemarcheStatus.terminee, now, now);
    final store = givenState()
        .loggedInPoleEmploiUser() //
        .withDemarches(
      [
        uneDemarche(id: '1', status: DemarcheStatus.enCours),
        uneDemarche(id: '2', status: DemarcheStatus.pasCommencee),
        uneDemarche(id: '3', status: DemarcheStatus.enCours),
      ],
    ).store((factory) => {factory.updateDemarcheRepository = repository});

    final updateDisplayedLoading = store.onChange.any((e) => e.updateDemarcheState is UpdateDemarcheLoadingState);
    final successUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheSuccessState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.terminee));

    // Then
    expect(await updateDisplayedLoading, true);
    final successUpdate = await successUpdateState;
    expect(successUpdate.updateDemarcheState is UpdateDemarcheSuccessState, isTrue);
  });

  test("update demarche when repo succeeds should update demarches' list with modified demarche", () async {
    // Given
    final now = DateTime.now();
    final repository = UpdateDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', DemarcheStatus.terminee, now, now);
    final store = givenState()
        .loggedInPoleEmploiUser() //
        .withDemarches(
      [
        uneDemarche(id: '1', status: DemarcheStatus.enCours),
        uneDemarche(id: '2', status: DemarcheStatus.pasCommencee),
        uneDemarche(id: '3', status: DemarcheStatus.enCours),
      ],
    ).store((factory) => {factory.updateDemarcheRepository = repository});

    final successUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheSuccessState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.terminee));

    // Then
    await successUpdateState;
    expect(
      store.state.demarcheListState,
      DemarcheListSuccessState(
        [
          uneDemarche(id: '1', status: DemarcheStatus.enCours),
          uneDemarche(id: '2', status: DemarcheStatus.terminee),
          uneDemarche(id: '3', status: DemarcheStatus.enCours),
        ],
      ),
    );
  });

  test("update demarche when repo fails should display loading and then show failure", () async {
    // Given
    final now = DateTime.now();
    final store = givenState()
        .loggedInPoleEmploiUser()
        .store((factory) => {factory.updateDemarcheRepository = UpdateDemarcheRepositoryFailureStub()});

    final updateDisplayedLoading = store.onChange.any((e) => e.updateDemarcheState is UpdateDemarcheLoadingState);
    final failureUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheFailureState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.terminee));

    // Then
    expect(await updateDisplayedLoading, true);
    final failureUpdate = await failureUpdateState;
    expect(failureUpdate.updateDemarcheState is UpdateDemarcheFailureState, isTrue);
  });

  test("update demarche when repo fails should not update demarches' list", () async {
    // Given
    final now = DateTime.now();
    final store = givenState().loggedInPoleEmploiUser().withDemarches(
      [
        uneDemarche(id: '1', status: DemarcheStatus.enCours),
        uneDemarche(id: '2', status: DemarcheStatus.pasCommencee),
        uneDemarche(id: '3', status: DemarcheStatus.enCours),
      ],
    ).store((factory) => {factory.updateDemarcheRepository = UpdateDemarcheRepositoryFailureStub()});

    final failureUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheFailureState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.terminee));

    // Then
    await failureUpdateState;
    expect(
      store.state.demarcheListState,
      DemarcheListSuccessState(
        [
          uneDemarche(id: '1', status: DemarcheStatus.enCours),
          uneDemarche(id: '2', status: DemarcheStatus.pasCommencee),
          uneDemarche(id: '3', status: DemarcheStatus.enCours),
        ],
      ),
    );
  });

  test("an edited demarche contained in agenda should be updated", () async {
    // Given
    final demarches = [
      uneDemarche(id: '1', status: DemarcheStatus.pasCommencee),
      uneDemarche(id: '2', status: DemarcheStatus.pasCommencee),
    ];
    final now = DateTime.now();
    final repository = UpdateDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '1', DemarcheStatus.terminee, now, now);
    final store = givenState()
        .loggedInPoleEmploiUser()
        .agenda(demarches: demarches)
        .withDemarches(demarches)
        .store((factory) => {factory.updateDemarcheRepository = repository});

    final successUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheSuccessState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('1', now, now, DemarcheStatus.terminee));

    // Then
    await successUpdateState;
    expectTypeThen<AgendaSuccessState>(store.state.agendaState, (agendaState) {
      expect(agendaState.agenda.demarches[0].id, '1');
      expect(agendaState.agenda.demarches[0].status, DemarcheStatus.terminee);
    });
  });
}
