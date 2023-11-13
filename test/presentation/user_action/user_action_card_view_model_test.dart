import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('UserActionCardViewModel.create when state source is UserActions', () {
    test("and status is done should create view model properly", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.DONE);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: "Terminée",
          backgroundColor: AppColors.accent2Lighten,
          textColor: AppColors.accent2,
        ),
      );
    });

    test("and status is not started should create view model properly", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.NOT_STARTED);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(
          viewModel.tag,
          UserActionTagViewModel(
            title: Strings.todoPillule,
            backgroundColor: AppColors.accent1Lighten,
            textColor: AppColors.accent1,
          ));
    });

    test("and status is in progress should create view model properly", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.IN_PROGRESS);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.doingPillule,
          backgroundColor: AppColors.accent3Lighten,
          textColor: AppColors.accent3,
        ),
      );
    });

    test("and status is canceled should create view model properly", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.CANCELED);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: "Annulée",
          backgroundColor: AppColors.accent2Lighten,
          textColor: AppColors.accent2,
        ),
      );
    });

    test("and dateEcheance is in future should display it as on time", () {
      // Given
      final action = mockUserAction(id: '1', dateEcheance: DateTime(2042, 1, 2), status: UserActionStatus.NOT_STARTED);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(
        viewModel.dateEcheanceViewModel,
        UserActionDateEcheanceViewModel(
          formattedTexts: [FormattedText("À réaliser pour le jeudi 2 janvier")],
          color: AppColors.contentColor,
        ),
      );
    });

    test("and dateEcheance is today should display it as on time", () {
      final today = DateTime(2022, 1, 2);
      withClock(Clock.fixed(today), () {
        // Given
        final action = mockUserAction(id: '1', dateEcheance: today, status: UserActionStatus.IN_PROGRESS);
        final store = givenState().withUserActions([action]).store();

        // When
        final viewModel = UserActionCardViewModel.create(
          store: store,
          stateSource: UserActionStateSource.list,
          actionId: '1',
          simpleCard: false,
        );

        // Then
        expect(
          viewModel.dateEcheanceViewModel,
          UserActionDateEcheanceViewModel(
            formattedTexts: [FormattedText("À réaliser pour le dimanche 2 janvier")],
            color: AppColors.contentColor,
          ),
        );
      });
    });

    test("and dateEcheance is in past should display it as late", () {
      // Given
      final action = mockUserAction(id: '1', dateEcheance: DateTime(2022, 1, 2), status: UserActionStatus.IN_PROGRESS);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(
        viewModel.dateEcheanceViewModel,
        UserActionDateEcheanceViewModel(
          formattedTexts: [
            FormattedText("En retard : ", bold: true),
            FormattedText("À réaliser pour le dimanche 2 janvier"),
          ],
          color: AppColors.warning,
        ),
      );
    });

    test("and status is DONE should not display date echeance", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.DONE);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(viewModel.dateEcheanceViewModel, isNull);
    });

    test("and status is CANCELED should not display date echeance", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.CANCELED);
      final store = givenState().withUserActions([action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.list,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(viewModel.dateEcheanceViewModel, isNull);
    });
  });

  group('UserActionCardViewModel.create when state source is agenda', () {
    test("should retrieve action from agenda and create view model properly", () {
      // Given
      final action = mockUserAction(id: '1', content: 'content');
      final store = givenState().agenda(actions: [action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.agenda,
        actionId: '1',
        simpleCard: false,
      );

      // Then
      expect(viewModel.title, 'content');
    });
  });

  group('UserActionCardViewModel.create when simpleCard is true', () {
    test("should neither display date nor subtitle", () {
      // Given
      final action = mockUserAction(id: '1', content: 'content', comment: 'subtitle', dateEcheance: DateTime(2023));
      final store = givenState().agenda(actions: [action]).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.agenda,
        actionId: '1',
        simpleCard: true,
      );

      // Then
      expect(viewModel.withSubtitle, isFalse);
      expect(viewModel.dateEcheanceViewModel, isNull);
    });
  });
}
