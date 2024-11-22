import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/update_form/update_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test('create should work when state source is mon suivi', () {
    // Given
    final store = givenState().monSuivi(monSuivi: mockMonSuivi(actions: [mockUserAction(id: 'id')])).store();

    // When
    final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.monSuivi, 'id');

    // Then
    expect(viewModel, isNotNull);
  });

  test('create should work when no action is found to handle the case where user delete the action', () {
    // Given
    final store = givenState().monSuivi().store();

    // When
    final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.monSuivi, 'id');

    // Then
    expect(viewModel, isNotNull);
  });

  test("create should return all user action's attributes", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(
          id: 'id',
          dateEcheance: DateTime(2024),
          content: 'title',
          comment: 'description',
          type: UserActionReferentielType.emploi,
        ))
        .store();

    // When
    final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // Then
    expect(viewModel.id, 'id');
    expect(viewModel.date, DateTime(2024));
    expect(viewModel.title, 'title');
    expect(viewModel.description, 'description');
    expect(viewModel.type, UserActionReferentielType.emploi);
  });

  group('showLoading', () {
    test('when update state is loading should return true', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id'))
          .copyWith(userActionUpdateState: UserActionUpdateLoadingState())
          .store();

      // When
      final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.showLoading, isTrue);
    });

    test('when delete state is loading should return true', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id'))
          .copyWith(userActionDeleteState: UserActionDeleteLoadingState())
          .store();

      // When
      final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.showLoading, isTrue);
    });

    test('otherwise should return false', () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'id'))
          .copyWith(userActionUpdateState: UserActionUpdateNotInitializedState())
          .copyWith(userActionDeleteState: UserActionDeleteNotInitializedState())
          .store();

      // When
      final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

      // Then
      expect(viewModel.showLoading, isFalse);
    });
  });

  test('save should dispatch UserActionUpdateRequestAction', () {
    // Given
    final userAction = mockUserAction(id: 'id');
    final store = StoreSpy.withState(givenState().withAction(userAction));
    final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // When
    viewModel.save(DateTime(2025), 'new title', 'new description', UserActionReferentielType.citoyennete);

    // Then
    expect(store.dispatchedAction, isA<UserActionUpdateRequestAction>());
    final action = store.dispatchedAction as UserActionUpdateRequestAction;
    expect(action.actionId, 'id');
    expect(
      action.request,
      UserActionUpdateRequest(
        status: userAction.status,
        dateEcheance: DateTime(2025),
        contenu: 'new title',
        description: 'new description',
        type: UserActionReferentielType.citoyennete,
      ),
    );
  });

  test('delete should dispatch UserActionDeleteRequestAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'id')));
    final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // When
    viewModel.delete();

    // Then
    expect(store.dispatchedAction, isA<UserActionDeleteRequestAction>());
    expect((store.dispatchedAction as UserActionDeleteRequestAction).actionId, 'id');
  });

  group('display state', () {
    group('when source is chat partage', () {
      test('should display loading when detail state is not initialized', () {
        // Given
        final store = givenState().copyWith(userActionDetailsState: UserActionDetailsNotInitializedState()).store();

        // When
        final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.chatPartage, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('should display loading when detail state is loading', () {
        // Given
        final store = givenState().copyWith(userActionDetailsState: UserActionDetailsLoadingState()).store();

        // When
        final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.chatPartage, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('should display failure when detail state is loading', () {
        // Given
        final store = givenState().copyWith(userActionDetailsState: UserActionDetailsFailureState()).store();

        // When
        final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.chatPartage, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });

      test('should display content when detail state is success', () {
        // Given
        final store =
            givenState().copyWith(userActionDetailsState: UserActionDetailsSuccessState(mockUserAction())).store();

        // When
        final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.chatPartage, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    group('when source is not chatPartage', () {
      test('should display content', () {
        // Given
        final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'id')));

        // When
        final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    test('onRetry should dispatch UserActionDetailsRequestAction', () {
      // Given
      final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'id')));
      final viewModel = UpdateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

      // When
      viewModel.onRety();

      // Then
      expect(store.dispatchedAction, isA<UserActionDetailsRequestAction>());
      expect((store.dispatchedAction as UserActionDetailsRequestAction).userActionId, 'id');
    });
  });
}
