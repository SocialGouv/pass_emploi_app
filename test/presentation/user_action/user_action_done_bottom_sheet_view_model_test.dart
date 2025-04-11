import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_done_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('when action should be retrieved with no source', () {
    test('when details state is initial should display form', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id'))
          .copyWith(userActionUpdateState: UserActionUpdateNotInitializedState())
          .store();

      // When
      final viewModel = UserActionDoneBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test('when details state is loading should display loader', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id'))
          .copyWith(userActionUpdateState: UserActionUpdateLoadingState())
          .store();

      // When
      final viewModel = UserActionDoneBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when details state is failure should display failure', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id'))
          .copyWith(userActionUpdateState: UserActionUpdateFailureState())
          .store();

      // When
      final viewModel = UserActionDoneBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when details state is success should display content', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id')) //
          .copyWith(userActionUpdateState: UserActionUpdateSuccessState(mockUserActionUpdateRequest()))
          .store();

      // When
      final viewModel = UserActionDoneBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('on action done should display ', () {
      // Given
      final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'id')));

      final viewModel = UserActionDoneBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

      // When
      viewModel.onActionDone();

      // Then
      expect(store.dispatchedAction, isA<UserActionUpdateRequestAction>());
    });
  });
}
