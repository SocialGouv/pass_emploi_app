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

    final displayedLoading = store.onChange.any((e) => e.attachedFileState.states["id-1"] is AttachedFileLoadingState);
    final successAppState =
        store.onChange.firstWhere((e) => e.attachedFileState.states["id-1"] is AttachedFileSuccessState);

    // When
    await store.dispatch(AttachedFileRequestAction("id-1"));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.attachedFileState.states["id-1"], AttachedFileSuccessState("id-1-path"));
  });

  test("attached file should display an error when fetching failed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.attachedFileRepository = AttachedFileRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.attachedFileState.states["id-1"] is AttachedFileLoadingState);
    final failureAppState =
        store.onChange.firstWhere((e) => e.attachedFileState.states["id-1"] is AttachedFileFailureState);

    // When
    await store.dispatch(AttachedFileRequestAction("id-1"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.attachedFileState.states["id-1"], AttachedFileFailureState());
  });
}
