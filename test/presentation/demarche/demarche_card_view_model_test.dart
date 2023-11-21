import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

void main() {
  test("create full test", () {
    // Given
    final demarche = Demarche(
      id: 'id',
      content: "Faire le CV",
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2032-04-28T16:06:48.396Z'),
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
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

    // Then
    expect(
      viewModel,
      DemarcheCardViewModel(
        id: 'id',
        titre: 'Faire le CV',
        sousTitre: 'commentaire',
        status: DemarcheStatus.NOT_STARTED,
        createdByAdvisor: true,
        modifiedByAdvisor: false,
        tag: UserActionTagViewModel(
          title: "À réaliser",
          backgroundColor: AppColors.accent1Lighten,
          textColor: AppColors.accent1,
        ),
        dateFormattedTexts: [FormattedText('À réaliser pour le 28/04/2032')],
        dateColor: AppColors.primary,
      ),
    );
  });

  test("create when source is agenda should create view model properly", () {
    // Given
    final store = givenState().agenda(demarches: [(mockDemarche())]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.agenda,
      demarcheId: 'id',
      simpleCard: false,
    );

    // Then
    expect(viewModel, isNotNull);
  });

  test("create when simple card is set to true should not display subtitle and date", () {
    // Given
    final demarche = mockDemarche(
      attributs: [DemarcheAttribut(key: 'description', value: 'commentaire')],
      endDate: DateTime(2023),
    );
    final store = givenState().agenda(demarches: [(demarche)]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.agenda,
      demarcheId: 'id',
      simpleCard: true,
    );

    // Then
    expect(viewModel.sousTitre, isNull);
    expect(viewModel.dateFormattedTexts, isNull);
  });

  test("create when status is IS_NOT_STARTED and end date is in the future should create view model properly", () {
    // Given
    final demarche = mockDemarche(
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2050-04-28T16:06:48.396Z'),
    );
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(viewModel.dateFormattedTexts, [FormattedText('À réaliser pour le 28/04/2050')]);

    expect(viewModel.dateColor, AppColors.primary);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: "À réaliser",
        backgroundColor: AppColors.accent1Lighten,
        textColor: AppColors.accent1,
      ),
    );
  });

  test("create when status is IS_NOT_STARTED and end date is in the past should create view model properly", () {
    // Given
    final demarche = mockDemarche(
      status: DemarcheStatus.NOT_STARTED,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    );
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

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
          title: "À réaliser",
          backgroundColor: AppColors.warningLighten,
          textColor: AppColors.warning,
        ));
  });

  test("create when status is IN_PROGRESS should create view model properly", () {
    // Given
    final demarche = mockDemarche(
      status: DemarcheStatus.IN_PROGRESS,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2050-03-28T16:06:48.396Z'),
    );
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(viewModel.dateFormattedTexts, [FormattedText('À réaliser pour le 28/03/2050')]);
    expect(viewModel.dateColor, AppColors.primary);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: "En cours",
        backgroundColor: AppColors.accent3Lighten,
        textColor: AppColors.accent3,
      ),
    );
  });

  test("create when status is IN_PROGRESS and end date is in the past should create view model properly", () {
    // Given
    final demarche = mockDemarche(
      status: DemarcheStatus.IN_PROGRESS,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    );
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

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
        title: "En cours",
        backgroundColor: AppColors.warningLighten,
        textColor: AppColors.warning,
      ),
    );
  });

  test("create when status is DONE should create view model properly", () {
    // Given
    final demarche = mockDemarche(
      status: DemarcheStatus.DONE,
      endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    );
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

    // Then
    expect(viewModel.status, DemarcheStatus.DONE);
    expect(viewModel.dateFormattedTexts, [FormattedText('Réalisé le 28/03/2022')]);
    expect(viewModel.dateColor, AppColors.grey700);
    expect(
        viewModel.tag,
        UserActionTagViewModel(
          title: "Terminée",
          backgroundColor: AppColors.accent2Lighten,
          textColor: AppColors.accent2,
        ));
  });

  test("create when status is CANCELLED should create view model properly", () {
    // Given
    final demarche = mockDemarche(
      status: DemarcheStatus.CANCELLED,
      deletionDate: parseDateTimeUtcWithCurrentTimeZone('2020-03-28T16:06:48.396Z'),
    );
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheCardViewModel.create(
      store: store,
      stateSource: DemarcheStateSource.demarcheList,
      demarcheId: 'id',
      simpleCard: false,
    );

    // Then
    expect(viewModel.status, DemarcheStatus.CANCELLED);
    expect(viewModel.dateFormattedTexts, [FormattedText('Annulé le 28/03/2020')]);
    expect(viewModel.dateColor, AppColors.grey700);
    expect(
      viewModel.tag,
      UserActionTagViewModel(
        title: "Annulée",
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      ),
    );
  });
}
