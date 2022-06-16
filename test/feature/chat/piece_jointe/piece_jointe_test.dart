import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../utils/test_setup.dart';

void main() {
  test("attached file should be fetched and shared when finish loading", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pieceJointeRepository = PieceJointeRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

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
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pieceJointeRepository = PieceJointeRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

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
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pieceJointeRepository = PieceJointeRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
        initialState: givenState().loggedInUser().piecesJointesWithIdOneSuccess());

    final changedAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id-2"] is PieceJointeFailureStatus);

    // When
    await store.dispatch(PieceJointeRequestAction("id-2", "png"));

    // Then
    final appState = await changedAppState;
    expect(appState.piecesJointesState.status["id-1"], PieceJointeSuccessStatus());
    expect(appState.piecesJointesState.status["id-2"], PieceJointeFailureStatus());
  });
}
