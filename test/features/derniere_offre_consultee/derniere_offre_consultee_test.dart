import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_actions.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_state.dart';
import 'package:pass_emploi_app/models/derniere_offre_consultee.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  setUpAll(() => registerFallbackValue(DerniereOffreEmploiConsultee(mockOffreEmploi())));
  group('DerniereOffreConsultee', () {
    final sut = StoreSut();
    final repository = MockDerniereOffreConsulteeRepository();

    group("when bootstraping", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load offres dates', () {
        when(() => repository.get())
            .thenAnswer((_) async => DerniereOffreEmploiConsultee(mockOffreEmploiDetails().toOffreEmploi));

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.derniereOffreConsulteeRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceedOffreEmploi());
      });
    });

    group("when writing offre emploi", () {
      sut.whenDispatchingAction(() => DerniereOffreEmploiConsulteeWriteAction());

      test('should write date', () {
        when(() => repository.set(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .offreEmploiDetailsSuccess(offreEmploiDetails: mockOffreEmploiDetails())
            .store((f) => {f.derniereOffreConsulteeRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceedOffreEmploi());
      });
    });

    group("when writing offre immersion", () {
      sut.whenDispatchingAction(() => DerniereOffreImmersionConsulteeWriteAction());

      test('should write date', () {
        when(() => repository.set(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .withImmersionDetailsSuccess(immersionDetails: mockImmersionDetails())
            .store((f) => {f.derniereOffreConsulteeRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceedOffreImmersion());
      });
    });

    group("when writing offre service civique", () {
      sut.whenDispatchingAction(() => DerniereOffreServiceCiviqueConsulteeWriteAction());

      test('should write date', () {
        when(() => repository.set(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .serviceCiviqueDetailsSuccess(serviceCiviqueDetail: mockServiceCiviqueDetail())
            .store((f) => {f.derniereOffreConsulteeRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceedOffreServiceCivique());
      });
    });
  });
}

Matcher _shouldSucceedOffreEmploi() {
  return StateIs<DerniereOffreConsulteeState>(
    (state) => state.derniereOffreConsulteeState,
    (state) {
      expect(state.offre, DerniereOffreEmploiConsultee(mockOffreEmploiDetails().toOffreEmploi));
    },
  );
}

Matcher _shouldSucceedOffreImmersion() {
  return StateIs<DerniereOffreConsulteeState>(
    (state) => state.derniereOffreConsulteeState,
    (state) {
      expect(state.offre, DerniereOffreImmersionConsultee(mockImmersionDetails().toImmersion));
    },
  );
}

Matcher _shouldSucceedOffreServiceCivique() {
  return StateIs<DerniereOffreConsulteeState>(
    (state) => state.derniereOffreConsulteeState,
    (state) {
      expect(state.offre, DerniereOffreServiceCiviqueConsultee(mockServiceCiviqueDetail().toServiceCivique));
    },
  );
}
