import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

final monSuivi = MonSuivi(
  actions: [],
  rendezvous: [],
  sessionsMilo: [],
);

void main() {
  final debut = DateTime(2024, 1, 1);
  final fin = DateTime(2024, 2, 1);

  group('MonSuivi', () {
    final sut = StoreSut();
    final repository = MockMonSuiviRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => MonSuiviRequestAction(debut: debut, fin: fin));

      test('should load then succeed when request succeed', () {
        when(() => repository.getMonSuivi(userId: 'id', debut: debut, fin: fin)).thenAnswer((_) async => monSuivi);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.monSuiviRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.getMonSuivi(userId: 'id', debut: debut, fin: fin)).thenAnswer((_) async => null);

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

Matcher _shouldSucceed() {
  return StateIs<MonSuiviSuccessState>(
    (state) => state.monSuiviState,
    (state) {
      expect(state.monSuivi, monSuivi);
    },
  );
}
