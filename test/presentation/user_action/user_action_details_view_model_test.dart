import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';

void main() {
  test(
      "UserActionViewModel.create when creator is jeune and action has no comment should create view model properly and autorize delete",
      () {
    // Given
    final action = mockUserAction(id: 'actionId', creator: JeuneActionCreator());
    final store = givenState().withAction(action).actionWithoutComments().store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.creator, Strings.you);
    expect(viewModel.withDeleteOption, isTrue);
  });

  test("UserActionViewModel.create when status is done should not autorize delete", () {
    // Given
    final action = mockUserAction(id: 'actionId', creator: JeuneActionCreator(), status: UserActionStatus.DONE);
    final store = givenState().withAction(action).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.withDeleteOption, isFalse);
  });

  test(
      "UserActionViewModel.create when creator is jeune and action has comments should create view model properly and not autorize delete",
      () {
    // Given
    final action = mockUserAction(id: 'actionId', creator: JeuneActionCreator());
    final store = givenState().withAction(action).actionWithComments().store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.creator, Strings.you);
    expect(viewModel.withDeleteOption, isFalse);
  });

  test(
      "UserActionViewModel.create when creator is conseiller should create view model properly and not autorize delete",
      () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'actionId', creator: ConseillerActionCreator(name: 'Nils Tavernier')))
        .store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.creator, 'Nils Tavernier');
    expect(viewModel.withDeleteOption, isFalse);
  });

  group("create when update action...", () {
    test("set status to NOT_STARTED should dismiss bottom sheet", () {
      // Given
      final store = givenState()
          .withAction(mockUserAction(id: 'actionId'))
          .updateActionSuccess(UserActionStatus.NOT_STARTED)
          .store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

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
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

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
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

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
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.SHOW_SUCCESS);
    });

    test("loads should show loading screen", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).updateActionLoading().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.SHOW_LOADING);
    });

    test("fails should show error", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).updateActionFailure().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.SHOW_UPDATE_ERROR);
    });

    test("is not initialized should set NOT_INIT state", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).updateActionNotInit().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.updateDisplayState, UpdateDisplayState.NOT_INIT);
    });
  });

  test("UserActionViewModel.create when action is on time should properly set texts, icons and active color", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', dateEcheance: DateTime(2041, 1, 1))).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(
      viewModel.dateEcheanceViewModel,
      UserActionDetailDateEcheanceViewModel(
        formattedTexts: [FormattedText("À réaliser pour le "), FormattedText("mardi 1 janvier", bold: true)],
        icons: [AppIcons.schedule_rounded],
        textColor: AppColors.accent2,
        backgroundColor: AppColors.accent3Lighten,
      ),
    );
  });

  test("UserActionViewModel.create when action is late should properly set texts, icons and warning color", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', dateEcheance: DateTime(2021, 1, 1))).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(
      viewModel.dateEcheanceViewModel,
      UserActionDetailDateEcheanceViewModel(
        formattedTexts: [FormattedText("À réaliser pour le "), FormattedText("vendredi 1 janvier", bold: true)],
        icons: [AppIcons.schedule_rounded],
        textColor: AppColors.warning,
        backgroundColor: AppColors.warningLighten,
      ),
    );
  });

  test("UserActionViewModel.create when action is DONE should not display date echeance", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', status: UserActionStatus.DONE)).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.dateEcheanceViewModel, isNull);
  });

  test("UserActionViewModel.create when action is CANCELED should not display date echeance", () {
    // Given
    final store = givenState().withAction(mockUserAction(id: 'actionId', status: UserActionStatus.CANCELED)).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.dateEcheanceViewModel, isNull);
  });

  test("UserActionViewModel.create when Connectivity is unavailable should set withOfflineBehavior to false", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'actionId', status: UserActionStatus.CANCELED))
        .withConnectivity(ConnectivityResult.wifi)
        .store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.withOfflineBehavior, isFalse);
  });

  test("UserActionViewModel.create when Connectivity is not available should set withOfflineBehavior to true", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'actionId', status: UserActionStatus.CANCELED))
        .withConnectivity(ConnectivityResult.none)
        .store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.withOfflineBehavior, isTrue);
  });

  test("UserActionViewModel.create when source is agenda should create view model properly", () {
    // Given
    final action = mockUserAction(id: 'actionId', content: 'content');
    final store = givenState().agenda(actions: [action]).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.agenda, 'actionId');

    // Then
    expect(viewModel.title, 'content');
  });

  test("should display doign pill when status is not done", () {
    // Given
    final action = mockUserAction(id: 'actionId', content: 'content', status: UserActionStatus.IN_PROGRESS);
    final store = givenState().withAction(action).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.pillule, CardPilluleType.todo);
  });

  test("should display done pill when status is done", () {
    // Given
    final action = mockUserAction(id: 'actionId', content: 'content', status: UserActionStatus.DONE);
    final store = givenState().withAction(action).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.pillule, CardPilluleType.done);
  });

  test("should display finished button when status is not done", () {
    // Given
    final action = mockUserAction(id: 'actionId', content: 'content', status: UserActionStatus.IN_PROGRESS);
    final store = givenState().withAction(action).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.withFinishedButton, true);
    expect(viewModel.withUnfinishedButton, false);
  });

  test("should display finished button when status is not done", () {
    // Given
    final action = mockUserAction(id: 'actionId', content: 'content', status: UserActionStatus.DONE);
    final store = givenState().withAction(action).store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // Then
    expect(viewModel.withFinishedButton, false);
    expect(viewModel.withUnfinishedButton, true);
  });

  group('Category', () {
    test("should display Aucune category when no category is provided", () {
      // Given
      final action = mockUserAction(id: 'actionId', type: null);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.category, "Aucune");
    });

    test("should display category when provided", () {
      // Given
      final action = mockUserAction(id: 'actionId', type: UserActionReferentielType.formation);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.category, "Formation");
    });
  });

  group('date', () {
    test("should display date when provided", () {
      // Given
      final action = mockUserAction(id: 'actionId', dateEcheance: DateTime(2021, 1, 1));
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.date, "01/01/2021");
    });
  });

  group("create when delete action ...", () {
    test("succeeds should dismiss bottom sheet", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionSuccess().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.TO_DISMISS_AFTER_DELETION);
    });

    test("loads should display loading", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionLoading().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.SHOW_LOADING);
    });

    test("fails should display error", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionFailure().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.SHOW_DELETE_ERROR);
    });

    test("is not initialized should set NOT_INIT state", () {
      // Given
      final store = givenState().withAction(mockUserAction(id: 'actionId')).deleteActionNotInit().store();

      // When
      final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

      // Then
      expect(viewModel.deleteDisplayState, DeleteDisplayState.NOT_INIT);
    });
  });

  test('refreshStatus when update status has changed should dispatch a UpdateActionStatus', () {
    // Given
    final store = StoreSpy.withState(givenState().loggedInMiloUser().withAction(mockUserAction(id: 'actionId')));

    // When
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');
    viewModel.onRefreshStatus("actionId", UserActionStatus.NOT_STARTED);

    // Then
    expect(store.dispatchedAction, isA<UserActionUpdateRequestAction>());
  });

  test('onDelete should dispatch UserActionDeleteRequestAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'actionId')));
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // When
    viewModel.onDelete('actionId');

    // Then
    expect(store.dispatchedAction, isA<UserActionDeleteRequestAction>());
    expect((store.dispatchedAction as UserActionDeleteRequestAction).actionId, 'actionId');
  });

  test('resetUpdateStatus should dispatch UserActionUpdateResetAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withAction(mockUserAction(id: 'actionId')));
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

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
    final viewModel = UserActionDetailsViewModel.create(store, UserActionStateSource.list, 'actionId');

    // When
    viewModel.onRefreshStatus("id", UserActionStatus.DONE);

    // Then
    expectTypeThen<UserActionUpdateRequestAction>(store.dispatchedAction, (action) {
      expect(action.actionId, "id");
      expect(action.newStatus, UserActionStatus.DONE);
    });
  });
}
