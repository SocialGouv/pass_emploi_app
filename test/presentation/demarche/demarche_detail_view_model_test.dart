import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_detail_view_model.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

void main() {
  test("DemarcheDetailViewModel.create when demarche is on time", () {
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
      attributs: [],
    );
    final store = givenState().copyWith(demarcheListState: DemarcheListSuccessState([demarche], true)).store();

    // When
    final viewModel = DemarcheDetailViewModel.create(store, "8802034");

    // Then
    expect(
        viewModel,
        DemarcheDetailViewModel(
          createdByAdvisor: true,
          modifiedByAdvisor: false,
          dateFormattedTexts: [
            FormattedText("À réaliser pour le "),
            FormattedText("28/04/2023", bold: true),
          ],
          dateBackgroundColor: AppColors.accent3Lighten,
          dateTextColor: AppColors.accent2,
          dateIcons: [Drawables.icClock],
          label: "label",
          titreDetail: "titre",
          sousTitre: "sous titre",
          modificationDate: "23/12/2022",
          creationDate: "23/12/2022",
          attributs: [],
          statutsPossibles: [
            UserActionTagViewModel(
                title: Strings.demarcheToDo,
                backgroundColor: AppColors.accent1Lighten,
                textColor: AppColors.accent1,
                isSelected: true),
            UserActionTagViewModel(
              title: Strings.demarcheInProgress,
              backgroundColor: Colors.transparent,
              textColor: AppColors.grey800,
            ),
            UserActionTagViewModel(
              title: Strings.demarcheDone,
              backgroundColor: Colors.transparent,
              textColor: AppColors.grey800,
            ),
          ],
        ));
  });

  test("DemarcheDetailViewModel.create when demarche is late", () {
    // Given
    final demarche = mockDemarche(
      id: '8802034',
      endDate: parseDateTimeUtcWithCurrentTimeZone('2021-04-28T16:06:48.396Z'),
    );
    final store = givenState().copyWith(demarcheListState: DemarcheListSuccessState([demarche], true)).store();

    // When
    final viewModel = DemarcheDetailViewModel.create(store, "8802034");

    // Then
    expect(
      viewModel.dateFormattedTexts,
      [
        FormattedText("À réaliser pour le "),
        FormattedText("28/04/2021", bold: true),
      ],
    );
    expect(viewModel.dateBackgroundColor, AppColors.warningLighten);
    expect(viewModel.dateTextColor, AppColors.warning);
    expect(viewModel.dateIcons, [Drawables.icImportantOutlined, Drawables.icClock]);
  });
}
