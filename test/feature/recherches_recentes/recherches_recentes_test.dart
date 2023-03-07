import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('RecherchesRecentes', () {
    final sut = StoreSut();

    group("when retrieving last search", () {
      sut.when(() => RecherchesRecentesRequestAction());

      test('should load then retreive recent searches when data exist', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.recherchesRecentesRepository = RecherchesRecentesRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldRetreiveRecentSearches()]);
      });

      test('should load then return empty list when data does not exist', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.recherchesRecentesRepository = RecherchesRecentesRepositoryEmptyStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldBeEmpty()]);
      });
    });

    group("when requesting a new search", () {
      sut.when(() => RechercheRequestAction(rechercheEmploiChevalierValenceCDI()));

      test('should add it in recent searches', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store();

        sut.thenExpectChangingStatesThroughOrder([_shouldAddRecentSearch()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<RecherchesRecentesLoadingState>((state) => state.recherchesRecentesState);

Matcher _shouldBeEmpty() {
  return StateIs<RecherchesRecentesSuccessState>(
    (state) => state.recherchesRecentesState,
    (state) {
      expect(state.recentSearches, []);
    },
  );
}

Matcher _shouldRetreiveRecentSearches() {
  return StateIs<RecherchesRecentesSuccessState>(
    (state) => state.recherchesRecentesState,
    (state) {
      expect(state.recentSearches, [offreEmploiSavedSearch()]);
    },
  );
}

Matcher _shouldAddRecentSearch() {
  return StateIs<RecherchesRecentesSuccessState>(
    (state) => state.recherchesRecentesState,
    (state) {
      expect(state.recentSearches, [rechercheEmploiSauvegardeeChevalierValenceCDI()]);
    },
  );
}

class RecherchesRecentesRepositorySuccessStub extends RecherchesRecentesRepository {
  RecherchesRecentesRepositorySuccessStub() : super(DummySharedPreferences());

  @override
  Future<List<SavedSearch>> get() async {
    return [offreEmploiSavedSearch()];
  }
}

class RecherchesRecentesRepositoryEmptyStub extends RecherchesRecentesRepository {
  RecherchesRecentesRepositoryEmptyStub() : super(DummySharedPreferences());

  @override
  Future<List<SavedSearch>> get() async {
    return [];
  }
}
