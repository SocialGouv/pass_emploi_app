import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_actions.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_state.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test("share file should be fetched and shared when finish loading", () async {
    // Given
    final store = givenState().store();

    final successAppState = store.onChange.firstWhere((e) => e.shareFileState is ShareFileSuccessState);

    // When
    await store.dispatch(ShareFileAction("filepath/filename.fileextension"));
    await store.dispatch(ShareFileCloseAction());

    // Then
    final appState = await successAppState;
    expect(appState.shareFileState is ShareFileSuccessState, isTrue);
    expect((appState.shareFileState as ShareFileSuccessState).path, "filepath/filename.fileextension");
  });

  test("share file should reset its state when finish share action", () async {
    // Given
    final store = givenState().store();

    final notInitAppState = store.onChange.firstWhere((e) => e.shareFileState is ShareFileNotInitializedState);

    // When
    await store.dispatch(ShareFileCloseAction());

    // Then
    final appState = await notInitAppState;
    expect(appState.shareFileState is ShareFileNotInitializedState, isTrue);
  });
}
