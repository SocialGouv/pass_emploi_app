import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_detail_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

void main() {
  group("DemarcheDetailViewModel.create when demarche is ...", () {
    test("on time", () {
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
      final store = givenState().copyWith(demarcheListState: DemarcheListSuccessState([demarche])).store();

      // When
      final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "8802034");

      // Then
      expect(viewModel.createdByAdvisor, isTrue);
      expect(viewModel.modifiedByAdvisor, isFalse);
      expect(
        viewModel.dateFormattedTexts,
        [
          FormattedText("À réaliser pour le "),
          FormattedText("28/04/2023", bold: true),
        ],
      );
      expect(viewModel.dateBackgroundColor, AppColors.accent3Lighten);
      expect(viewModel.dateTextColor, AppColors.accent2);
      expect(viewModel.dateIcons, [Drawables.icClock]);
      expect(viewModel.label, "label");
      expect(viewModel.titreDetail, "titre");
      expect(viewModel.sousTitre, "sous titre");
      expect(viewModel.creationDate, "23/12/2022");
      expect(viewModel.modificationDate, "23/12/2022");
      expect(
        viewModel.statutsPossibles,
        [
          UserActionTagViewModel(
            title: Strings.demarcheToDo,
            backgroundColor: AppColors.accent1Lighten,
            textColor: AppColors.accent1,
            isSelected: true,
          ),
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
      );
    });

    test("late", () {
      // Given
      final demarche = mockDemarche(
        id: '8802034',
        endDate: parseDateTimeUtcWithCurrentTimeZone('2021-04-28T16:06:48.396Z'),
      );
      final store = givenState().copyWith(demarcheListState: DemarcheListSuccessState([demarche])).store();

      // When
      final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "8802034");

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
  });

  test('DemarcheDetailViewModel.create when demarche is from agenda should create view model properly', () {
    // Given
    final store = givenState().agenda(demarches: [(mockDemarche())]).store();

    // When
    final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.agenda, 'id');

    // Then
    expect(viewModel, isNotNull);
  });

  group("update display state ...", () {
    test("is empty when UpdateDemarcheState is not initialized", () {
      // Given
      final store = givenState().updateDemarcheNotInit().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "demarcheId");

      // Then
      expect(viewModel.updateDisplayState, DisplayState.EMPTY);
    });

    test("is loading when UpdateDemarcheState is loading", () {
      // Given
      final store = givenState().updateDemarcheLoading().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "demarcheId");

      // Then
      expect(viewModel.updateDisplayState, DisplayState.LOADING);
    });

    test("is empty when UpdateDemarcheState succeeds", () {
      // Given
      final store = givenState().updateDemarcheSuccess().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "demarcheId");

      // Then
      expect(viewModel.updateDisplayState, DisplayState.EMPTY);
    });

    test("is failure when UpdateDemarcheState failed", () {
      // Given
      final store = givenState().updateDemarcheFailure().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "demarcheId");

      // Then
      expect(viewModel.updateDisplayState, DisplayState.FAILURE);
    });
  });

  test('onModifyStatus should dispatch UpdateDemarcheRequestAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withDemarches(mockDemarches()));

    final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "demarcheId");

    // When
    viewModel.onModifyStatus(UserActionTagViewModel(
      title: Strings.demarcheDone,
      backgroundColor: Colors.transparent,
      textColor: AppColors.grey800,
    ));

    // Then
    expect(store.dispatchedAction, isA<UpdateDemarcheRequestAction>());
    expect((store.dispatchedAction as UpdateDemarcheRequestAction).id, "demarcheId");
    expect((store.dispatchedAction as UpdateDemarcheRequestAction).status, DemarcheStatus.DONE);
  });

  test('resetUpdateStatus should dispatch UpdateDemarcheResetAction', () {
    // Given
    final store = StoreSpy.withState(givenState().withDemarches(mockDemarches()));

    final viewModel = DemarcheDetailViewModel.create(store, DemarcheStateSource.list, "demarcheId");

    // When
    viewModel.resetUpdateStatus();

    // Then
    expect(store.dispatchedAction, isA<UpdateDemarcheResetAction>());
    expect(viewModel.updateDisplayState, DisplayState.EMPTY);
  });
}
