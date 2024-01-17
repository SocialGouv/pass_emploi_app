import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/date/interval.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

/// For this test, we will use UTC dates to avoid any timezone issue on local machines and CI.
/// In production, local dates are used. We assume intervals don't perfectly match monday to sunday if
/// daylight saving time occurs during interval.

// Today
final mercredi14Fevrier12h00 = DateTime.utc(2024, 2, 14, 12);

// Current period : 2 weeks before and 2 weeks after current week
final currentPeriodInterval = Interval(lundi29Janvier00h00, dimanche3Mars23h59);
final lundi29Janvier00h00 = DateTime.utc(2024, 1, 29);
final dimanche3Mars23h59 = DateTime.utc(2024, 3, 3, 23, 59, 59, 999);

// Previous period : 4 weeks before current period
final previousPeriodInterval = Interval(lundi1Janvier00h00, dimanche28Janvier23h59);
final lundi1Janvier00h00 = DateTime.utc(2024, 1, 1);
final dimanche28Janvier23h59 = DateTime.utc(2024, 1, 28, 23, 59, 59, 999);

// NextPeriod : 4 weeks after current period
final nextPeriodInterval = Interval(lundi4Mars00h00, lundi1Avril00h59);
final lundi4Mars00h00 = DateTime.utc(2024, 3, 4);
final lundi1Avril00h59 = DateTime.utc(2024, 3, 31, 23, 59, 59, 999);

final currentPeriodSuivi = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: mercredi14Fevrier12h00)],
  rendezvous: [mockRendezvous(date: dimanche3Mars23h59)],
);

final previousPeriodSuivi = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: lundi1Janvier00h00)],
  rendezvous: [mockRendezvous(date: dimanche28Janvier23h59)],
);

final nextPeriodSuivi = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: lundi4Mars00h00)],
  sessionsMilo: [mockSessionMilo(dateDeDebut: lundi1Avril00h59)],
);

void main() {
  group('MonSuivi', () {
    final sut = StoreSut();
    final repository = MockMonSuiviRepository();

    group("when requesting current period ([START OF 2 WEEKS BEFORE CURRENT, END OF 2 WEEKS AFTER CURRENT])", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.current));

      test('should load, then request interval, then succeed when request succeeds', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', currentPeriodInterval)).thenAnswer((_) async => currentPeriodSuivi);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForCurrentPeriod()]);
        });
      });

      test('should load then fail when request fails', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', currentPeriodInterval)).thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
        });
      });
    });

    group("when requesting previous period (4 WEEKS BEFORE START OF CURRENT PERIOD)", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.previous));

      test('should request interval, aggregate data, then succeed when request succeeds', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', previousPeriodInterval)).thenAnswer((_) async => previousPeriodSuivi);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(interval: currentPeriodInterval, monSuivi: currentPeriodSuivi)
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([
            _shouldSucceedForCurrentPeriod(),
            _shouldSucceedForPreviousPeriodWithAggregatedData(),
          ]);
        });
      });

      test('should not load neither fail when request fails', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', previousPeriodInterval)).thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(interval: currentPeriodInterval, monSuivi: currentPeriodSuivi)
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceedForCurrentPeriod()]);
        });
      });
    });

    group("when requesting next period (4 WEEKS AFTER END OF CURRENT PERIOD)", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.next));

      test('should request interval, aggregate data, then succeed when request succeeds', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', nextPeriodInterval)).thenAnswer((_) async => nextPeriodSuivi);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(interval: currentPeriodInterval, monSuivi: currentPeriodSuivi)
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([
            _shouldSucceedForCurrentPeriod(),
            _shouldSucceedForNextPeriodWithAggregatedData(),
          ]);
        });
      });

      test('should not load neither fail when request fails', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', nextPeriodInterval)).thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(interval: currentPeriodInterval, monSuivi: currentPeriodSuivi)
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldSucceedForCurrentPeriod()]);
        });
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<MonSuiviLoadingState>((state) => state.monSuiviState);

Matcher _shouldFail() => StateIs<MonSuiviFailureState>((state) => state.monSuiviState);

Matcher _shouldSucceedForCurrentPeriod() {
  return StateIs<MonSuiviSuccessState>(
        (state) => state.monSuiviState,
    (state) => expect(state, MonSuiviSuccessState(currentPeriodInterval, currentPeriodSuivi)),
  );
}

Matcher _shouldSucceedForPreviousPeriodWithAggregatedData() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(
      state,
      MonSuiviSuccessState(
        Interval(lundi1Janvier00h00, dimanche3Mars23h59),
        mockMonSuivi(
          actions: [
            mockUserAction(dateEcheance: lundi1Janvier00h00),
            mockUserAction(dateEcheance: mercredi14Fevrier12h00)
          ],
          rendezvous: [
            mockRendezvous(date: dimanche28Janvier23h59),
            mockRendezvous(date: dimanche3Mars23h59),
          ],
        ),
      ),
    ),
  );
}

Matcher _shouldSucceedForNextPeriodWithAggregatedData() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(
      state,
      MonSuiviSuccessState(
        Interval(lundi29Janvier00h00, lundi1Avril00h59),
        mockMonSuivi(
          actions: [
            mockUserAction(dateEcheance: mercredi14Fevrier12h00),
            mockUserAction(dateEcheance: lundi4Mars00h00)
          ],
          rendezvous: [mockRendezvous(date: dimanche3Mars23h59)],
          sessionsMilo: [mockSessionMilo(dateDeDebut: lundi1Avril00h59)],
        ),
      ),
    ),
  );
}
