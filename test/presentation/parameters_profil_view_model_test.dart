import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';
import 'package:pass_emploi_app/presentation/profil/parameters_profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
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
    final viewModel = ParametersProfilePageViewModel.create(store);

    // Then
    expect(viewModel.isPoleEmploiLogin, false);
    expect(viewModel.warningSuppressionFeatures, Strings.warningPointsMILO);
  });

  test('create by Pole Emploi should properly set warning info', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInPoleEmploiState().copyWith(suppressionCompteState: SuppressionCompteNotInitializedState()),
    );

    // When
    final viewModel = ParametersProfilePageViewModel.create(store);

    // Then
    expect(viewModel.isPoleEmploiLogin, true);
    expect(viewModel.warningSuppressionFeatures, Strings.warningPointsPoleEmploi);
  });

  test('create if user not logged in should send error', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(loginState: UserNotLoggedInState()),
    );

    // When
    final viewModel = ParametersProfilePageViewModel.create(store);

    // Then
    expect(viewModel.error, true);
  });
}


