import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/user.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('FeatureFlip', () {
    final sut = StoreSut();
    final remoteConfigRepository = MockRemoteConfigRepository();
    final detailsJeuneRepository = MockDetailsJeuneRepository();

    group("useCvm", () {
      group("when user is PE in CEJ accompagnement", () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedPoleEmploiCejUser()));
        group("and CVM generally enabled", () {
          test('should set useCvm to true', () {
            when(() => remoteConfigRepository.useCvm()).thenReturn(true);

            sut.givenStore = givenState() //
                .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

            sut.thenExpectAtSomePoint(_shouldHaveUseCvmValue(true));
          });
        });

        group("and CVM not generally enabled, but user's conseiller is an early adopter", () {
          test('should load then succeed when request succeeds', () {
            when(() => remoteConfigRepository.useCvm()).thenReturn(false);
            when(() => remoteConfigRepository.getIdsConseillerCvmEarlyAdopters()).thenReturn(["id-conseiller-ea"]);
            when(() => detailsJeuneRepository.get("id")) //
                .thenAnswer((_) async => mockDetailsJeune(idConseiller: "id-conseiller-ea"));

            sut.givenStore = givenState() //
                .store(
                  (f) => {
                    f.remoteConfigRepository = remoteConfigRepository,
                    f.detailsJeuneRepository = detailsJeuneRepository,
                  },
                );

            sut.thenExpectAtSomePoint(_shouldHaveUseCvmValue(true));
          });
        });

        group("and CVM not generally enabled, and user's conseiller is not an early adopter", () {
          test('should load then succeed when request succeeds', () async {
            when(() => remoteConfigRepository.useCvm()).thenReturn(false);
            when(() => remoteConfigRepository.getIdsConseillerCvmEarlyAdopters()).thenReturn(["id-conseiller-ea"]);
            when(() => detailsJeuneRepository.get("id")) //
                .thenAnswer((_) async => mockDetailsJeune(idConseiller: "id-conseiller"));

            sut.givenStore = givenState() //
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

      group("when user is PE not in CEJ accompagnement", () {
        sut.whenDispatchingAction(() => LoginSuccessAction(User(
              id: "id",
              firstName: "F",
              lastName: "L",
              email: "first.last@pole-emploi.fr",
              loginMode: LoginMode.POLE_EMPLOI,
              accompagnement: Accompagnement.rsa,
            )));

        test('should never use CVM', () {
          when(() => remoteConfigRepository.useCvm()).thenReturn(true);

          sut.givenStore = givenState() //
              .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

          sut.thenExpectNever(_shouldHaveUseCvmValue(true));
        });
      });

      group("when user is not PE", () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedMiloUser()));

        test('should never use CVM', () {
          when(() => remoteConfigRepository.useCvm()).thenReturn(true);

          sut.givenStore = givenState() //
              .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

          sut.thenExpectNever(_shouldHaveUseCvmValue(true));
        });
      });
    });

    group('use pj', () {
      group('when user is PE', () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedPoleEmploiCejUser()));
        test('should never use pj', () {
          // Given
          when(() => remoteConfigRepository.usePj()).thenReturn(true);

          // When
          sut.givenStore = givenState() //
              .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

          // Then
          sut.thenExpectNever(_shouldHaveUsePjValue(true));
        });
      });

      group('when user is milo', () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedMiloUser()));
        test('and pj enabled should display pj', () {
          // Given
          when(() => remoteConfigRepository.usePj()).thenReturn(true);

          // When
          sut.givenStore = givenState() //
              .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

          // Then
          sut.thenExpectAtSomePoint(_shouldHaveUsePjValue(true));
        });

        test('and pj not enabled but user is early adopter should display pj', () {
          // Given
          when(() => remoteConfigRepository.usePj()).thenReturn(false);
          when(() => remoteConfigRepository.getIdsMiloPjEarlyAdopters()).thenReturn(["id-mission-locale-ea"]);
          when(() => detailsJeuneRepository.get("id")) //
              .thenAnswer((_) async => mockDetailsJeune(structure: StructureMilo("id-mission-locale-ea", null)));

          // When
          sut.givenStore = givenState() //
              .store(
                (f) => {
                  f.remoteConfigRepository = remoteConfigRepository,
                  f.detailsJeuneRepository = detailsJeuneRepository,
                },
              );

          // Then
          sut.thenExpectAtSomePoint(_shouldHaveUsePjValue(true));
        });

        test('and pj not enabled and user not early adopter should not display pj', () {
          // Given
          when(() => remoteConfigRepository.usePj()).thenReturn(false);
          when(() => remoteConfigRepository.getIdsMiloPjEarlyAdopters()).thenReturn(["id-mission-locale-ea"]);
          when(() => detailsJeuneRepository.get("id")) //
              .thenAnswer((_) async => mockDetailsJeune(structure: StructureMilo("id-mission-locale", null)));

          // When
          sut.givenStore = givenState() //
              .store(
                (f) => {
                  f.remoteConfigRepository = remoteConfigRepository,
                  f.detailsJeuneRepository = detailsJeuneRepository,
                },
              );

          // Then
          sut.thenExpectNever(_shouldHaveUsePjValue(true));
        });
      });
    });

    group("when updating a feature flip value", () {
      sut.whenDispatchingAction(() => FeatureFlipCampagneRecrutementAction(true));

      test('must not modify other values', () {
        when(() => remoteConfigRepository.useCvm()).thenReturn(true);

        sut.givenStore = givenState() //
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

Matcher _shouldHaveUsePjValue(bool usePj) {
  return StateIs<FeatureFlipState>(
    (state) => state.featureFlipState,
    (state) => expect(state.featureFlip.usePj, usePj),
  );
}
