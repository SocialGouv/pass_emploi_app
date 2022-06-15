import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../utils/test_datetime.dart';

void main() {
  test(
      "UserActionPEViewModel.create when status is IS_NOT_STARTED and end date is in the future should create view model properly",
      () {
    // Given

    final userAction = Demarche(
      id: "8802034",
      content: "Faire le CV",
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2023-04-28T16:06:48.396Z'),
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      createdByAdvisor: true,
      label: "label",
      possibleStatus: [
        DemarcheStatus.NOT_STARTED,
        DemarcheStatus.IN_PROGRESS,
        DemarcheStatus.DONE,
      ],
      creationDate: DateTime(2022, 12, 23, 0, 0, 0),
      modifiedByAdvisor: false,
      sousTitre: "sous titre",
      titre: "titre",
      modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
      attributs: [],
    );

    // When
    final viewModel = UserActionPEViewModel.create(userAction, false);

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(viewModel.formattedDate, "À réaliser pour le 28/04/2023");
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionPEToDo,
          backgroundColor: AppColors.accent1Lighten,
          textColor: AppColors.accent1,
        ));
  });

  test(
      "UserActionPEViewModel.create when status is IS_NOT_STARTED and end date is in the past should create view model properly",
      () {
    // Given

    final userAction = Demarche(
      id: "8802034",
      content: "Faire le CV",
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      createdByAdvisor: true,
      label: "label",
      possibleStatus: [],
      creationDate: DateTime(2022, 12, 23, 0, 0, 0),
      modifiedByAdvisor: false,
      sousTitre: "sous titre",
      titre: "titre",
      modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
      attributs: [],
    );

    // When
    final viewModel = UserActionPEViewModel.create(userAction, false);

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(viewModel.formattedDate, "À réaliser pour le 28/03/2022");
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionPEToDo,
          backgroundColor: AppColors.warningLighten,
          textColor: AppColors.warning,
        ));
  });

  test("UserActionPEViewModel.create when status is IN_PROGRESS should create view model properly", () {
    // Given

    final userAction = Demarche(
      id: "8802034",
      content: "Faire le CV",
      status: DemarcheStatus.IN_PROGRESS,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2023-03-28T16:06:48.396Z'),
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      createdByAdvisor: true,
      label: "label",
      possibleStatus: [],
      creationDate: DateTime(2022, 12, 23, 0, 0, 0),
      modifiedByAdvisor: false,
      sousTitre: "sous titre",
      titre: "titre",
      modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
      attributs: [],
    );

    // When
    final viewModel = UserActionPEViewModel.create(userAction, false);

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(viewModel.formattedDate, "À réaliser pour le 28/03/2023");
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionPEInProgress,
          backgroundColor: AppColors.accent3Lighten,
          textColor: AppColors.accent3,
        ));
  });

  test(
      "UserActionPEViewModel.create when status is IN_PROGRESS and end date is in the past should create view model properly",
      () {
    // Given

    final userAction = Demarche(
      id: "8802034",
      content: "Faire le CV",
      status: DemarcheStatus.IN_PROGRESS,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      createdByAdvisor: true,
      label: "label",
      possibleStatus: [],
      creationDate: DateTime(2022, 12, 23, 0, 0, 0),
      modifiedByAdvisor: false,
      sousTitre: "sous titre",
      titre: "titre",
      modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
      attributs: [],
    );

    // When
    final viewModel = UserActionPEViewModel.create(userAction, false);

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(viewModel.formattedDate, "À réaliser pour le 28/03/2022");
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionPEInProgress,
          backgroundColor: AppColors.warningLighten,
          textColor: AppColors.warning,
        ));
  });

  test("UserActionPEViewModel.create when status is DONE should create view model properly", () {
    // Given

    final userAction = Demarche(
      id: "8802034",
      content: "Faire le CV",
      status: DemarcheStatus.DONE,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      createdByAdvisor: true,
      label: "label",
      possibleStatus: [],
      creationDate: DateTime(2022, 12, 23, 0, 0, 0),
      modifiedByAdvisor: false,
      sousTitre: "sous titre",
      titre: "titre",
      modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
      attributs: [],
    );

    // When
    final viewModel = UserActionPEViewModel.create(userAction, false);

    // Then
    expect(viewModel.status, DemarcheStatus.DONE);
    expect(viewModel.formattedDate, "Réalisé le 28/03/2022");
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionPEDone,
          backgroundColor: AppColors.accent2Lighten,
          textColor: AppColors.accent2,
        ));
  });

  test("UserActionPEViewModel.create when status is CANCELLED should create view model properly", () {
    // Given

    final userAction = Demarche(
      id: "8802034",
      content: "Faire le CV",
      status: DemarcheStatus.CANCELLED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      createdByAdvisor: true,
      label: "label",
      possibleStatus: [],
      creationDate: DateTime(2022, 12, 23, 0, 0, 0),
      modifiedByAdvisor: false,
      sousTitre: "sous titre",
      titre: "titre",
      modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
      attributs: [],
    );

    // When
    final viewModel = UserActionPEViewModel.create(userAction, false);

    // Then
    expect(viewModel.status, DemarcheStatus.CANCELLED);
    expect(viewModel.formattedDate, "Annulé le 28/03/2022");
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.actionPECancelled,
          backgroundColor: AppColors.accent2Lighten,
          textColor: AppColors.accent2,
        ));
  });
}
