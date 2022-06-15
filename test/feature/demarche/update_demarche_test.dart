import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_action.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("on demarche successful update, demarches' list is updated with modified demarche", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final now = DateTime.now();
    final repository = _ModifyDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', DemarcheStatus.DONE, now, now);
    testStoreFactory.updateDemarcheRepository = repository;
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState().copyWith(
        demarcheListState: DemarcheListSuccessState(
          [
            _mockDemarche('1', DemarcheStatus.IN_PROGRESS),
            _mockDemarche('2', DemarcheStatus.NOT_STARTED),
            _mockDemarche('3', DemarcheStatus.IN_PROGRESS),
          ],
          true,
        ),
      ),
    );

    // When
    await store.dispatch(UpdateDemarcheAction('2', now, now, DemarcheStatus.DONE));

    // Then
    expect(store.state.demarcheListState is DemarcheListSuccessState, isTrue);
    expect(
      store.state.demarcheListState,
      DemarcheListSuccessState(
        [
          _mockDemarche('1', DemarcheStatus.IN_PROGRESS),
          _mockDemarche('2', DemarcheStatus.DONE),
          _mockDemarche('3', DemarcheStatus.IN_PROGRESS),
        ],
        true,
      ),
    );
  });
}

class _ModifyDemarcheRepositorySuccessStub extends UpdateDemarcheRepository {
  String? _userId;
  String? _actionId;
  DemarcheStatus? _status;
  DateTime? _fin;
  DateTime? _debut;

  _ModifyDemarcheRepositorySuccessStub() : super('', DummyHttpClient());

  void withArgsResolves(
    String userId,
    String actionId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) {
    _userId = userId;
    _actionId = actionId;
    _status = status;
    _fin = dateFin;
    _debut = dateDebut;
  }

  @override
  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    if (_userId == userId && _actionId == demarcheId && _status == status && _debut == dateDebut && _fin == dateFin) {
      return _mockDemarche(demarcheId, status);
    }
    return null;
  }
}

Demarche _mockDemarche(String id, DemarcheStatus status) {
  return Demarche(
    id: id,
    content: "content",
    label: "label",
    status: status,
    possibleStatus: DemarcheStatus.values,
    endDate: null,
    deletionDate: null,
    modificationDate: null,
    createdByAdvisor: true,
    modifiedByAdvisor: true,
    titre: "titre",
    sousTitre: "sousTitre",
    attributs: [],
    creationDate: null,
  );
}
