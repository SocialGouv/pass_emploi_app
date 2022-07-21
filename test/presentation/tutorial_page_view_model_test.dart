import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/presentation/tutorial_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test('should dispatch done action correctly', () {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: givenState().loggedInMiloUser().showTutorial(),
    );
    final viewModel = TutorialPageViewModel.create(store);

    // When
    viewModel.onDone();

    // Then
    expect(storeSpy.calledWithDone, true);
  });

  test('should dispatch delayed action correctly', () {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: givenState().loggedInMiloUser().showTutorial(),
    );
    final viewModel = TutorialPageViewModel.create(store);

    // When
    viewModel.onDelay();

    // Then
    expect(storeSpy.calledWithDelay, true);
  });
}


class StoreSpy {
  var calledWithSkip = false;
  var calledWithDone = false;
  var calledWithDelay = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is TutorialDelayedAction) {
      calledWithDelay = true;
    }
    if (action is TutorialDoneAction) {
      calledWithDone = true;
    }
    return currentState;
  }
}