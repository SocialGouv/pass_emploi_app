import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_middleware.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Recherche', () {
    final sut = StoreSut();
    final repo = _OffreEmploiRepositoryMock();

    void givenRepositoryFailure() {
      when(() => repo.rechercher(userId: any(named: "userId"), request: any(named: "request")))
          .thenAnswer((_) async => null);
    }

    void givenRepositorySuccess() {
      final results = List.generate(10, (index) => mockOffreEmploi());
      const canLoadMore = true;
      when(() => repo.rechercher(userId: any(named: "userId"), request: any(named: "request")))
          .thenAnswer((_) async => RechercheResponse(results: results, canLoadMore: canLoadMore));
    }

    //TODO: laisser en global ?
    setUpAll(() {
      registerFallbackValue(initialRechercheEmploiRequest());
    });

    group("when requesting a first emploi search", () {
      sut.when(() => RechercheRequestAction(initialRechercheEmploiRequest()));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.offreEmploiRepository = repo});

        givenRepositorySuccess();

        sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithFirstResults()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.offreEmploiRepository = repo});

        givenRepositoryFailure();

        sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheEmploiState.status == RechercheStatus.initialLoading);
}

Matcher _shouldFail() {
  return StateMatch((state) => state.rechercheEmploiState.status == RechercheStatus.failure);
}

Matcher _shouldSucceedWithFirstResults() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.success,
    (state) {
      expect(state.rechercheEmploiState.request, initialRechercheEmploiRequest());
      expect(state.rechercheEmploiState.results?.length, 10);
      expect(state.rechercheEmploiState.canLoadMore, true);
    },
  );
}

class _OffreEmploiRepositoryMock extends Mock implements OffreEmploiRepository {}
