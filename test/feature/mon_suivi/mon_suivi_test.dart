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

// Today
final mercredi14Fevrier12h00 = DateTime(2024, 2, 14, 12);

// Current period : 2 weeks before and 2 weeks after current week
final lundi29Janvier00h00 = DateTime(2024, 1, 29);
final dimanche3Mars23h59 = DateTime(2024, 3, 3, 23, 59, 59, 999);

// Previous period : 4 weeks before current period
final lundi1Janvier00h00 = DateTime(2024, 1, 1);
final dimanche28Janvier23h59 = DateTime(2024, 1, 28, 23, 59, 59, 999);

// NextPeriod : 4 weeks after current period
final lundi4Mars00h00 = DateTime(2024, 3, 4);
final dimanche31Mars23h59 = DateTime(2024, 3, 31, 23, 59, 59, 999);

final monSuiviCurrentPeriod = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: mercredi14Fevrier12h00)],
  rendezvous: [mockRendezvous(date: dimanche3Mars23h59)],
);

final monSuiviPreviousPeriod = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: lundi1Janvier00h00)],
  rendezvous: [mockRendezvous(date: dimanche28Janvier23h59)],
);

void main() {
  group('MonSuivi', () {
    final sut = StoreSut();
    final repository = MockMonSuiviRepository();

    group("when requesting current period > [START OF 2 WEEKS BEFORE CURRENT, END OF 2 WEEKS AFTER CURRENT]", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(Period.current));

      test('should load, then request interval, then succeed when request succeed', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', Interval(lundi29Janvier00h00, dimanche3Mars23h59)))
              .thenAnswer((_) async => monSuiviCurrentPeriod);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForCurrentPeriod()]);
        });
      });

      test('should load then fail when request fails', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', Interval(lundi29Janvier00h00, dimanche3Mars23h59)))
              .thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
        });
      });
    });

    group("when requesting previous period > 4 WEEKS BEFORE START OF CURRENT PERIOD", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(Period.previous));

      test('should request interval, aggregate data, then succeed when request succeed', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', Interval(lundi1Janvier00h00, dimanche28Janvier23h59)))
              .thenAnswer((_) async => monSuiviPreviousPeriod);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(Interval(lundi29Janvier00h00, dimanche3Mars23h59), monSuiviCurrentPeriod)
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([
            _shouldSucceedForCurrentPeriod(),
            _shouldSucceedForPreviousPeriodWithAggregatedData(),
          ]);
        });
      });

      test('should not load neither fail when request fails', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => repository.getMonSuivi('id', Interval(lundi1Janvier00h00, dimanche28Janvier23h59)))
              .thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(Interval(lundi29Janvier00h00, dimanche3Mars23h59), monSuiviCurrentPeriod)
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
    (state) => expect(
      state,
      MonSuiviSuccessState(Interval(lundi29Janvier00h00, dimanche3Mars23h59), monSuiviCurrentPeriod),
    ),
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
