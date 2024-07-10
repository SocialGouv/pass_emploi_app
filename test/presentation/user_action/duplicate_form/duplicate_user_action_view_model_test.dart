import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/duplicate_form/duplicate_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test("create when state is loading should set display state to loading", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'id'))
        .copyWith(userActionCreateState: UserActionCreateLoadingState())
        .store();

    // When
    final viewModel = DuplicateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // Then
    expect(viewModel.displayState, isA<DisplayLoading>());
  });

  test("create when state is not initialized should set display state to show content", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'id'))
        .copyWith(userActionCreateState: UserActionCreateNotInitializedState())
        .store();

    // When
    final viewModel = DuplicateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // Then
    expect(viewModel.displayState, isA<DisplayContent>());
  });

  test("create when state is success should set display state to dismiss", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'id'))
        .copyWith(
          userActionCreateState: UserActionCreateSuccessState('USER-ACTION-ID'),
        )
        .store();

    // When
    final viewModel = DuplicateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // Then
    expect(viewModel.displayState, isA<ShowConfirmationPage>());
    expect((viewModel.displayState as ShowConfirmationPage).userActionCreatedId, 'USER-ACTION-ID');
  });

  test("create when state is failure should display an error", () {
    // Given
    final store = givenState()
        .withAction(mockUserAction(id: 'id'))
        .copyWith(userActionCreateState: UserActionCreateFailureState())
        .store();

    // When
    final viewModel = DuplicateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // Then
    expect(viewModel.displayState, isA<DismissWithFailure>());
  });

  test('duplicate should dispatch CreateUserAction and evenement engagement', () {
    // Given
    final store = StoreSpy.withState(
      givenState()
          .withAction(mockUserAction(id: 'id', status: UserActionStatus.NOT_STARTED))
          .copyWith(userActionCreateState: UserActionCreateLoadingState()),
    );
    final viewModel = DuplicateUserActionViewModel.create(store, UserActionStateSource.noSource, 'id');

    // When
    final request = UserActionCreateRequest(
      "content",
      "comment",
      DateTime(2023),
      false,
      UserActionStatus.NOT_STARTED,
      UserActionReferentielType.emploi,
      true,
    );

    viewModel.duplicate(
      request.dateEcheance,
      request.content,
      request.comment,
      request.codeQualification,
    );

    // Then
    expect(store.dispatchedActions.first, isA<UserActionCreateRequestAction>());
    expect((store.dispatchedActions.first as UserActionCreateRequestAction).request, request);
    expect(store.dispatchedActions.last, isA<TrackingEvenementEngagementAction>());
  });
}
