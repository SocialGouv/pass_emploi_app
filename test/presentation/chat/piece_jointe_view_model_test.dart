import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/presentation/piece_jointe_view_model.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = givenState().piecesJointesLoading("id-1").store();

    // When
    final viewModel = PieceJointeViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.LOADING);
  });

  test('should display failure', () {
    // Given
    final store = givenState().piecesJointesFailure("id-1").store();

    // When
    final viewModel = PieceJointeViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.FAILURE);
  });

  test('should display content', () {
    // Given
    final store = givenState().piecesJointesWithIdOneSuccess().store();

    // When
    final viewModel = PieceJointeViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.CONTENT);
  });

  test('blablabla', () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store);
    final item = PieceJointeConseillerMessageItem(id: "id-1", message: "Super PJ", filename: "super.pdf", caption: "");

    // When
    viewModel.onClick(item);

    // Then
    expect(store.dispatchedAction, isA<PieceJointeRequestAction>());
    expect((store.dispatchedAction as PieceJointeRequestAction).fileId, "id-1");
    expect((store.dispatchedAction as PieceJointeRequestAction).fileName, "super.pdf");
  });
}
