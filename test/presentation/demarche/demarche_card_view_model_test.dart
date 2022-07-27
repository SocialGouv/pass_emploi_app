import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../utils/test_datetime.dart';

void main() {
  test("create full test", () {
    // Given
    final demarche = Demarche(
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
      attributs: [DemarcheAttribut(key: 'description', value: 'commentaire')],
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(
      viewModel,
      DemarcheCardViewModel(
        id: '8802034',
        titre: 'Faire le CV',
        sousTitre: 'commentaire',
        status: DemarcheStatus.NOT_STARTED,
        createdByAdvisor: true,
        modifiedByAdvisor: false,
        tag: UserActionTagViewModel(
          title: Strings.demarcheToDo,
          backgroundColor: AppColors.accent1Lighten,
          textColor: AppColors.accent1,
        ),
        dateFormattedTexts: [FormattedText('À réaliser pour le 28/04/2023')],
        dateColor: AppColors.primary,
        isDetailEnabled: false,
      ),
    );
  });

  test("create when status is IS_NOT_STARTED and end date is in the future should create view model properly", () {
    // Given
    final demarche = _demarche(
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2050-04-28T16:06:48.396Z'),
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(viewModel.dateFormattedTexts, [FormattedText('À réaliser pour le 28/04/2050')]);

    expect(viewModel.dateColor, AppColors.primary);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: Strings.demarcheToDo,
        backgroundColor: AppColors.accent1Lighten,
        textColor: AppColors.accent1,
      ),
    );
  });

  test("create when status is IS_NOT_STARTED and end date is in the past should create view model properly", () {
    // Given
    final demarche = _demarche(
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(
      viewModel.dateFormattedTexts,
      [
        FormattedText('En retard : ', bold: true),
        FormattedText('À réaliser pour le 28/03/2022'),
      ],
    );
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.demarcheToDo,
          backgroundColor: AppColors.warningLighten,
          textColor: AppColors.warning,
        ));
  });

  test("create when status is IN_PROGRESS should create view model properly", () {
    // Given
    final demarche = _demarche(
      status: DemarcheStatus.IN_PROGRESS,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2050-03-28T16:06:48.396Z'),
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(viewModel.dateFormattedTexts, [FormattedText('À réaliser pour le 28/03/2050')]);
    expect(viewModel.dateColor, AppColors.primary);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: Strings.demarcheInProgress,
        backgroundColor: AppColors.accent3Lighten,
        textColor: AppColors.accent3,
      ),
    );
  });

  test("create when status is IN_PROGRESS and end date is in the past should create view model properly", () {
    // Given
    final demarche = _demarche(
      status: DemarcheStatus.IN_PROGRESS,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(
      viewModel.dateFormattedTexts,
      [
        FormattedText('En retard : ', bold: true),
        FormattedText('À réaliser pour le 28/03/2022'),
      ],
    );
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: Strings.demarcheInProgress,
        backgroundColor: AppColors.warningLighten,
        textColor: AppColors.warning,
      ),
    );
  });

  test("create when status is DONE should create view model properly", () {
    // Given
    final demarche = _demarche(
      status: DemarcheStatus.DONE,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(viewModel.status, DemarcheStatus.DONE);
    expect(viewModel.dateFormattedTexts, [FormattedText('Réalisé le 28/03/2022')]);
    expect(viewModel.dateColor, AppColors.grey700);
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: Strings.demarcheDone,
          backgroundColor: AppColors.accent2Lighten,
          textColor: AppColors.accent2,
        ));
  });

  test("create when status is CANCELLED should create view model properly", () {
    // Given
    final demarche = _demarche(
      status: DemarcheStatus.CANCELLED,
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2020-03-28T16:06:48.396Z'),
    );

    // When
    final viewModel = DemarcheCardViewModel.create(demarche, false);

    // Then
    expect(viewModel.status, DemarcheStatus.CANCELLED);
    expect(viewModel.dateFormattedTexts, [FormattedText('Annulé le 28/03/2020')]);
    expect(viewModel.dateColor, AppColors.grey700);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: Strings.demarcheCancelled,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      ),
    );
  });
}

Demarche _demarche({required DemarcheStatus status, DateTime? endDate, DateTime? deletionDate}) {
  return Demarche(
    id: 'id',
    content: null,
    status: status,
    endDate: endDate,
    deletionDate: deletionDate,
    createdByAdvisor: true,
    label: null,
    possibleStatus: [],
    creationDate: null,
    modifiedByAdvisor: false,
    sousTitre: null,
    titre: null,
    modificationDate: null,
    attributs: [],
  );
}
