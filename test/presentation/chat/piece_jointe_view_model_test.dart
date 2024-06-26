import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/chat/piece_jointe_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = givenState().piecesJointesLoading("id-1").store();

    // When
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.LOADING);
  });

  test('should display failure', () {
    // Given
    final store = givenState().piecesJointesFailure("id-1").store();

    // When
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.FAILURE);
  });

  test('should display content', () {
    // Given
    final store = givenState().piecesJointesWithIdOneSuccess().store();

    // When
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.CONTENT);
  });

  test('should provide path from loaded file', () {
    // Given
    final store = givenState().piecesJointesWithIdOneSuccess().store();

    // When
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // Then
    expect(viewModel.imagePath?.call("id-1"), "path");
  });

  test('should display content when no status', () {
    // Given
    final store = givenState().store();

    // When
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.CONTENT);
  });

  test('should display empty when file is unavailable', () {
    // Given
    final store = givenState().piecesJointesUnavailable("id-1").store();

    // When
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // Then
    expect(viewModel.displayState("id-1"), DisplayState.EMPTY);
  });

  test('onDownloadTypeId should trigger proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // When
    viewModel.onDownloadTypeId("id", "file.pdf");

    // Then
    expect(store.dispatchedAction, isA<PieceJointeFromIdRequestAction>());
    expect((store.dispatchedAction as PieceJointeFromIdRequestAction).fileId, "id");
    expect((store.dispatchedAction as PieceJointeFromIdRequestAction).fileName, "file.pdf");
  });

  test("onDownloadTypeUrl should trigger proper action AND propagate événement d'engagement for jeune pj", () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeDownloadButtonSource(sender: Sender.jeune));

    // When
    viewModel.onDownloadTypeUrl("url", "id", "file.pdf");

    // Then
    expect(store.dispatchedActions.first, isA<PieceJointeFromUrlRequestAction>());
    expect((store.dispatchedActions.first as PieceJointeFromUrlRequestAction).url, "url");
    expect((store.dispatchedActions.first as PieceJointeFromUrlRequestAction).fileId, "id");
    expect((store.dispatchedActions.first as PieceJointeFromUrlRequestAction).fileName, "file.pdf");
    expect(store.dispatchedActions.last, isA<TrackingEvenementEngagementAction>());
    expect((store.dispatchedActions.last as TrackingEvenementEngagementAction).event,
        EvenementEngagement.PIECE_JOINTE_BENEFICIAIRE_TELECHARGEE);
  });

  test("onDownloadTypeUrl should trigger proper action AND propagate événement d'engagement for conseiller pj", () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeDownloadButtonSource(sender: Sender.conseiller));

    // When
    viewModel.onDownloadTypeUrl("url", "id", "file.pdf");

    // Then
    expect(store.dispatchedActions.first, isA<PieceJointeFromUrlRequestAction>());
    expect((store.dispatchedActions.first as PieceJointeFromUrlRequestAction).url, "url");
    expect((store.dispatchedActions.first as PieceJointeFromUrlRequestAction).fileId, "id");
    expect((store.dispatchedActions.first as PieceJointeFromUrlRequestAction).fileName, "file.pdf");
    expect(store.dispatchedActions.last, isA<TrackingEvenementEngagementAction>());
    expect((store.dispatchedActions.last as TrackingEvenementEngagementAction).event,
        EvenementEngagement.PIECE_JOINTE_CONSEILLER_TELECHARGEE);
  });

  test("onDownloadTypeUrl should not trigger action if file source is image preview", () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeImagePreviewSource());

    // When
    viewModel.onDownloadTypeUrl("url", "id", "file.png");

    // Then
    expect(store.dispatchedActions.first, isA<PieceJointeFromUrlRequestAction>());
    expect(store.dispatchedActions.length, 1);
  });

  test("onDownloadTypeUrl should trigger action if file source is button", () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeDownloadButtonSource(sender: Sender.conseiller));

    // When
    viewModel.onDownloadTypeUrl("url", "id", "file.png");

    // Then
    expect(store.dispatchedActions.first, isA<PieceJointeFromUrlRequestAction>());
    expect(store.dispatchedActions.length, 2);
  });

  test("onDownloadTypeId should trigger proper action AND propagate événement d'engagement for jeune pj", () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeDownloadButtonSource(sender: Sender.jeune));

    // When
    viewModel.onDownloadTypeId("id", "file.pdf");

    // Then
    expect(store.dispatchedActions.first, isA<PieceJointeFromIdRequestAction>());
    expect((store.dispatchedActions.first as PieceJointeFromIdRequestAction).fileId, "id");
    expect((store.dispatchedActions.first as PieceJointeFromIdRequestAction).fileName, "file.pdf");
    expect(store.dispatchedActions.last, isA<TrackingEvenementEngagementAction>());
    expect((store.dispatchedActions.last as TrackingEvenementEngagementAction).event,
        EvenementEngagement.PIECE_JOINTE_BENEFICIAIRE_TELECHARGEE);
  });

  test("onDownloadTypeId should trigger proper action AND propagate événement d'engagement for conseiller pj", () {
    // Given
    final store = StoreSpy();
    final viewModel = PieceJointeViewModel.create(store, PieceJointeDownloadButtonSource(sender: Sender.conseiller));

    // When
    viewModel.onDownloadTypeId("id", "file.pdf");

    // Then
    expect(store.dispatchedActions.first, isA<PieceJointeFromIdRequestAction>());
    expect((store.dispatchedActions.first as PieceJointeFromIdRequestAction).fileId, "id");
    expect((store.dispatchedActions.first as PieceJointeFromIdRequestAction).fileName, "file.pdf");
    expect(store.dispatchedActions.last, isA<TrackingEvenementEngagementAction>());
    expect((store.dispatchedActions.last as TrackingEvenementEngagementAction).event,
        EvenementEngagement.PIECE_JOINTE_CONSEILLER_TELECHARGEE);
  });
}

class MockBuildContext extends Mock implements BuildContext {}
