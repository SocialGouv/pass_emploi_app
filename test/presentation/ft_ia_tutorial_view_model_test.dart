import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_actions.dart';
import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_state.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/presentation/ft_ia_tutorial_view_model.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('should return isVisible true when all conditions are met', () {
    // Given
    final monSuivi = mockMonSuivi(eligibleDemarchesIA: true);
    final store =
        givenState().monSuivi(monSuivi: monSuivi).copyWith(ftIaTutorialState: FtIaTutorialState(true)).store();

    // When
    final viewModel = FtIaTutorialViewModel.create(store);

    // Then
    expect(viewModel.isVisible, true);
  });

  test('should return isVisible false when monSuiviState is not MonSuiviSuccessState', () {
    // Given
    final store = givenState()
        .copyWith(
          monSuiviState: MonSuiviNotInitializedState(),
          ftIaTutorialState: FtIaTutorialState(true),
        )
        .store();

    // When
    final viewModel = FtIaTutorialViewModel.create(store);

    // Then
    expect(viewModel.isVisible, false);
  });

  test('should return isVisible false when eligibleDemarchesIA is false', () {
    // Given
    final monSuivi = mockMonSuivi(eligibleDemarchesIA: false);
    final store =
        givenState().monSuivi(monSuivi: monSuivi).copyWith(ftIaTutorialState: FtIaTutorialState(true)).store();

    // When
    final viewModel = FtIaTutorialViewModel.create(store);

    // Then
    expect(viewModel.isVisible, false);
  });

  test('should return isVisible false when ftIaTutorialState.shouldShow is false', () {
    // Given
    final monSuivi = mockMonSuivi(eligibleDemarchesIA: true);
    final store =
        givenState().monSuivi(monSuivi: monSuivi).copyWith(ftIaTutorialState: FtIaTutorialState(false)).store();

    // When
    final viewModel = FtIaTutorialViewModel.create(store);

    // Then
    expect(viewModel.isVisible, false);
  });

  test('should dispatch FtIaTutorialSeenAction when onSeen is called', () {
    // Given
    final monSuivi = mockMonSuivi(eligibleDemarchesIA: true);
    final store = StoreSpy.withState(
      givenState().monSuivi(monSuivi: monSuivi).copyWith(ftIaTutorialState: FtIaTutorialState(true)),
    );
    final viewModel = FtIaTutorialViewModel.create(store);

    // When
    viewModel.onSeen();

    // Then
    expect(store.dispatchedAction, isA<FtIaTutorialSeenAction>());
  });

  test('should return empty onSeen function when conditions are not met', () {
    // Given
    final store = givenState()
        .copyWith(
          monSuiviState: MonSuiviNotInitializedState(),
          ftIaTutorialState: FtIaTutorialState(true),
        )
        .store();

    // When
    final viewModel = FtIaTutorialViewModel.create(store);

    // Then
    expect(viewModel.onSeen, isA<Function>());
    // Should not throw when called
    expect(() => viewModel.onSeen(), returnsNormally);
  });
}
