import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(mockOffreSuivie());
  });
  group('OffresSuivies', () {
    final sut = StoreSut();
    final repository = MockOffresSuiviesRepository();

    group("when bootstraping", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load offres suivies', () {
        when(() => repository.get()).thenAnswer((_) async => [
              mockOffreSuivie(),
            ]);

        sut.givenStore = givenState() //
            .store((f) => {f.offresSuiviesRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });

    group('when writing offre suivie', () {
      sut.whenDispatchingAction(() => OffresSuiviesWriteAction(mockOffreSuivie().offreDto));

      test('should write offre', () {
        when(() => repository.set(any())).thenAnswer((_) async => [mockOffreSuivie()]);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.offresSuiviesRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });

    group('when deleting offre suivie', () {
      sut.whenDispatchingAction(() => OffresSuiviesDeleteAction(mockOffreSuivie()));

      test('should write offre', () {
        when(() => repository.delete(any())).thenAnswer((_) async => [mockOffreSuivie()]);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.offresSuiviesRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<OffresSuiviesState>(
    (state) => state.offresSuiviesState,
    (state) {
      expect(state.offresSuivies, [mockOffreSuivie()]);
    },
  );
}
