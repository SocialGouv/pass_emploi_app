import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create should work properly when state source is mon suivi", () {
    // Given
    final action = mockUserAction(id: '1', content: 'content');
    final store = givenState().monSuivi(monSuivi: mockMonSuivi(actions: [action])).store();

    // When
    final viewModel = UserActionCardViewModel.create(
      store: store,
      stateSource: UserActionStateSource.monSuivi,
      actionId: '1',
    );

    // Then
    expect(viewModel, isNotNull);
  });

  test("create should work properly when state source is no source", () {
    // Given
    final action = mockUserAction(id: '1', content: 'content');
    final store = givenState().withAction(action).store();

    // When
    final viewModel = UserActionCardViewModel.create(
      store: store,
      stateSource: UserActionStateSource.noSource,
      actionId: '1',
    );

    // Then
    expect(viewModel, isNotNull);
  });

  group('category  and semantic label', () {
    test("when type is not set should return default label and icon", () {
      // Given
      final action = mockUserAction(
        id: '1',
        content: 'Faire un CV',
        type: null,
        status: UserActionStatus.DONE,
      );
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.categoryText, 'Action');
      expect(viewModel.categoryIcon, AppIcons.work_outline_rounded);
    });

    test("when type is set should return proper label and icon", () {
      // Given
      final action = mockUserAction(
        id: '1',
        content: 'Faire un CV',
        type: UserActionReferentielType.cultureSportLoisirs,
        status: UserActionStatus.IN_PROGRESS,
      );
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.categoryText, 'Sport et loisirs');
      expect(viewModel.categoryIcon, AppIcons.sports_football_outlined);
    });
  });

  group('pillule', () {
    test("when status is done should return CardPilluleType.done", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.DONE);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.pillule, CardPilluleType.done);
      expect(viewModel.isLate, isFalse);
    });

    test("when status is not started should return CardPilluleType.todo", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.NOT_STARTED);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.pillule, CardPilluleType.todo);
      expect(viewModel.isLate, isFalse);
    });

    test("when status is in progress should return CardPilluleType.todo", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.IN_PROGRESS);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.pillule, CardPilluleType.todo);
      expect(viewModel.isLate, isFalse);
    });

    test("when status is canceled should return CardPilluleType.todo", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.CANCELED);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.pillule, CardPilluleType.todo);
      expect(viewModel.isLate, isFalse);
    });

    test("when status is in progress and dateEcheance is in past should return CardPilluleType.late", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.IN_PROGRESS, dateEcheance: DateTime(2022, 1, 2));
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.pillule, CardPilluleType.late);
      expect(viewModel.isLate, isTrue);
    });

    test("when status is not started and dateEcheance is in past should return CardPilluleType.late", () {
      // Given
      final action = mockUserAction(id: '1', status: UserActionStatus.NOT_STARTED, dateEcheance: DateTime(2022, 1, 2));
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.pillule, CardPilluleType.late);
      expect(viewModel.isLate, isTrue);
    });
  });
}
