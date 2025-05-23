import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_state.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/mon_suivi/mon_suivi_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

final lundi1Janvier = DateTime.utc(2024, 1, 1);
final dimanche7Janvier = DateTime.utc(2024, 1, 7, 23, 59);
final dimanche14Janvier = DateTime.utc(2024, 1, 14, 23, 59);
final jeudi1Fevrier = DateTime.utc(2024, 2, 1, 23, 59);

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
    group('for Milo users', () {
      test('without data on period', () {
        withClock(Clock.fixed(dimanche14Janvier), () {
          // Given
          final store = givenState() //
              .loggedInMiloUser()
              .monSuivi(interval: Interval(lundi1Janvier, dimanche7Janvier))
              .store();

          // When
          final viewModel = MonSuiviViewModel.create(store);

          // Then
          expect(viewModel.items, [
            SemaineSectionMonSuiviItem('1 - 7 janvier 2024'),
            EmptyDayMonSuiviItem(MonSuiviDay('lun.', '1', "janvier"), 'Aucun événement ni action'),
            EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2', "janvier"), 'Aucun événement ni action'),
            EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3', "janvier"), 'Aucun événement ni action'),
            EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4', "janvier"), 'Aucun événement ni action'),
            EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5', "janvier"), 'Aucun événement ni action'),
            EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6', "janvier"), 'Aucun événement ni action'),
            EmptyDayMonSuiviItem(MonSuiviDay('dim.', '7', "janvier"), 'Aucun événement ni action'),
          ]);
        });
      });

      test('with data on period', () {
        withClock(Clock.fixed(DateTime(2022)), () {
          // Given
          final store = givenState() //
              .loggedInMiloUser()
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
            FilledDayMonSuiviItem(MonSuiviDay('lun.', '1', "janvier"), [
              UserActionMonSuiviEntry('actionId'),
            ]),
            EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6', "janvier"), 'Rien de prévu'),
            FilledDayMonSuiviItem(MonSuiviDay('dim.', '7', "janvier"), [
              RendezvousMonSuiviEntry('rendezvousId'),
              SessionMiloMonSuiviEntry('sessionMiloId'),
            ]),
          ]);
        });
      });

      test('when error on session milo occurred on period should display warning', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .monSuivi(monSuivi: mockMonSuivi(errorOnSessionMiloRetrieval: true))
            .store();

        // When
        final viewModel = MonSuiviViewModel.create(store);

        // Then
        expect(viewModel.withWarningOnWrongSessionMiloRetrieval, isTrue);
      });
    });

    group('for Pôle emploi users', () {
      test('without data on period', () {
        withClock(Clock.fixed(dimanche14Janvier), () {
          // Given
          final store = givenState() //
              .loggedInPoleEmploiUser()
              .monSuivi(interval: Interval(lundi1Janvier, dimanche7Janvier))
              .store();

          // When
          final viewModel = MonSuiviViewModel.create(store);

          // Then
          expect(viewModel.items, [
            SemaineSectionMonSuiviItem('1 - 7 janvier 2024'),
            EmptyDayMonSuiviItem(MonSuiviDay('lun.', '1', "janvier"), 'Aucun rendez-vous ni démarche'),
            EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2', "janvier"), 'Aucun rendez-vous ni démarche'),
            EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3', "janvier"), 'Aucun rendez-vous ni démarche'),
            EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4', "janvier"), 'Aucun rendez-vous ni démarche'),
            EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5', "janvier"), 'Aucun rendez-vous ni démarche'),
            EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6', "janvier"), 'Aucun rendez-vous ni démarche'),
            EmptyDayMonSuiviItem(MonSuiviDay('dim.', '7', "janvier"), 'Aucun rendez-vous ni démarche'),
          ]);
        });
      });

      test('with data on period', () {
        withClock(Clock.fixed(DateTime(2022)), () {
          // Given
          final store = givenState() //
              .loggedInPoleEmploiUser()
              .monSuivi(
                interval: Interval(lundi1Janvier, dimanche7Janvier),
                monSuivi: mockMonSuivi(
                  demarches: [
                    mockDemarche(id: 'demarcheId', endDate: lundi1Janvier),
                    mockDemarche(id: 'demarche without end date > should be filtered'),
                  ],
                  rendezvous: [mockRendezvous(id: 'rendezvousId', date: dimanche7Janvier)],
                ),
              )
              .store();

          // When
          final viewModel = MonSuiviViewModel.create(store);

          // Then
          expect(viewModel.items, [
            SemaineSectionMonSuiviItem('1 - 7 janvier 2024'),
            FilledDayMonSuiviItem(MonSuiviDay('lun.', '1', "janvier"), [
              DemarcheMonSuiviEntry('demarcheId'),
            ]),
            EmptyDayMonSuiviItem(MonSuiviDay('mar.', '2', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('mer.', '3', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('jeu.', '4', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('ven.', '5', "janvier"), 'Rien de prévu'),
            EmptyDayMonSuiviItem(MonSuiviDay('sam.', '6', "janvier"), 'Rien de prévu'),
            FilledDayMonSuiviItem(MonSuiviDay('dim.', '7', "janvier"), [
              RendezvousMonSuiviEntry('rendezvousId'),
            ]),
          ]);
        });
      });

      test('when error on Pôle emploi data occurred on period should display warning', () {
        // Given
        final store = givenState() //
            .loggedInPoleEmploiUser()
            .monSuivi(monSuivi: mockMonSuivi(dateDerniereMiseAJourPoleEmploi: DateTime.now()))
            .store();

        // When
        final viewModel = MonSuiviViewModel.create(store);

        // Then
        expect(viewModel.withWarningOnWrongPoleEmploiDataRetrieval, isTrue);
      });
    });

    test('when period contains current and next week', () {
      withClock(Clock.fixed(dimanche7Janvier), () {
        // Given
        final store = givenState().monSuivi(interval: Interval(lundi1Janvier, jeudi1Fevrier)).store();

        // When
        final viewModel = MonSuiviViewModel.create(store);

        // Then
        const indexOfWeek = 8;
        final items = viewModel.items;
        expect(items[0 * indexOfWeek], SemaineSectionMonSuiviItem('1 - 7 janvier 2024', 'Cette semaine'));
        expect(items[1 * indexOfWeek], SemaineSectionMonSuiviItem('8 - 14 janvier 2024', 'Semaine prochaine'));
        expect(items[2 * indexOfWeek], SemaineSectionMonSuiviItem('15 - 21 janvier 2024'));
        expect(items[3 * indexOfWeek], SemaineSectionMonSuiviItem('22 - 28 janvier 2024'));
        // When period is between 2 months, we explicit them
        expect(items[4 * indexOfWeek], SemaineSectionMonSuiviItem('29 janvier - 4 février 2024'));
      });
    });

    test('when period contains day saving light change should work properly', () {
      final before = DateTime(2023, 10, 20);
      final daySavingLight = DateTime(2023, 10, 27);
      final after = DateTime(2023, 10, 30);
      withClock(Clock.fixed(daySavingLight), () {
        // Given
        final store = givenState()
            .monSuivi(
              interval: Interval(before, after),
              monSuivi: mockMonSuivi(actions: [mockUserAction(id: 'actionId', dateEcheance: after)]),
            )
            .store();

        // When
        final viewModel = MonSuiviViewModel.create(store);

        // Then
        expect(viewModel.items.whereType<FilledDayMonSuiviItem>().firstOrNull, isNotNull);
      });
    });
  });

  test('indexOfTodayItem', () {
    withClock(Clock.fixed(dimanche7Janvier), () {
      // Given
      final store = givenState().monSuivi(interval: Interval(lundi1Janvier, dimanche14Janvier)).store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.indexOfTodayItem, 7);
    });
  });

  group('withCreateButton', () {
    test('when state is success return true', () {
      // Given
      final store = givenState().monSuivi().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.withCreateButton, isTrue);
    });

    test('otherwise return false', () {
      // Given
      final store = givenState().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.withCreateButton, isFalse);
    });
  });

  group('ctaType', () {
    test('for Milo users', () {
      // Given
      final store = givenState().loggedInMiloUser().monSuivi().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.ctaType, MonSuiviCtaType.createAction);
    });

    test('for Pôle emploi users', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().monSuivi().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.ctaType, MonSuiviCtaType.createDemarche);
    });
  });

  test('pendingActionCreations', () {
    // Given
    final store = givenState().copyWith(userActionCreatePendingState: UserActionCreatePendingSuccessState(10)).store();

    // When
    final viewModel = MonSuiviViewModel.create(store);

    // Then
    expect(viewModel.pendingActionCreations, 10);
  });

  // Without the reset action, the data would be concatenated to the previous one. And here we want to reset the data.
  test('onRetry should dispatch both reset and request actions to properly handle session Milo errors case', () {
    // Given
    final store = StoreSpy();
    final viewModel = MonSuiviViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedActions[0] is MonSuiviResetAction, isTrue);
    expect(store.dispatchedActions[1] is MonSuiviRequestAction, isTrue);
    expect((store.dispatchedActions[1] as MonSuiviRequestAction).period, MonSuiviPeriod.current);
  });

  group('withPagination', () {
    test('should return true for Milo users', () {
      // Given
      final store = givenState().loggedInMiloUser().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.withPagination, isTrue);
    });

    test('should return false for Pôle emploi users', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = MonSuiviViewModel.create(store);

      // Then
      expect(viewModel.withPagination, isFalse);
    });
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
