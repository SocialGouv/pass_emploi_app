import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';

void main() {
  test("UserActionViewModel.create when creator is jeune should create view model properly", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', creator: JeuneActionCreator())).store();

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // Then
    expect(viewModel.creator, Strings.you);
    expect(viewModel.withDeleteOption, true);
  });

  test("UserActionViewModel.create when creator is conseiller should create view model properly", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'actionId', creator: ConseillerActionCreator(name: 'Nils Tavernier')))
        .store();

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // Then
    expect(viewModel.creator, 'Nils Tavernier');
    expect(viewModel.withDeleteOption, false);
  });

  group("create when update action...", () {
    test("set status to NOT_STARTED should dismiss bottom sheet", () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'actionId'))
          .updateActionSuccess(UserActionStatus.NOT_STARTED)
          .store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("set status to IN_PROGRESS should dismiss bottom sheet", () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'actionId'))
          .updateActionSuccess(UserActionStatus.IN_PROGRESS)
          .store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("set status to CANCELED should dismiss bottom sheet", () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'actionId'))
          .updateActionSuccess(UserActionStatus.CANCELED)
          .store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("set status to done should show success screen", () {
      // Given
      final store = givenState() //
          .withAction(mockUserAction(id: 'actionId'))
          .updateActionSuccess(UserActionStatus.DONE)
          .store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.SHOW_SUCCESS);
    });

    test("loads should show loading screen", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).updateActionLoading().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.SHOW_LOADING);
    });

    test("fails should show error", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).updateActionFailure().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.SHOW_UPDATE_ERROR);
    });

    test("is not initialized should set NOT_INIT state", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).updateActionNotInit().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.NOT_INIT);
    });
  });

  test("when action is on time should properly set texts, icons and active color", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', dateEcheance: DateTime(2041, 1, 1))).store();

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // Then
    expect(
      viewModel.dateEcheanceViewModel,
      UserActionDetailDateEcheanceViewModel(
        formattedTexts: [FormattedText("À réaliser pour le "), FormattedText("mardi 1 janvier", bold: true)],
        icons: [Drawables.icClock],
        textColor: AppColors.accent2,
        backgroundColor: AppColors.accent3Lighten,
      ),
    );
  });

  test("when action is late should properly set texts, icons and warning color", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', dateEcheance: DateTime(2021, 1, 1))).store();

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // Then
    expect(
      viewModel.dateEcheanceViewModel,
      UserActionDetailDateEcheanceViewModel(
        formattedTexts: [FormattedText("À réaliser pour le "), FormattedText("vendredi 1 janvier", bold: true)],
        icons: [Drawables.icImportantOutlined, Drawables.icClock],
        textColor: AppColors.warning,
        backgroundColor: AppColors.warningLighten,
      ),
    );
  });

  test("when action is DONE should not display date echeance", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', status: UserActionStatus.DONE)).store();

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // Then
    expect(viewModel.dateEcheanceViewModel, isNull);
  });

  test("when action is CANCELED should not display date echeance", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', status: UserActionStatus.CANCELED)).store();

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // Then
    expect(viewModel.dateEcheanceViewModel, isNull);
  });

  group("create when delete action ...", () {
    test("succeeds should dismiss bottom sheet", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionSuccess().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.TO_DISMISS_AFTER_DELETION);
    });

    test("loads should display loading", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionLoading().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.SHOW_LOADING);
    });

    test("fails should display error", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionFailure().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.SHOW_DELETE_ERROR);
    });

    test("is not initialized should set NOT_INIT state", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionNotInit().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.NOT_INIT);
    });
  });

  test('refreshStatus when update status has changed should dispatch a UpdateActionStatus', () {
    // Given
    final store = StoreSpy.withState(givenState().loggedInMiloUser().withAction(mockUserAction(id: 'actionId')));

    // When
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');
    viewModel.onRefreshStatus("actionId", UserActionStatus.NOT_STARTED);

    // Then
    expect(store.dispatchedAction, isA<UserActionUpdateRequestAction>());
  });

  test('onDelete should dispatch UserActionDeleteRequestAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'actionId')));
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // When
    viewModel.onDelete('actionId');

    // Then
    expect(store.dispatchedAction, isA<UserActionDeleteRequestAction>());
    expect((store.dispatchedAction as UserActionDeleteRequestAction).actionId, 'actionId');
  });

  test('resetUpdateStatus should dispatch UserActionUpdateResetAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'actionId')));
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // When
    viewModel.resetUpdateStatus();

    // Then
    expect(store.dispatchedAction, isA<UserActionUpdateResetAction>());
    expect(viewModel.updateDisplayState, UpdateDisplayState.NOT_INIT);
  });

  test('should reset create action', () {
    // Given
    final store = StoreSpy.withState(
      AppState.initialState().copyWith(userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')])),
    );
    final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

    // When
    viewModel.onRefreshStatus("id", UserActionStatus.DONE);

    // Then
    expectTypeThen<UserActionUpdateRequestAction>(store.dispatchedAction, (action) {
      expect(action.actionId, "id");
      expect(action.newStatus, UserActionStatus.DONE);
    });
  });

  group("create when action ...", () {
    test("has no comments should set withComments to false", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).actionWithoutComments().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.withComments, isFalse);
    });

    test("has comments should set withComments to true", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).actionWithComments().store();

      // When
      final viewModel = UserActionDetailsViewModel.createFromUserActionListState(store, 'actionId');

      // Then
      expect(viewModel.withComments, isTrue);
    });
  });
}
