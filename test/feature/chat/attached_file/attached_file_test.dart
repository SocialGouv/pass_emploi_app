import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_state.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../utils/test_setup.dart';

void main() {
  test("attached file should be fetched and shared when finish loading", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.attachedFileRepository = AttachedFileRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.attachedFilesState.status["id-1"] is AttachedFileLoadingStatus);
    final successAppState =
        store.onChange.firstWhere((e) => e.attachedFilesState.status["id-1"] is AttachedFileSuccessStatus);

    // When
    await store.dispatch(AttachedFileRequestAction("id-1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.attachedFilesState.status["id-1"], AttachedFileSuccessStatus("id-1-path"));
  });

  test("attached file should display an error when fetching failed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.attachedFileRepository = AttachedFileRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.attachedFilesState.status["id-1"] is AttachedFileLoadingStatus);
    final failureAppState =
        store.onChange.firstWhere((e) => e.attachedFilesState.status["id-1"] is AttachedFileFailureStatus);

    // When
    await store.dispatch(AttachedFileRequestAction("id-1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.attachedFilesState.status["id-1"], AttachedFileFailureStatus());
  });

  test("fetching an attached file should only affect its own state", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.attachedFileRepository = AttachedFileRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
        initialState: givenState().loggedInUser().attachedFilesWithIdOneSuccess());

    final changedAppState =
        store.onChange.firstWhere((e) => e.attachedFilesState.status["id-2"] is AttachedFileFailureStatus);

    // When
    await store.dispatch(AttachedFileRequestAction("id-2", "png"));

    // Then
    final appState = await changedAppState;
    expect(appState.attachedFilesState.status["id-1"], AttachedFileSuccessStatus("id-1-path"));
    expect(appState.attachedFilesState.status["id-2"], AttachedFileFailureStatus());
  });
}
