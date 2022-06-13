import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/repositories/modify_demarche_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("on demarche successful modification, demarches' list is updated with modified demarche", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final now = DateTime.now();
    final repository = _ModifyDemarcheRepositorySuccessStub();
    repository.withArgsResolves('id', '2', UserActionPEStatus.DONE, now, now);
    testStoreFactory.modifyDemarcheRepository = repository;
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState().copyWith(
        userActionPEListState: UserActionPEListSuccessState(
          [
            _mockDemarche('1', UserActionPEStatus.IN_PROGRESS),
            _mockDemarche('2', UserActionPEStatus.NOT_STARTED),
            _mockDemarche('3', UserActionPEStatus.IN_PROGRESS),
          ],
          true,
        ),
      ),
    );

    // When
    await store.dispatch(ModifyDemarcheStatusAction('2', now, now, UserActionPEStatus.DONE));

    // Then
    expect(store.state.userActionPEListState is UserActionPEListSuccessState, isTrue);
    expect(
      store.state.userActionPEListState,
      UserActionPEListSuccessState(
        [
          _mockDemarche('1', UserActionPEStatus.IN_PROGRESS),
          _mockDemarche('2', UserActionPEStatus.DONE),
          _mockDemarche('3', UserActionPEStatus.IN_PROGRESS),
        ],
        true,
      ),
    );
  });
}

class _ModifyDemarcheRepositorySuccessStub extends ModifyDemarcheRepository {
  String? _userId;
  String? _demarcheId;
  UserActionPEStatus? _status;
  DateTime? _fin;
  DateTime? _debut;

  _ModifyDemarcheRepositorySuccessStub() : super('', DummyHttpClient());

  void withArgsResolves(
    String userId,
    String demarcheId,
    UserActionPEStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) {
    _userId = userId;
    _demarcheId = demarcheId;
    _status = status;
    _fin = dateFin;
    _debut = dateDebut;
  }

  @override
  Future<UserActionPE?> modifyDemarche(
    String userId,
    String demarcheId,
    UserActionPEStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    if (_userId == userId && _demarcheId == demarcheId && _status == status && _debut == dateDebut && _fin == dateFin) {
      return _mockDemarche(demarcheId, status);
    }
    return null;
  }
}

UserActionPE _mockDemarche(String id, UserActionPEStatus status) {
  return UserActionPE(
    id: id,
    content: "content",
    label: "label",
    status: status,
    possibleStatus: UserActionPEStatus.values,
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
