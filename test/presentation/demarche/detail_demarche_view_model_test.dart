import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_detail_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_datetime.dart';
import '../../utils/test_setup.dart';

void main() {
  test("view model should be created", () {
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
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        demarcheListState: DemarcheListSuccessState([userAction], true),
      ),
    );

    // When
    final viewModel = DemarcheDetailViewModel.create(store, "8802034");

    // Then
    expect(
        viewModel,
        DemarcheDetailViewModel(
          createdByAdvisor: true,
          modifiedByAdvisor: false,
          formattedDate: "À réaliser pour le 28/04/2023",
          label: "label",
          titreDetail: "titre",
          sousTitre: "sous titre",
          modificationDate: "23/12/2022",
          creationDate: "23/12/2022",
          attributs: [],
          statutsPossibles: [
            UserActionTagViewModel(
                title: Strings.actionPEToDo,
                backgroundColor: AppColors.accent1Lighten,
                textColor: AppColors.accent1,
                isSelected: true),
            UserActionTagViewModel(
                title: Strings.actionPEInProgress, backgroundColor: Colors.transparent, textColor: AppColors.grey800),
            UserActionTagViewModel(
                title: Strings.actionPEDone, backgroundColor: Colors.transparent, textColor: AppColors.grey800),
          ],
          isLate: false,
        ));
  });
}
