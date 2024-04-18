import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_state.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test("should be previewed after loading", () async {
    // Given
    final store = givenState()
        .loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.loading);
    final pieceJointesStateFuture =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.success);
    final previewFileStateFuture = store.onChange.firstWhere((e) => e.previewFileState is PreviewFileSuccessState);

    // When
    await store.dispatch(PieceJointeFromIdRequestAction("id1", "png"));

    // Then
    expect(await displayedLoading, true);
    final pieceJointesState = await pieceJointesStateFuture;
    expect(pieceJointesState.piecesJointesState.status["id1"], PieceJointeStatus.success);
    final previewFileState = await previewFileStateFuture;
    expect(previewFileState.previewFileState, PreviewFileSuccessState("id1-path"));
  });

  test("should display an error when fetching failed", () async {
    // Given
    final store = givenState()
        .loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositoryFailureStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.loading);
    final failureAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.failure);

    // When
    await store.dispatch(PieceJointeFromIdRequestAction("id1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.piecesJointesState.status["id1"], PieceJointeStatus.failure);
  });

  test("should only affect its own state", () async {
    // Given
    final store = givenState()
        .loggedInUser()
        .piecesJointesWithIdOneSuccess() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositoryFailureStub()});

    final changedAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id-2"] == PieceJointeStatus.failure);

    // When
    await store.dispatch(PieceJointeFromIdRequestAction("id-2", "png"));

    // Then
    final appState = await changedAppState;
    expect(appState.piecesJointesState.status["id-1"], PieceJointeStatus.success);
    expect(appState.piecesJointesState.status["id-2"], PieceJointeStatus.failure);
  });

  test("should display a unavailable message when fetching return 410 error", () async {
    // Given
    final store = givenState()
        .loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositoryUnavailableStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.loading);
    final failureAppState =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.unavailable);

    // When
    await store.dispatch(PieceJointeFromIdRequestAction("id1", "png"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.piecesJointesState.status["id1"], PieceJointeStatus.unavailable);
  });

  test("should not load pj when already loaded", () async {
    // Given
    final store = givenState()
        .piecesJointesWithIdOneSuccess()
        .loggedInUser() //
        .store();

    // When
    await store.dispatch(PieceJointeFromIdRequestAction("id-1", "png"));

    // Then
    Future.delayed(Duration(milliseconds: 50), () => store.teardown());
    expect(store.onChange, neverEmits(isA<AppState>()));
  });

  test("should not be previewed when file is image", () async {
    // Given
    final store = givenState()
        .loggedInUser() //
        .store((factory) => {factory.pieceJointeRepository = PieceJointeRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.loading);
    final pieceJointesStateFuture =
        store.onChange.firstWhere((e) => e.piecesJointesState.status["id1"] == PieceJointeStatus.success);

    // When
    await store.dispatch(PieceJointeFromIdRequestAction("id1", "png", isImage: true));

    // Then
    expect(await displayedLoading, true);
    final pieceJointesState = await pieceJointesStateFuture;
    expect(pieceJointesState.piecesJointesState.status["id1"], PieceJointeStatus.success);
    Future.delayed(Duration(milliseconds: 50), () => store.teardown());
    expect(
        store.onChange,
        neverEmits(isA<AppState>().having(
          (appState) => appState.previewFileState,
          "previewFileState",
          PreviewFileSuccessState("id1-path"),
        )));
  });
}
