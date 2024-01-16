import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

final lundi1JanvierAMinuit = DateTime(2024, 1, 1);
final mardi16Janvier = DateTime(2024, 1, 16);
final dimanche4FevrierA23h59 = DateTime(2024, 2, 4, 23, 59, 59, 999);

final monSuivi = MonSuivi(
  actions: [],
  rendezvous: [],
  sessionsMilo: [],
);

void main() {
  group('MonSuivi', () {
    final sut = StoreSut();
    final repository = MockMonSuiviRepository();

    group("when requesting current period", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(Period.current));

      test(
          'should load, then request interval [START OF 2 PREVIOUS WEEKS, END OF 2 NEXT WEEKS], then succeed when '
          'request succeed', () {
        withClock(Clock.fixed(mardi16Janvier), () {
          when(() => repository.getMonSuivi('id', Interval(lundi1JanvierAMinuit, dimanche4FevrierA23h59)))
              .thenAnswer((_) async => monSuivi);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.monSuiviRepository = repository});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedForCurrentPeriod()]);
        });
      });

      test('should load then fail when request fail', () {
        when(() => repository.getMonSuivi('id', Interval(lundi1JanvierAMinuit, dimanche4FevrierA23h59)))
            .thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.monSuiviRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<MonSuiviLoadingState>((state) => state.monSuiviState);

Matcher _shouldFail() => StateIs<MonSuiviFailureState>((state) => state.monSuiviState);

Matcher _shouldSucceedForCurrentPeriod() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) => expect(state, MonSuiviSuccessState(Interval(lundi1JanvierAMinuit, dimanche4FevrierA23h59), monSuivi)),
  );
}
