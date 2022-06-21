import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test("should preview file", () async {
    // Given
    final store = givenState().store();

    final successAppState = store.onChange.firstWhere((e) => e.previewFileState is PreviewFileSuccessState);

    // When
    await store.dispatch(PreviewFileAction("filepath/filename.fileextension"));
    await store.dispatch(PreviewFileCloseAction());

    // Then
    final appState = await successAppState;
    expect(appState.previewFileState is PreviewFileSuccessState, isTrue);
    expect((appState.previewFileState as PreviewFileSuccessState).path, "filepath/filename.fileextension");
  });

  test("should reset state when closed", () async {
    // Given
    final store = givenState().previewFile("super.pdf").store();

    final notInitAppState = store.onChange.firstWhere((e) => e.previewFileState is PreviewFileNotInitializedState);

    // When
    await store.dispatch(PreviewFileCloseAction());

    // Then
    final appState = await notInitAppState;
    expect(appState.previewFileState is PreviewFileNotInitializedState, isTrue);
  });
}
