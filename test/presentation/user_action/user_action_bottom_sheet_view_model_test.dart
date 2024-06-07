import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('UserActionBottomSheetViewModel', () {
    group('withUpdateButton', () {
      test('should not display update button when qualification status is qualified', () {
        // Given
        final action = mockUserAction(
          id: 'id',
          creator: JeuneActionCreator(),
          qualificationStatus: UserActionQualificationStatus.QUALIFIEE,
        );
        final store = givenState().withAction(action).store();

        // When
        final viewModel = UserActionBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.withUpdateButton, isFalse);
      });

      test('should display update button when qualification status is not qualified', () {
        // Given
        final action = mockUserAction(
          id: 'id',
          creator: JeuneActionCreator(),
          qualificationStatus: UserActionQualificationStatus.A_QUALIFIER,
        );
        final store = givenState().withAction(action).store();

        // When
        final viewModel = UserActionBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.withUpdateButton, isTrue);
      });
    });

    group('withDeleteButton', () {
      test("when creator is conseiller should be false", () {
        // Given
        final store = givenState()
            .withAction(mockUserAction(id: 'id', creator: ConseillerActionCreator(name: 'Nils Tavernier')))
            .store();

        // When
        final viewModel = UserActionBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.withDeleteButton, isFalse);
      });

      test("when creator is jeune and action is qualified should be false", () {
        // Given
        final action = mockUserAction(
          id: 'id',
          creator: JeuneActionCreator(),
          qualificationStatus: UserActionQualificationStatus.QUALIFIEE,
        );
        final store = givenState().withAction(action).store();

        // When
        final viewModel = UserActionBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.withDeleteButton, isFalse);
      });

      test("when creator is jeune and action is done should be false", () {
        // Given
        final action = mockUserAction(
          id: 'id',
          creator: JeuneActionCreator(),
          status: UserActionStatus.DONE,
        );
        final store = givenState().withAction(action).store();

        // When
        final viewModel = UserActionBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.withDeleteButton, isFalse);
      });

      test("when creator is jeune and action is not qualified should be true", () {
        // Given
        final action = mockUserAction(
          id: 'id',
          creator: JeuneActionCreator(),
          qualificationStatus: UserActionQualificationStatus.A_QUALIFIER,
        );
        final store = givenState().withAction(action).store();

        // When
        final viewModel = UserActionBottomSheetViewModel.create(store, UserActionStateSource.noSource, 'id');

        // Then
        expect(viewModel.withDeleteButton, isTrue);
      });
    });
  });
}
