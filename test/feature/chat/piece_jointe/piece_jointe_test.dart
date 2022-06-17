import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test("attached file should be fetched and shared when finish loading", () async {
    // Given
    final store = givenState().loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id-1"] is PieceJointeLoadingStatus);
    final successAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id-1"] is PieceJointeSuccessStatus);

    // When
    await store.dispatch(PieceJointeRequestAction("id-1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.piecesJointesState.status["id-1"], PieceJointeSuccessStatus());
  });

  test("attached file should display an error when fetching failed", () async {
    // Given
    final store = givenState().loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositoryFailureStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id-1"] is PieceJointeLoadingStatus);
    final failureAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id-1"] is PieceJointeFailureStatus);

    // When
    await store.dispatch(PieceJointeRequestAction("id-1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.piecesJointesState.status["id-1"], PieceJointeFailureStatus());
  });

  test("fetching an attached file should only affect its own state", () async {
    // Given
    final store = givenState().loggedInUser().piecesJointesWithIdOneSuccess() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositoryFailureStub()});

    final changedAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id-2"] is PieceJointeFailureStatus);

    // When
    await store.dispatch(PieceJointeRequestAction("id-2", "png"));

    // Then
    final appState = await changedAppState;
    expect(appState.piecesJointesState.status["id-1"], PieceJointeSuccessStatus());
    expect(appState.piecesJointesState.status["id-2"], PieceJointeFailureStatus());
  });

  test("attached file should display a unavailable message when fetching return 404 error", () async {
    // Given
    final store = givenState().loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositoryUnavailableStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id-1"] is PieceJointeLoadingStatus);
    final failureAppState =
    store.onChange.firstWhere((e) => e.piecesJointesState.status["id-1"] is PieceJointeUnavailableStatus);

    // When
    await store.dispatch(PieceJointeRequestAction("id-1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.piecesJointesState.status["id-1"], PieceJointeUnavailableStatus());
  });

}
