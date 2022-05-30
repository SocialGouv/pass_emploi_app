import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("❤️ une modification de démarche pôle emploi doit mettre à jour le state de la liste des démarches ❤️", () async {
    // Given
    final initialAction = UserActionPE(
      id: "id",
      content: "content",
      label: "label",
      status: UserActionPEStatus.CANCELLED,
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
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState().copyWith(
        userActionPEListState: UserActionPEListSuccessState([initialAction], true),
      ),
    );

    final successAppState = store.onChange.firstWhere((e) => e.userActionPEListState is UserActionPEListSuccessState);

    // When
    await store.dispatch(ModifyDemarcheStatusAction("id", DateTime.now(), UserActionPEStatus.NOT_STARTED));

    // Then
    final appState = await successAppState;
    expect(appState.userActionPEListState is UserActionPEListSuccessState, isTrue);
    expect(appState.userActionPEListState, UserActionPEListSuccessState([initialAction.copyWithStatus(UserActionPEStatus.NOT_STARTED)], true));
  });
}
