import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/stubs.dart';
import '../../../utils/test_setup.dart';

void main() {
  test("attached file should be fetched and shared when finish loading", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.attachedFileRepository = AttachedFileRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.attachedFileState is AttachedFileLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.attachedFileState is AttachedFileSuccessState);

    // When
    await store.dispatch(AttachedFileRequestAction("file_id"));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.attachedFileState is AttachedFileSuccessState, isTrue);
    expect((appState.attachedFileState as AttachedFileSuccessState).data, {'file_id': 'file_path'});
  });

  test("attached file should display an error when fetching failed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.attachedFileRepository = AttachedFileRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.attachedFileState is AttachedFileLoadingState);
    final failureAppState = store.onChange.firstWhere((e) => e.attachedFileState is AttachedFileFailureState);

    // When
    await store.dispatch(AttachedFileRequestAction("file_id"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.attachedFileState is AttachedFileFailureState, isTrue);
  });
}
