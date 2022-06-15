import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

void main() {
  test("UserActionViewModel.create when creator is jeune should create view model properly", () {
    // Given
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.IN_PROGRESS,
      lastUpdate: DateTime(2022),
      creator: JeuneActionCreator(),
    );

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.creator, Strings.you);
    expect(viewModel.withDeleteOption, true);
  });

  test("UserActionViewModel.create when creator is conseiller should create view model properly", () {
    // Given
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.IN_PROGRESS,
      lastUpdate: DateTime(2022),
      creator: ConseillerActionCreator(name: "Nils Tavernier"),
    );

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.creator, "Nils Tavernier");
    expect(viewModel.withDeleteOption, false);
  });

  test("UserActionViewModel.create when status is done should create view model properly", () {
    // Given
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.DONE,
      lastUpdate: DateTime(2022),
      creator: ConseillerActionCreator(name: "Nils Tavernier"),
    );

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
        ));
  });

  test("UserActionViewModel.create when status is not started should create view model properly", () {
    // Given
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.NOT_STARTED,
      lastUpdate: DateTime(2022),
      creator: ConseillerActionCreator(name: "Nils Tavernier"),
    );

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
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.IN_PROGRESS,
      lastUpdate: DateTime(2022),
      creator: ConseillerActionCreator(name: "Nils Tavernier"),
    );

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
        ));
  });

  test("UserActionViewModel.create when status is canceled should create view model properly", () {
    // Given
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.CANCELED,
      lastUpdate: DateTime(2022),
      creator: ConseillerActionCreator(name: "Nils Tavernier"),
    );

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
        ));
  });

  test("UserActionViewModel.create should properly display last update date", () {
    // Given
    final userAction = UserAction(
      id: "id",
      content: "content",
      comment: "comment",
      status: UserActionStatus.IN_PROGRESS,
      lastUpdate: DateTime(2022, 1, 12),
      creator: ConseillerActionCreator(name: "Nils Tavernier"),
    );

    // When
    final viewModel = UserActionViewModel.create(userAction);

    // Then
    expect(viewModel.lastUpdate, "Modifiée le 12/01/2022");
  });
}
