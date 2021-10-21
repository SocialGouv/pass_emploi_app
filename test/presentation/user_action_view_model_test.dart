import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';

main() {
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
  });
}
