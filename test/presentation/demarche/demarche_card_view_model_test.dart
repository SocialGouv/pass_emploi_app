import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';

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
        pilluleType: CardPilluleType.todo,
        date: "À réaliser pour le 28/04/2032",
        isLate: false,
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
    );

    // Then
    expect(viewModel, isNotNull);
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
    );

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(viewModel.date, "À réaliser pour le 28/04/2050");
    expect(viewModel.pilluleType, CardPilluleType.todo);
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
    );

    // Then
    expect(viewModel.status, DemarcheStatus.NOT_STARTED);
    expect(
      viewModel.date,
      "En retard : À réaliser pour le 28/03/2022",
    );
    expect(viewModel.pilluleType, CardPilluleType.late);
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
    );

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(viewModel.date, 'À réaliser pour le 28/03/2050');
    expect(viewModel.pilluleType, CardPilluleType.doing);
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
    );

    // Then
    expect(viewModel.status, DemarcheStatus.IN_PROGRESS);
    expect(
      viewModel.date,
      "En retard : À réaliser pour le 28/03/2022",
    );
    expect(viewModel.pilluleType, CardPilluleType.late);
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
    );

    // Then
    expect(viewModel.status, DemarcheStatus.DONE);
    expect(viewModel.date, "Réalisé le 28/03/2022");
    expect(viewModel.pilluleType, CardPilluleType.done);
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
    );

    // Then
    expect(viewModel.status, DemarcheStatus.CANCELLED);
    expect(viewModel.date, 'Annulé le 28/03/2020');
    expect(viewModel.pilluleType, CardPilluleType.canceled);
  });
}
