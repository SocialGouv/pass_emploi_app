import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Recherche', () {
    final sut = StoreSut();
    final repo = _OffreEmploiRepositoryMock();

    setUpAll(() {
      registerFallbackValue(initialRechercheEmploiRequest());
    });

    group("when requesting a first emploi search", () {
      sut.whenDispatchingAction(() => RechercheRequestAction(initialRechercheEmploiRequest()));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState()
            .loggedIn() //
            .store((f) => {f.offreEmploiRepository = repo});

        repo.givenRepositorySuccess();

        sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithFirstResults()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedIn() //
            .store((f) => {f.offreEmploiRepository = repo});

        repo.givenRepositoryFailure();

        sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldFail()]);
      });
    });

    group("when resetting", () {
      sut.whenDispatchingAction(() => RechercheResetAction<OffreEmploi>());

      test('should have initial state', () {
        sut.givenStore = givenState() //
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        sut.thenExpectChangingStatesThroughOrder([_shouldHaveInitialState()]);
      });
    });

    group("when re-opening criteres", () {
      sut.whenDispatchingAction(() => RechercheOpenCriteresAction<OffreEmploi>());

      test('should have new search status and previous data', () {
        sut.givenStore = givenState() //
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        sut.thenExpectChangingStatesThroughOrder([_shouldHaveNewSearchStateAndPreviousData()]);
      });
    });

    group("when closing criteres", () {
      sut.whenDispatchingAction(() => RechercheCloseCriteresAction<OffreEmploi>());

      test('and previously has result should have success status and previous data', () {
        sut.givenStore = givenState() //
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        sut.thenExpectChangingStatesThroughOrder([_shouldHaveSuccessStateAndPreviousData()]);
      });

      test('and previously has no result should have new search status', () {
        sut.givenStore = givenState() //
            .loggedIn() //
            .failureRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        sut.thenExpectChangingStatesThroughOrder([_shouldHaveNewSearchState()]);
      });
    });

    group("when requesting more", () {
      sut.whenDispatchingAction(() => RechercheLoadMoreAction<OffreEmploi>());

      test('should load then succeed with concatenated data when request succeed', () {
        sut.givenStore = givenState()
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        repo.givenRepositorySuccess();

        sut.thenExpectChangingStatesThroughOrder([_shouldBeUpdateLoading(), _shouldSucceedWithConcatenatedData()]);
      });

      test('should load then fail keeping previous data when request fail', () {
        sut.givenStore = givenState()
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        repo.givenRepositoryFailure();

        sut.thenExpectChangingStatesThroughOrder(
            [_shouldBeUpdateLoading(), _shouldFailLoadingMoreKeepingPreviousData()]);
      });
    });

    group("when updating filtres", () {
      sut.whenDispatchingAction(() => RechercheUpdateFiltresAction(mockEmploiFiltreZeroDistance()));

      test('should load then succeed with new request when request succeed', () {
        sut.givenStore = givenState()
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        repo.givenRepositorySuccess();

        sut.thenExpectChangingStatesThroughOrder([_shouldBeUpdateLoading(), _shouldSucceedUpdatingFiltres()]);
      });

      test('should load then fail with new request and previous data when request fail', () {
        sut.givenStore = givenState()
            .loggedIn() //
            .successRechercheEmploiState() //
            .store((f) => {f.offreEmploiRepository = repo});

        repo.givenRepositoryFailure();

        sut.thenExpectChangingStatesThroughOrder([
          _shouldBeUpdateLoading(),
          _shouldFailLoadingMoreKeepingPreviousData(),
        ]);
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

Matcher _shouldHaveInitialState() {
  return StateMatch((state) => state.rechercheEmploiState == RechercheEmploiState.initial());
}

Matcher _shouldHaveNewSearchState() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.nouvelleRecherche,
    (state) => expect(state.rechercheEmploiState.results, isNull),
  );
}

Matcher _shouldHaveNewSearchStateAndPreviousData() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.nouvelleRecherche,
    (state) {
      expect(state.rechercheEmploiState.request, initialRechercheEmploiRequest());
      expect(state.rechercheEmploiState.results?.length, 10);
      expect(state.rechercheEmploiState.canLoadMore, true);
    },
  );
}

Matcher _shouldHaveSuccessStateAndPreviousData() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.success,
    (state) {
      expect(state.rechercheEmploiState.request, initialRechercheEmploiRequest());
      expect(state.rechercheEmploiState.results?.length, 10);
      expect(state.rechercheEmploiState.canLoadMore, true);
    },
  );
}

Matcher _shouldBeUpdateLoading() {
  return StateMatch((state) => state.rechercheEmploiState.status == RechercheStatus.updateLoading);
}

Matcher _shouldSucceedWithConcatenatedData() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.success,
    (state) {
      expect(state.rechercheEmploiState.request, secondRechercheEmploiRequest());
      expect(state.rechercheEmploiState.results?.length, 20);
      expect(state.rechercheEmploiState.canLoadMore, true);
    },
  );
}

Matcher _shouldFailLoadingMoreKeepingPreviousData() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.failure,
    (state) {
      expect(state.rechercheEmploiState.request, initialRechercheEmploiRequest());
      expect(state.rechercheEmploiState.results?.length, 10);
      expect(state.rechercheEmploiState.canLoadMore, true);
    },
  );
}

Matcher _shouldSucceedUpdatingFiltres() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.success,
    (state) {
      expect(state.rechercheEmploiState.request, rechercheEmploiRequestWithZeroDistanceFiltre());
      expect(state.rechercheEmploiState.results?.length, 10);
      expect(state.rechercheEmploiState.canLoadMore, true);
    },
  );
}

class _OffreEmploiRepositoryMock extends Mock implements OffreEmploiRepository {
  void givenRepositoryFailure() {
    when(() {
      return rechercher(userId: any(named: "userId"), request: any(named: "request"));
    }).thenAnswer((_) async => null);
  }

  void givenRepositorySuccess() {
    when(() {
      return rechercher(userId: any(named: "userId"), request: any(named: "request"));
    }).thenAnswer((_) async => RechercheResponse(results: mockOffresEmploi10(), canLoadMore: true));
  }
}
