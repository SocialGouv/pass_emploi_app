import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/user_action_details_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when action has been updated should show success", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState:
          AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.updated()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_SUCCESS);
  });

  test("create when action is not updating should show content", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.notUpdating()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_CONTENT);
  });

  test("create when action is no update needed should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.noUpdateNeeded()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS);
  });

  test("create when action is no update needed should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.noUpdateNeeded()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS);
  });
}

class StoreSpy {
  var calledWithDismiss = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is DismissUserActionUpdated) {
      calledWithDismiss = true;
    }
    return currentState;
  }
}
