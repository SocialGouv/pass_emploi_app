import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/boulanger_campagne/boulanger_campagne_actions.dart';
import 'package:pass_emploi_app/features/boulanger_campagne/boulanger_campagne_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('BoulangerCampagne', () {
    final sut = StoreSut();
    final repository = MockBoulangerCampagneRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.boulangerCampagneRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed(true));
      });
    });

    group("when hiding", () {
      sut.whenDispatchingAction(() => BoulangerCampagneHideAction());

      test('should hide', () {
        when(() => repository.save()).thenAnswer((_) async => {});

        sut.givenStore = givenState()
            .withBoulangerCampagneState(result: true)
            .store((f) => {f.boulangerCampagneRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed(false));
      });
    });
  });
}

Matcher _shouldSucceed(bool result) {
  return StateIs<BoulangerCampagneState>(
    (state) => state.boulangerCampagneState,
    (state) {
      expect(state.result, result);
    },
  );
}
