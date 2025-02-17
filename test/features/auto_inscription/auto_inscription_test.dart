import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_actions.dart';
import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_state.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('AutoInscription', () {
    final sut = StoreSut();
    final repository = MockAutoInscriptionRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => AutoInscriptionRequestAction(eventId: "1"));

      test('should load then succeed when request succeeds', () {
        when(() => repository.set(any(), any())).thenAnswer((_) async => AutoInscriptionSuccess());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.autoInscriptionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails with nombre de places inssufisantes', () {
        when(() => repository.set(any(), any())).thenAnswer((_) async => AutoInscriptionNombrePlacesInsuffisantes());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.autoInscriptionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFailWithPlacesInsuffisantes()]);
      });

      test('should load then fail when request fails with conseiller inactif', () {
        when(() => repository.set(any(), any())).thenAnswer((_) async => AutoInscriptionNombrePlacesInsuffisantes());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.autoInscriptionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFailWithConseillerInactif()]);
      });

      test('should load then fail when request fails with generic error', () {
        when(() => repository.set(any(), any())).thenAnswer((_) async => AutoInscriptionNombrePlacesInsuffisantes());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.autoInscriptionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFailWithGenericError()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<AutoInscriptionLoadingState>((state) => state.autoInscriptionState);

Matcher _shouldFailWithPlacesInsuffisantes() => StateIs<AutoInscriptionFailureState>(
      (state) => state.autoInscriptionState,
      (state) => state.error is AutoInscriptionNombrePlacesInsuffisantes,
    );

Matcher _shouldFailWithConseillerInactif() => StateIs<AutoInscriptionFailureState>(
      (state) => state.autoInscriptionState,
      (state) => state.error is AutoInscriptionConseillerInactif,
    );

Matcher _shouldFailWithGenericError() => StateIs<AutoInscriptionFailureState>(
      (state) => state.autoInscriptionState,
      (state) => state.error is AutoInscriptionGenericError,
    );

Matcher _shouldSucceed() => StateIs<AutoInscriptionSuccessState>((state) => state.autoInscriptionState);
