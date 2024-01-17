import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/mon_suivi/mon_suivi_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

final lundi1Janvier = DateTime(2024, 1, 1);
final dimanche7Janvier = DateTime(2024, 1, 7, 23, 59);
final dimanche14Janvier = DateTime(2024, 1, 14, 23, 59);

void main() {
  group('displayState', () {
    test('when mon suivi state is not initialized', () {
      // Given
      final store = givenState().copyWith(monSuiviState: MonSuiviNotInitializedState()).store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when mon suivi state is loading', () {
      // Given
      final store = givenState().copyWith(monSuiviState: MonSuiviLoadingState()).store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when mon suivi state is failure', () {
      // Given
      final store = givenState().copyWith(monSuiviState: MonSuiviFailureState()).store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when mon suivi state is success', () {
      // Given
      final store = givenState().monSuivi().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });

  group('items', () {
    test('when no data on period', () {
      // Given
      final store = givenState().monSuivi(interval: Interval(lundi1Janvier, dimanche7Janvier)).store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.items, [
        SemaineSectionMonSuiviItem('1 - 7 janvier 2024'),
        EmptyDayMonSuiviItem(MonSuiviDay('lun.', '1')),
        EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2')),
        EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3')),
        EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4')),
        EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5')),
        EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6')),
        EmptyDayMonSuiviItem(MonSuiviDay('dim.', '7')),
      ]);
    });

    test('when data on period', () {
      // Given
      final store = givenState()
          .monSuivi(
            interval: Interval(lundi1Janvier, dimanche7Janvier),
            monSuivi: mockMonSuivi(
              actions: [mockUserAction(id: 'actionId', dateEcheance: lundi1Janvier)],
              rendezvous: [mockRendezvous(id: 'rendezvousId', date: dimanche7Janvier)],
              sessionsMilo: [mockSessionMilo(id: 'sessionMiloId', dateDeDebut: dimanche7Janvier)],
            ),
          )
          .store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.items, [
        SemaineSectionMonSuiviItem('1 - 7 janvier 2024'),
        DayMonSuiviItem(MonSuiviDay('lun.', '1'), [UserActionMonSuiviEntry('actionId')]),
        EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2')),
        EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3')),
        EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4')),
        EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5')),
        EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6')),
        DayMonSuiviItem(MonSuiviDay('dim.', '7'),
            [RendezvousMonSuiviEntry('rendezvousId'), SessionMiloMonSuiviEntry('sessionMiloId')]),
      ]);
    });

    test('when period contains current and next week', () {
      withClock(Clock.fixed(dimanche7Janvier), () {
        // Given
        final store = givenState().monSuivi(interval: Interval(lundi1Janvier, dimanche14Janvier)).store();

        // When
        final viewModel = MonSuiviViewModel.create(store);

        // Then
        expect(viewModel.items, [
          SemaineSectionMonSuiviItem('1 - 7 janvier 2024', 'Cette semaine'),
          EmptyDayMonSuiviItem(MonSuiviDay('lun.', '1')),
          EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2')),
          EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3')),
          EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4')),
          EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5')),
          EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6')),
          EmptyDayMonSuiviItem(MonSuiviDay('dim.', '7')),
          SemaineSectionMonSuiviItem('8 - 14 janvier 2024', 'Semaine prochaine'),
          EmptyDayMonSuiviItem(MonSuiviDay('lun.', '8')),
          EmptyDayMonSuiviItem(MonSuiviDay('mar.', '9')),
          EmptyDayMonSuiviItem(MonSuiviDay('mer.', '10')),
          EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '11')),
          EmptyDayMonSuiviItem(MonSuiviDay('ven.', '12')),
          EmptyDayMonSuiviItem(MonSuiviDay('sam.', '13')),
          EmptyDayMonSuiviItem(MonSuiviDay('dim.', '14')),
        ]);
      });
    });
  });

  test('onRetry', () {
    // Given
    final store = StoreSpy();
    final viewModel = MonSuiviViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction is MonSuiviRequestAction, isTrue);
    expect((store.dispatchedAction as MonSuiviRequestAction).period, MonSuiviPeriod.current);
  });

  test('onLoadPreviousPeriod', () {
    // Given
    final store = StoreSpy();
    final viewModel = MonSuiviViewModel.create(store);

    // When
    viewModel.onLoadPreviousPeriod();

    // Then
    expect(store.dispatchedAction is MonSuiviRequestAction, isTrue);
    expect((store.dispatchedAction as MonSuiviRequestAction).period, MonSuiviPeriod.previous);
  });

  test('onLoadNextPeriod', () {
    // Given
    final store = StoreSpy();
    final viewModel = MonSuiviViewModel.create(store);

    // When
    viewModel.onLoadNextPeriod();

    // Then
    expect(store.dispatchedAction is MonSuiviRequestAction, isTrue);
    expect((store.dispatchedAction as MonSuiviRequestAction).period, MonSuiviPeriod.next);
  });
}
