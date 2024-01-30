import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('UserActionCardViewModel.create when state source is UserActions', () {
    test("and status is done should create view model properly", () {
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
    });

    test("and status is not started should create view model properly with todo pill", () {
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
    });

    test("and status is in progress should create view model properly with todo pill", () {
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
    });

    test("and status is canceled should create view model properly with todo pill", () {
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
    });

    test("and dateEcheance is in future should display it as on time", () {
      // Given
      final action = mockUserAction(id: '1', dateEcheance: DateTime(2042, 1, 2), status: UserActionStatus.NOT_STARTED);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.dateEcheance, "02/01/2042");
      expect(viewModel.isLate, false);
    });

    test("and dateEcheance is today should display it as on time", () {
      final today = DateTime(2022, 1, 2);
      withClock(Clock.fixed(today), () {
        // Given
        final action = mockUserAction(id: '1', dateEcheance: today, status: UserActionStatus.IN_PROGRESS);
        final store = givenState().withAction(action).store();

        // When
        final viewModel = UserActionCardViewModel.create(
          store: store,
          stateSource: UserActionStateSource.noSource,
          actionId: '1',
        );

        // Then
        expect(viewModel.dateEcheance, "02/01/2022");
        expect(viewModel.isLate, false);
      });
    });

    test("and dateEcheance is in past should display it as late", () {
      // Given
      final action = mockUserAction(id: '1', dateEcheance: DateTime(2022, 1, 2), status: UserActionStatus.IN_PROGRESS);
      final store = givenState().withAction(action).store();

      // When
      final viewModel = UserActionCardViewModel.create(
        store: store,
        stateSource: UserActionStateSource.noSource,
        actionId: '1',
      );

      // Then
      expect(viewModel.dateEcheance, "02/01/2022");
      expect(viewModel.isLate, true);
    });

    test("and status is DONE should not display date echeance", () {
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
      expect(viewModel.dateEcheance, isNull);
    });

    test("and status is CANCELED should not display date echeance", () {
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
      expect(viewModel.dateEcheance, isNull);
    });

    test("and status is in progress and dateEcheance is in past should display it as late", () {
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
      expect(viewModel.dateEcheance, "02/01/2022");
      expect(viewModel.pillule, CardPilluleType.late);
    });

    test("and status is not started and dateEcheance is in past should display it as late", () {
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
      expect(viewModel.dateEcheance, "02/01/2022");
      expect(viewModel.pillule, CardPilluleType.late);
    });
  });

  group('UserActionCardViewModel.create when state source is mon suivi', () {
    test("should retrieve action from mon suivi and create view model properly", () {
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
      expect(viewModel.title, 'content');
    });
  });
}
