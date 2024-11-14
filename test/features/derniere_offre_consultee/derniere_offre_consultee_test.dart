import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_actions.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_state.dart';
import 'package:pass_emploi_app/models/derniere_offre_consultee.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  setUpAll(() => registerFallbackValue(DerniereRechercheOffreEmploi(mockOffreEmploi())));
  group('DerniereOffreConsultee', () {
    final sut = StoreSut();
    final repository = MockDerniereOffreConsulteeRepository();

    group("when bootstraping", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load offres dates', () {
        when(() => repository.get()).thenAnswer((_) async => DerniereRechercheOffreEmploi(mockOffreEmploi()));

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.derniereOffreConsulteeRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });

      group("when writing offre", () {
        sut.whenDispatchingAction(
            () => DerniereOffreConsulteeWriteAction(DerniereRechercheOffreEmploi(mockOffreEmploi())));

        test('should write date', () {
          when(() => repository.set(any())).thenAnswer((_) async {});

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.derniereOffreConsulteeRepository = repository});

          sut.thenExpectAtSomePoint(_shouldSucceed());
        });
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<DerniereOffreConsulteeState>(
    (state) => state.derniereOffreConsulteeState,
    (state) {
      expect(state.offre, DerniereRechercheOffreEmploi(mockOffreEmploi()));
    },
  );
}
