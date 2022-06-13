import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/presentation/attached_file_view_model.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = givenState().attachedFilesLoading("id-1").store();

    // When
    final viewModel = AttachedFileViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.LOADING);
  });

  test('should display failure', () {
    // Given
    final store = givenState().attachedFilesFailure("id-1").store();

    // When
    final viewModel = AttachedFileViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.FAILURE);
  });

  test('should display content', () {
    // Given
    final store = givenState().attachedFilesWithIdOneSuccess().store();

    // When
    final viewModel = AttachedFileViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.CONTENT);
  });

  test('blablabla', () {
    // Given
    final store = StoreSpy();
    final viewModel = AttachedFileViewModel.create(store);
    final item = AttachedFileConseillerMessageItem(id: "id-1", message: "Super PJ", filename: "super.pdf", caption: "");

    // When
    viewModel.onClick(item);

    // Then
    expect(store.dispatchedAction, isA<AttachedFileRequestAction>());
    expect((store.dispatchedAction as AttachedFileRequestAction).fileId, "id-1");
    expect((store.dispatchedAction as AttachedFileRequestAction).fileExtension, "pdf");
  });
}
