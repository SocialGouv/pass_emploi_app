import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/models/tutorial.dart';
import 'package:pass_emploi_app/presentation/tutorial_page_view_model.dart';

import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('should returns same pages from TutorialState', () {
    // Given
    final store = givenState().showTutorial().store();

    // When
    final viewModel = TutorialPageViewModel.create(store);

    // Then
    expect(viewModel.pages, Tutorial.milo);
  });

  test('should dispatch done action correctly', () {
    // Given
    final store = StoreSpy.withState(givenState().showTutorial());
    final viewModel = TutorialPageViewModel.create(store);

    // When
    viewModel.onDone();

    // Then
    expect(store.dispatchedAction, isA<TutorialDoneAction>());
  });

  test('should dispatch delayed action correctly', () {
    // Given
    final store = StoreSpy.withState(givenState().showTutorial());
    final viewModel = TutorialPageViewModel.create(store);

    // When
    viewModel.onDelay();

    // Then
    expect(store.dispatchedAction, isA<TutorialDelayedAction>());
  });
}
