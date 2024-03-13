import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/presentation/chat/piece_jointe_view_model.dart';
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

  test('should display content when no status', () {
    // Given
    final store = givenState().store();

    // When
    final viewModel = PieceJointeViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.CONTENT);
  });

  test('should display empty when file is unavailable', () {
    // Given
    final store = givenState().piecesJointesUnavailable("id-1").store();

    // When
    final viewModel = PieceJointeViewModel.create(store);

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.EMPTY);
  });

  test('onDownloadTypeId should trigger proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store);

    // When
    viewModel.onDownloadTypeId("id", "file.pdf");

    // Then
    expect(store.dispatchedAction, isA<PieceJointeFromIdRequestAction>());
    expect((store.dispatchedAction as PieceJointeFromIdRequestAction).fileId, "id");
    expect((store.dispatchedAction as PieceJointeFromIdRequestAction).fileName, "file.pdf");
  });

  test('onDownloadTypeUrl should trigger proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store);

    // When
    viewModel.onDownloadTypeUrl("url", "id", "file.pdf");

    // Then
    expect(store.dispatchedAction, isA<PieceJointeFromUrlRequestAction>());
    expect((store.dispatchedAction as PieceJointeFromUrlRequestAction).url, "url");
    expect((store.dispatchedAction as PieceJointeFromUrlRequestAction).fileId, "id");
    expect((store.dispatchedAction as PieceJointeFromUrlRequestAction).fileName, "file.pdf");
  });
}
