import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
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

// Current period Milo: 2 weeks before and 2 weeks after current week
final currentPeriodIntervalMilo = Interval(lundi29Janvier00h00, dimanche3Mars23h59);
final lundi29Janvier00h00 = DateTime.utc(2024, 1, 29);
final dimanche3Mars23h59 = DateTime.utc(2024, 3, 3, 23, 59, 59, 999);

// Current period Pe: 1 month (remote config) + 2 weeks before - 3 years after
final currentPeriodIntervalPe = Interval(vendredi29Decembre2023, mercredi13Fevrier2027);
final vendredi29Decembre2023 = DateTime.utc(2023, 12, 29);
final mercredi13Fevrier2027 = DateTime.utc(2027, 2, 13, 23, 59, 59, 999);

// Previous period: 4 weeks before current period
final previousPeriodIntervalMilo = Interval(lundi1Janvier00h00, dimanche28Janvier23h59);
final lundi1Janvier00h00 = DateTime.utc(2024, 1, 1);
final dimanche28Janvier23h59 = DateTime.utc(2024, 1, 28, 23, 59, 59, 999);

// NextPeriod: 4 weeks after current period
final nextPeriodIntervalMilo = Interval(lundi4Mars00h00, lundi1Avril00h59);
final lundi4Mars00h00 = DateTime.utc(2024, 3, 4);
final lundi1Avril00h59 = DateTime.utc(2024, 3, 31, 23, 59, 59, 999);

final currentPeriodSuiviMilo = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: mercredi14Fevrier12h00)],
  rendezvous: [mockRendezvous(date: dimanche3Mars23h59)],
);

final previousPeriodSuiviMilo = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: lundi1Janvier00h00)],
  rendezvous: [mockRendezvous(date: dimanche28Janvier23h59)],
);

final nextPeriodSuiviMilo = mockMonSuivi(
  actions: [mockUserAction(dateEcheance: lundi4Mars00h00)],
  sessionsMilo: [mockSessionMilo(dateDeDebut: lundi1Avril00h59)],
);

final suiviPe = mockMonSuivi(
  demarches: [mockDemarche(endDate: lundi29Janvier00h00)],
  rendezvous: [mockRendezvous(date: dimanche3Mars23h59)],
);

void main() {
  group('MonSuivi', () {
    final sut = StoreSut();
    final monSuiviRepository = MockMonSuiviRepository();
    final remoteConfigRepository = MockRemoteConfigRepository();

    group('for Milo users', () {
      group("when requesting current period ([START OF 2 WEEKS BEFORE CURRENT, END OF 2 WEEKS AFTER CURRENT])", () {
        sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.current));

        test('should load, then request interval, then succeed when request succeeds', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', currentPeriodIntervalMilo))
                .thenAnswer((_) async => currentPeriodSuiviMilo);

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForMiloOnCurrentPeriod()]);
          });
        });

        test('should load then fail when request fails', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', currentPeriodIntervalMilo))
                .thenAnswer((_) async => null);

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
          });
        });
      });

      group("when requesting previous period (4 WEEKS BEFORE START OF CURRENT PERIOD)", () {
        sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.previous));

        test('should request interval, aggregate data, then succeed when request succeeds', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', previousPeriodIntervalMilo))
                .thenAnswer((_) async => previousPeriodSuiviMilo);

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .monSuivi(interval: currentPeriodIntervalMilo, monSuivi: currentPeriodSuiviMilo)
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([
              _shouldSucceedForMiloOnCurrentPeriod(),
              _shouldSucceedForMiloOnPreviousPeriodWithAggregatedData(),
            ]);
          });
        });

        test('should not load neither fail when request fails', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', previousPeriodIntervalMilo))
                .thenAnswer((_) async => null);

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .monSuivi(interval: currentPeriodIntervalMilo, monSuivi: currentPeriodSuiviMilo)
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([_shouldSucceedForMiloOnCurrentPeriod()]);
          });
        });
      });

      group("when requesting next period (4 WEEKS AFTER END OF CURRENT PERIOD)", () {
        sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.next));

        test('should request interval, aggregate data, then succeed when request succeeds', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', nextPeriodIntervalMilo))
                .thenAnswer((_) async => nextPeriodSuiviMilo);

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .monSuivi(interval: currentPeriodIntervalMilo, monSuivi: currentPeriodSuiviMilo)
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([
              _shouldSucceedForMiloOnCurrentPeriod(),
              _shouldSucceedForMiloOnNextPeriodWithAggregatedData(),
            ]);
          });
        });

        test('should not load neither fail when request fails', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', nextPeriodIntervalMilo)).thenAnswer((_) async => null);

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .monSuivi(interval: currentPeriodIntervalMilo, monSuivi: currentPeriodSuiviMilo)
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([_shouldSucceedForMiloOnCurrentPeriod()]);
          });
        });
      });

      group("when current period has error on sessions milo, but other period has not", () {
        sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.next));

        test('should keep information on session milo error', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviMilo('id', nextPeriodIntervalMilo)).thenAnswer(
              (_) async => nextPeriodSuiviMilo.copyWith(errorOnSessionMiloRetrieval: false),
            );

            sut.givenStore = givenState() //
                .loggedInMiloUser()
                .monSuivi(
                  interval: currentPeriodIntervalMilo,
                  monSuivi: currentPeriodSuiviMilo.copyWith(errorOnSessionMiloRetrieval: true),
                )
                .store((f) => {f.monSuiviRepository = monSuiviRepository});

            sut.thenExpectChangingStatesThroughOrder([
              _shouldSucceedForMiloOnCurrentPeriod(errorOnSessionMilo: true),
              _shouldSucceedForMiloOnNextPeriodWithAggregatedData(errorOnSessionMilo: true),
            ]);
          });
        });
      });
    });

    group('for Pôle emploi users', () {
      group("when requesting current period", () {
        sut.whenDispatchingAction(() => MonSuiviRequestAction(MonSuiviPeriod.current));
        when(() => remoteConfigRepository.monSuiviPoleEmploiStartDateInMonths()).thenReturn(1);

        test('should load, then request interval determined from remote config, then succeed when request succeeds',
            () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviPe('id', vendredi29Decembre2023)).thenAnswer((_) async => suiviPe);

            sut.givenStore = givenState() //
                .loggedInPoleEmploiUser()
                .store(
                  (f) => {
                    f.monSuiviRepository = monSuiviRepository,
                    f.remoteConfigRepository = remoteConfigRepository,
                  },
                );

            sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForPeOnPeriod()]);
          });
        });

        test('should load then fail when request fails', () {
          withClock(Clock.fixed(mercredi14Fevrier12h00), () {
            when(() => monSuiviRepository.getMonSuiviPe('id', vendredi29Decembre2023)).thenAnswer((_) async => null);

            sut.givenStore = givenState() //
                .loggedInPoleEmploiUser()
                .store(
                  (f) => {
                    f.monSuiviRepository = monSuiviRepository,
                    f.remoteConfigRepository = remoteConfigRepository,
                  },
                );

            sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
          });
        });
      });
    });

    group("when user action is successfully created and mon suivi state is success", () {
      sut.whenDispatchingAction(() => UserActionCreateSuccessAction('id'));

      test('should re-fetch mon suivi', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          when(() => monSuiviRepository.getMonSuiviMilo('id', currentPeriodIntervalMilo))
              .thenAnswer((_) async => currentPeriodSuiviMilo);

          sut.givenStore = givenState() //
              .loggedInUser()
              .monSuivi(interval: currentPeriodIntervalMilo, monSuivi: currentPeriodSuiviMilo)
              .store((f) => {f.monSuiviRepository = monSuiviRepository});

          sut.thenExpectChangingStatesThroughOrder([
            _shouldSucceedForMiloOnCurrentPeriod(),
            _shouldReset(),
            _shouldLoad(),
            _shouldSucceedForMiloOnCurrentPeriod(),
          ]);
        });
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<MonSuiviLoadingState>((state) => state.monSuiviState);

Matcher _shouldFail() => StateIs<MonSuiviFailureState>((state) => state.monSuiviState);

Matcher _shouldReset() => StateIs<MonSuiviNotInitializedState>((state) => state.monSuiviState);

Matcher _shouldSucceedForMiloOnCurrentPeriod({bool errorOnSessionMilo = false}) {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(
      state,
      MonSuiviSuccessState(
        currentPeriodIntervalMilo,
        currentPeriodSuiviMilo.copyWith(errorOnSessionMiloRetrieval: errorOnSessionMilo),
      ),
    ),
  );
}

Matcher _shouldSucceedForPeOnPeriod() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(state, MonSuiviSuccessState(currentPeriodIntervalPe, suiviPe)),
  );
}

Matcher _shouldSucceedForMiloOnPreviousPeriodWithAggregatedData() {
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

Matcher _shouldSucceedForMiloOnNextPeriodWithAggregatedData({bool errorOnSessionMilo = false}) {
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
          errorOnSessionMiloRetrieval: errorOnSessionMilo,
        ),
      ),
    ),
  );
}
