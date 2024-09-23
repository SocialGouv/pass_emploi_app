import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

void main() {
  test("create should return id, title and category", () {
    // Given
    final demarche = mockDemarche(
      id: 'id',
      content: 'titre',
      label: "Mes entretiens d'embauche",
      endDate: parseDateTimeUtcWithCurrentTimeZone('2050-04-28T16:06:48.396Z'),
    );
    final store = givenState().monSuivi(monSuivi: mockMonSuivi(demarches: [(demarche)])).store();

    // When
    final viewModel = DemarcheCardViewModel.create(store: store, demarcheId: 'id');

    // Then
    expect(viewModel.id, 'id');
    expect(viewModel.title, 'titre');
    expect(viewModel.categoryText, "Mes entretiens d'embauche");
  });

  group('pillule', () {
    test("when end date is in the past should return CardPilluleType.late", () {
      // Given
      final demarche = mockDemarche(
        status: DemarcheStatus.IN_PROGRESS,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      );
      final store = givenState().monSuivi(monSuivi: mockMonSuivi(demarches: [(demarche)])).store();

      // When
      final viewModel = DemarcheCardViewModel.create(store: store, demarcheId: 'id');

      // Then
      expect(viewModel.pillule, CardPilluleType.late);
    });

    test("when status is CANCELLED should return CardPilluleType.canceled", () {
      // Given
      final demarche = mockDemarche(
        status: DemarcheStatus.CANCELLED,
        deletionDate: parseDateTimeUtcWithCurrentTimeZone('2020-03-28T16:06:48.396Z'),
      );
      final store = givenState().monSuivi(monSuivi: mockMonSuivi(demarches: [(demarche)])).store();

      // When
      final viewModel = DemarcheCardViewModel.create(store: store, demarcheId: 'id');

      // Then
      expect(viewModel.pillule, CardPilluleType.canceled);
    });

    test("when status is DONE should return CardPilluleType.done", () {
      // Given
      final demarche = mockDemarche(
        status: DemarcheStatus.DONE,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
      );
      final store = givenState().monSuivi(monSuivi: mockMonSuivi(demarches: [(demarche)])).store();

      // When
      final viewModel = DemarcheCardViewModel.create(store: store, demarcheId: 'id');

      // Then
      expect(viewModel.pillule, CardPilluleType.done);
    });

    test("when status is IN_PROGRESS should return CardPilluleType.doing", () {
      // Given
      final demarche = mockDemarche(
        status: DemarcheStatus.IN_PROGRESS,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2050-03-28T16:06:48.396Z'),
      );
      final store = givenState().monSuivi(monSuivi: mockMonSuivi(demarches: [(demarche)])).store();

      // When
      final viewModel = DemarcheCardViewModel.create(store: store, demarcheId: 'id');

      // Then
      expect(viewModel.pillule, CardPilluleType.doing);
    });

    test("when status is NOT_STARTED should return CardPilluleType.todo", () {
      // Given
      final demarche = mockDemarche(
        status: DemarcheStatus.NOT_STARTED,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2050-04-28T16:06:48.396Z'),
      );
      final store = givenState().monSuivi(monSuivi: mockMonSuivi(demarches: [(demarche)])).store();

      // When
      final viewModel = DemarcheCardViewModel.create(store: store, demarcheId: 'id');

      // Then
      expect(viewModel.pillule, CardPilluleType.todo);
    });
  });
}
