import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_add_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_create_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when state is loading should set isLoading to true", () {
    // Given
    final state = AppState.initialState().copyWith(createUserActionState: UserActionCreateState.loading());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionAddViewModel.create(store);

    // Then
    expect(viewModel.isLoading, true);
  });

  test("create when state is not loading should set isLoading to false", () {
    // Given
    final state = AppState.initialState().copyWith(createUserActionState: UserActionCreateState.notInitialized());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = UserActionAddViewModel.create(store);

    // Then
    expect(viewModel.isLoading, false);
  });

  test('createUserAction should dispatch CreateUserAction', () {
    // Given
    final storeSpy = StoreSpy();
    final state = AppState.initialState();
    final store = Store<AppState>(storeSpy.reducer, initialState: state);
    final viewModel = UserActionAddViewModel.create(store);

    // When
    viewModel.createUserAction("content", "comment", UserActionStatus.DONE);

    // Then
    expect(storeSpy.calledWithCreate, true);
  });
}

class StoreSpy {
  var calledWithCreate = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is CreateUserAction) {
      if (action.content == "content" && action.comment == "comment" && action.initialStatus ==  UserActionStatus.DONE) {
        calledWithCreate = true;
      }
    }
    return currentState;
  }
}
