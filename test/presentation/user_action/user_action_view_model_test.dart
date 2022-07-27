import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../doubles/fixtures.dart';

void main() {
  test("UserActionViewModel.create when creator is jeune should create view model properly", () {
    // Given
    final userAction = mockUserAction(creator: JeuneActionCreator());

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.creator, Strings.you);
    expect(viewModel.withDeleteOption, true);
  });

  test("UserActionViewModel.create when creator is conseiller should create view model properly", () {
    // Given
    final userAction = mockUserAction(creator: ConseillerActionCreator(name: "Nils Tavernier"));

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.creator, "Nils Tavernier");
    expect(viewModel.withDeleteOption, false);
  });

  test("UserActionViewModel.create when status is done should create view model properly", () {
    // Given
    final userAction = mockUserAction(status: UserActionStatus.DONE);

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.status, UserActionStatus.DONE);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: "Terminée",
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      ),
    );
  });

  test("UserActionViewModel.create when status is not started should create view model properly", () {
    // Given
    final userAction = mockUserAction(status: UserActionStatus.NOT_STARTED);

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.status, UserActionStatus.NOT_STARTED);
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionToDo,
          backgroundColor: AppColors.accent1Lighten,
          textColor: AppColors.accent1,
        ));
  });

  test("UserActionViewModel.create when status is in progress should create view model properly", () {
    // Given
    final userAction = mockUserAction(status: UserActionStatus.IN_PROGRESS);

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.status, UserActionStatus.IN_PROGRESS);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: Strings.actionInProgress,
        backgroundColor: AppColors.accent3Lighten,
        textColor: AppColors.accent3,
      ),
    );
  });

  test("UserActionViewModel.create when status is canceled should create view model properly", () {
    // Given
    final userAction = mockUserAction(status: UserActionStatus.CANCELED);

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.status, UserActionStatus.CANCELED);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: "Annulée",
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      ),
    );
  });

  test("UserActionViewModel.create should properly display last update date", () {
    // Given
    final userAction = mockUserAction(lastUpdate: DateTime(2022, 1, 12));

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.lastUpdate, "Modifiée le 12/01/2022");
  });

  test("UserActionViewModel.create when dateEcheance is in future should display it as on time", () {
    // Given
    final userAction = mockUserAction(dateEcheance: DateTime(2042, 1, 2));

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.dateEcheanceFormattedTexts, [FormattedText("À réaliser pour le jeudi 2 janvier")]);
    expect(viewModel.dateEcheanceColor, AppColors.primary);
  });

  test("UserActionViewModel.create when dateEcheance is today should display it as on time", () {
    final today = DateTime(2022, 1, 2);
    withClock(Clock.fixed(today), () {
      // Given
      final userAction = mockUserAction(dateEcheance: today);

      // When
      final viewModel = UserActionViewModel.create(userAction);

      // Then
      expect(viewModel.dateEcheanceFormattedTexts, [FormattedText("À réaliser pour le dimanche 2 janvier")]);
      expect(viewModel.dateEcheanceColor, AppColors.primary);
    });
  });

  test("UserActionViewModel.create when dateEcheance is in past should display it as late", () {
    // Given
    final userAction = mockUserAction(dateEcheance: DateTime(2022, 1, 2));

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.dateEcheanceFormattedTexts, [
      FormattedText("En retard : ", bold: true),
      FormattedText("À réaliser pour le dimanche 2 janvier"),
    ]);
    expect(viewModel.dateEcheanceColor, AppColors.warning);
  });
}
