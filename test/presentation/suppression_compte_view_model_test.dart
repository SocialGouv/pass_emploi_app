import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/suppression_compte_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

void main() {
  test('create by MILO should properly set warning info', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(suppressionCompteState: SuppressionCompteNotInitializedState()),
    );

    // When
    final viewModel = SuppressionCompteViewModel.create(store);

    // Then
    expect(viewModel.isPoleEmploiLogin, false);
    expect(viewModel.warningSuppressionFeatures, Strings.warningPointsMilo);
    expect(viewModel.displayState, isNull);
  });

  test('create by Pole Emploi should properly set warning info', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInPoleEmploiState().copyWith(suppressionCompteState: SuppressionCompteNotInitializedState()),
    );

    // When
    final viewModel = SuppressionCompteViewModel.create(store);

    // Then
    expect(viewModel.isPoleEmploiLogin, true);
    expect(viewModel.warningSuppressionFeatures, Strings.warningPointsPoleEmploi);
    expect(viewModel.displayState, isNull);
  });

  test('create when state is FAILURE', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInPoleEmploiState().copyWith(suppressionCompteState: SuppressionCompteFailureState()),
    );

    // When
    final viewModel = SuppressionCompteViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.erreur);
  });

  test('create when state is SUCCESS', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInPoleEmploiState().copyWith(suppressionCompteState: SuppressionCompteSuccessState()),
    );

    // When
    final viewModel = SuppressionCompteViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
  });

  test('create when state is LOADING', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInPoleEmploiState().copyWith(suppressionCompteState: SuppressionCompteLoadingState()),
    );

    // When
    final viewModel = SuppressionCompteViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.chargement);
  });

}


