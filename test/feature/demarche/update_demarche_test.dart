import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("update demarche when repo succeeds should display loading and then update demarche", () async {
    // Given
    final now = DateTime.now();
    final store = givenState()
        .loggedInPoleEmploiUser()
        .updateDemarcheSuccess()
        .store((factory) => {factory.updateDemarcheRepository = UpdateDemarcheRepositorySuccessStub()});

    final updateDisplayedLoading = store.onChange.any((e) => e.updateDemarcheState is UpdateDemarcheLoadingState);
    final successUpdateState = store.onChange.firstWhere((e) => e.updateDemarcheState is UpdateDemarcheSuccessState);

    // When
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.DONE));

    // Then
    expect(await updateDisplayedLoading, true);
    final successUpdate = await successUpdateState;
    expect(successUpdate.updateDemarcheState is UpdateDemarcheSuccessState, isTrue);
  });

  test("update demarche when repo succeeds should update demarches' list with modified demarche", () async {
    // Given
    final now = DateTime.now();
    final repository = UpdateDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', DemarcheStatus.DONE, now, now);
    final store = givenState().loggedInPoleEmploiUser().updateDemarcheSuccess().withDemarches(
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
    expect(
      store.state.demarcheListState,
      DemarcheListSuccessState(
        [
          mockDemarche(id: '1', status: DemarcheStatus.IN_PROGRESS),
          mockDemarche(id: '2', status: DemarcheStatus.DONE),
          mockDemarche(id: '3', status: DemarcheStatus.IN_PROGRESS),
        ],
        true,
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
    await store.dispatch(UpdateDemarcheRequestAction('2', now, now, DemarcheStatus.DONE));

    // Then
    expect(await updateDisplayedLoading, true);
    final failureUpdate = await failureUpdateState;
    expect(failureUpdate.updateDemarcheState is UpdateDemarcheFailureState, isTrue);
  });

  test("update demarche when repo fails should not update demarches' list", () async {
    // Given
    final now = DateTime.now();
    final store = givenState().loggedInPoleEmploiUser().updateDemarcheSuccess().withDemarches(
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
      store.state.demarcheListState,
      DemarcheListSuccessState(
        [
          mockDemarche(id: '1', status: DemarcheStatus.IN_PROGRESS),
          mockDemarche(id: '2', status: DemarcheStatus.NOT_STARTED),
          mockDemarche(id: '3', status: DemarcheStatus.IN_PROGRESS),
        ],
        true,
      ),
    );
  });
}
