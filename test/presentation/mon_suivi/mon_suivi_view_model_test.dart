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
        SemaineSectionItem('1 - 7 janvier 2024'),
        EmptyDayItem(Day('lun.', '1')),
        EmptyDayItem(Day('mar.', '2')),
        EmptyDayItem(Day('mer.', '3')),
        EmptyDayItem(Day('jeu.', '4')),
        EmptyDayItem(Day('ven.', '5')),
        EmptyDayItem(Day('sam.', '6')),
        EmptyDayItem(Day('dim.', '7')),
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
        SemaineSectionItem('1 - 7 janvier 2024'),
        DayItem(Day('lun.', '1'), [UserActionEntry('actionId')]),
        EmptyDayItem(Day('mar.', '2')),
        EmptyDayItem(Day('mer.', '3')),
        EmptyDayItem(Day('jeu.', '4')),
        EmptyDayItem(Day('ven.', '5')),
        EmptyDayItem(Day('sam.', '6')),
        DayItem(Day('dim.', '7'), [RendezvousEntry('rendezvousId'), SessionMiloEntry('sessionMiloId')]),
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
          SemaineSectionItem('1 - 7 janvier 2024', 'Cette semaine'),
          EmptyDayItem(Day('lun.', '1')),
          EmptyDayItem(Day('mar.', '2')),
          EmptyDayItem(Day('mer.', '3')),
          EmptyDayItem(Day('jeu.', '4')),
          EmptyDayItem(Day('ven.', '5')),
          EmptyDayItem(Day('sam.', '6')),
          EmptyDayItem(Day('dim.', '7')),
          SemaineSectionItem('8 - 14 janvier 2024', 'Semaine prochaine'),
          EmptyDayItem(Day('lun.', '8')),
          EmptyDayItem(Day('mar.', '9')),
          EmptyDayItem(Day('mer.', '10')),
          EmptyDayItem(Day('jeu.', '11')),
          EmptyDayItem(Day('ven.', '12')),
          EmptyDayItem(Day('sam.', '13')),
          EmptyDayItem(Day('dim.', '14')),
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
    expect((store.dispatchedAction as MonSuiviRequestAction).period, Period.current);
  });
}
