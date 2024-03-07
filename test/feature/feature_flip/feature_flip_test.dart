import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/feature_flip.dart';

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
      group("when user is PE", () {
        group("and CVM generally enabled", () {
          sut.whenDispatchingAction(() => LoginSuccessAction(mockedPoleEmploiUser()));

          test('should set useCvm to true', () {
            when(() => remoteConfigRepository.useCvm()).thenReturn(true);

            sut.givenStore = givenState() //
                .loggedInUser()
                .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

            sut.thenExpectAtSomePoint(_shouldHaveValue(FeatureFlip(useCvm: true)));
          });
        });

        group("and CVM not generally enabled, but user's conseiller is an early adopter", () {
          sut.whenDispatchingAction(() => LoginSuccessAction(mockedPoleEmploiUser()));

          test('should load then succeed when request succeeds', () {
            when(() => remoteConfigRepository.useCvm()).thenReturn(false);
            when(() => remoteConfigRepository.getIdsConseillerCvmEarlyAdopters()).thenReturn(["id-conseiller-ea"]);
            when(() => detailsJeuneRepository.fetch("id")) //
                .thenAnswer((_) async => mockDetailsJeune(idConseiller: "id-conseiller-ea"));

            sut.givenStore = givenState() //
                .loggedInUser()
                .store(
                  (f) => {
                    f.remoteConfigRepository = remoteConfigRepository,
                    f.detailsJeuneRepository = detailsJeuneRepository,
                  },
                );

            sut.thenExpectAtSomePoint(_shouldHaveValue(FeatureFlip(useCvm: true)));
          });
        });

        group("and CVM not generally enabled, and user's conseiller is not an early adopter", () {
          sut.whenDispatchingAction(() => LoginSuccessAction(mockedPoleEmploiUser()));

          test('should load then succeed when request succeeds', () async {
            when(() => remoteConfigRepository.useCvm()).thenReturn(false);
            when(() => remoteConfigRepository.getIdsConseillerCvmEarlyAdopters()).thenReturn(["id-conseiller-ea"]);
            when(() => detailsJeuneRepository.fetch("id")) //
                .thenAnswer((_) async => mockDetailsJeune(idConseiller: "id-conseiller"));

            sut.givenStore = givenState() //
                .loggedInUser()
                .store(
                  (f) => {
                    f.remoteConfigRepository = remoteConfigRepository,
                    f.detailsJeuneRepository = detailsJeuneRepository,
                  },
                );

            sut.thenExpectNever(_shouldHaveValue(FeatureFlip(useCvm: true)));
          });
        });
      });

      group("when user is not PE", () {
        sut.whenDispatchingAction(() => LoginSuccessAction(mockedMiloUser()));

        test('should never use CVM', () {
          when(() => remoteConfigRepository.useCvm()).thenReturn(true);

          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.remoteConfigRepository = remoteConfigRepository});

          sut.thenExpectNever(_shouldHaveValue(FeatureFlip(useCvm: true)));
        });
      });
    });
  });
}

Matcher _shouldHaveValue(FeatureFlip expected) {
  return StateIs<FeatureFlipState>(
    (state) => state.featureFlipState,
    (state) => expect(state.featureFlip, expected),
  );
}
