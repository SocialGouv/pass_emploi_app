import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('FeatureFlip', () {
    final sut = StoreSut();
    final remoteConfigRepository = MockRemoteConfigRepository();
    final backendConfigRepository = MockBackendConfigRepository();
    final detailsJeuneRepository = MockDetailsJeuneRepository();

    group("useCvm", () {
      group("when user is PE", () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedPoleEmploiCejUser()));
        group("and CVM generally enabled for accompagnement", () {
          test('should set useCvm to true', () {
            when(() => remoteConfigRepository.cvmActivationByAccompagnement()).thenReturn(
              {
                Accompagnement.cej: true,
                Accompagnement.aij: false,
              },
            );

            sut.givenStore = givenState() //
                .loggedInUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej)
                .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

            sut.thenExpectAtSomePoint(_shouldHaveUseCvmValue(true));
          });
        });

        group("and CVM not generally enabled, but user's conseiller is an early adopter", () {
          test('should load then succeed when request succeeds', () {
            when(() => remoteConfigRepository.cvmActivationByAccompagnement()).thenReturn({});
            when(() => backendConfigRepository.getIdsConseillerCvmEarlyAdopters())
                .thenAnswer((_) async => (["id-conseiller-ea"]));
            when(() => detailsJeuneRepository.get("id")) //
                .thenAnswer((_) async => mockDetailsJeune(idConseiller: "id-conseiller-ea"));

            sut.givenStore = givenState() //
                .loggedInUser(loginMode: LoginMode.POLE_EMPLOI)
                .store(
                  (f) => {
                    f.remoteConfigRepository = remoteConfigRepository,
                    f.backendConfigRepository = backendConfigRepository,
                    f.detailsJeuneRepository = detailsJeuneRepository,
                  },
                );

            sut.thenExpectAtSomePoint(_shouldHaveUseCvmValue(true));
          });
        });

        group("and CVM not generally enabled, and user's conseiller is not an early adopter", () {
          test('should load then succeed when request succeeds', () async {
            when(() => remoteConfigRepository.cvmActivationByAccompagnement()).thenReturn({});
            when(() => backendConfigRepository.getIdsConseillerCvmEarlyAdopters())
                .thenAnswer((_) async => (["id-conseiller-ea"]));
            when(() => detailsJeuneRepository.get("id")) //
                .thenAnswer((_) async => mockDetailsJeune(idConseiller: "id-conseiller"));

            sut.givenStore = givenState() //
                .loggedInUser(loginMode: LoginMode.POLE_EMPLOI)
                .store(
                  (f) => {
                    f.remoteConfigRepository = remoteConfigRepository,
                    f.detailsJeuneRepository = detailsJeuneRepository,
                  },
                );

            sut.thenExpectNever(_shouldHaveUseCvmValue(true));
          });
        });
      });

      group("when user is not PE", () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedMiloUser()));

        test('should never use CVM', () {
          when(() => remoteConfigRepository.cvmActivationByAccompagnement()).thenReturn({
            Accompagnement.cej: true,
            Accompagnement.aij: false,
          });

          sut.givenStore = givenState() //
              .loggedInUser(loginMode: LoginMode.MILO, accompagnement: Accompagnement.cej)
              .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

          sut.thenExpectNever(_shouldHaveUseCvmValue(true));
        });
      });
    });

    group("when updating a feature flip value", () {
      sut.whenDispatchingAction(() => FeatureFlipCampagneRecrutementAction(true));

      test('must not modify other values', () {
        when(() => remoteConfigRepository.cvmActivationByAccompagnement()).thenReturn({Accompagnement.cej: true});

        sut.givenStore = givenState() //
            .loggedInUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej)
            .withFeatureFlip(useCvm: true)
            .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

        sut.thenExpectAtSomePoint(_shouldHaveUseCvmValue(true));
      });
    });
  });
}

Matcher _shouldHaveUseCvmValue(bool useCvm) {
  return StateIs<FeatureFlipState>(
    (state) => state.featureFlipState,
    (state) => expect(state.featureFlip.useCvm, useCvm),
  );
}
