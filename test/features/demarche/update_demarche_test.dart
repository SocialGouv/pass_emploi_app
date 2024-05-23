import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("update demarche when repo succeeds should display loading and then update demarche", () async {
    // Given
    final now = DateTime.now();
    final repository = UpdateDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', DemarcheStatus.DONE, now, now);
    final store = givenState()
        .loggedInPoleEmploiUser() //
        .withDemarches(
      [
        mockDemarche(id: '1', status: DemarcheStatus.IN_PROGRESS),
        mockDemarche(id: '2', status: DemarcheStatus.NOT_STARTED),
        mockDemarche(id: '3', status: DemarcheStatus.IN_PROGRESS),
      ],
    ).store((factory) => {factory.updateDemarcheRepository = repository});

    final updateDisplayedLoading = store.onChange.any((e) => e.updateDemarcheState is UpdateDemarcheLoadingState);
    final successUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheSuccessState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.DONE));

    // Then
    expect(await updateDisplayedLoading, true);
    final successUpdate = await successUpdateState;
    expect(successUpdate.updateDemarcheState is UpdateDemarcheSuccessState, isTrue);
  });

  test("update demarche when repo succeeds should update mon suivi with modified demarche", () async {
    // Given
    final now = DateTime.now();
    final repository = UpdateDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', DemarcheStatus.DONE, now, now);
    final store = givenState()
        .loggedInPoleEmploiUser() //
        .withDemarches(
      [
        mockDemarche(id: '1', status: DemarcheStatus.IN_PROGRESS),
        mockDemarche(id: '2', status: DemarcheStatus.NOT_STARTED),
        mockDemarche(id: '3', status: DemarcheStatus.IN_PROGRESS),
      ],
    ).store((factory) => {factory.updateDemarcheRepository = repository});

    final successUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheSuccessState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.DONE));

    // Then
    await successUpdateState;
    final demarches = (store.state.monSuiviState as MonSuiviSuccessState).monSuivi.demarches;
    expect(demarches.length, 3);
    expect(demarches.firstWhere((d) => d.id == '2'), mockDemarche(id: '2', status: DemarcheStatus.DONE));
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
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.DONE));

    // Then
    expect(await updateDisplayedLoading, true);
    final failureUpdate = await failureUpdateState;
    expect(failureUpdate.updateDemarcheState is UpdateDemarcheFailureState, isTrue);
  });

  test("update demarche when repo fails should not update mon suivi", () async {
    // Given
    final now = DateTime.now();
    final store = givenState().loggedInPoleEmploiUser().withDemarches(
      [
        mockDemarche(id: '1', status: DemarcheStatus.IN_PROGRESS),
        mockDemarche(id: '2', status: DemarcheStatus.NOT_STARTED),
        mockDemarche(id: '3', status: DemarcheStatus.IN_PROGRESS),
      ],
    ).store((factory) => {factory.updateDemarcheRepository = UpdateDemarcheRepositoryFailureStub()});

    final failureUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheFailureState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.DONE));

    // Then
    await failureUpdateState;
    expect(
      (store.state.monSuiviState as MonSuiviSuccessState).monSuivi.demarches,
      [
        mockDemarche(id: '1', status: DemarcheStatus.IN_PROGRESS),
        mockDemarche(id: '2', status: DemarcheStatus.NOT_STARTED),
        mockDemarche(id: '3', status: DemarcheStatus.IN_PROGRESS),
      ],
    );
  });
}
