import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('RecherchesRecentes', () {
    final sut = StoreSut();

    group("when retrieving last search", () {
      sut.whenDispatchingAction(() => LoginSuccessAction(mockUser()));

      test('should return recent searches when data exist', () {
        sut.givenStore = givenState() //
            .store((f) => {f.recherchesRecentesRepository = RecherchesRecentesRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldRetreiveRecentSearches()]);
      });

      test('should return empty list when data does not exist', () {
        sut.givenStore = givenState() //
            .store((f) => {f.recherchesRecentesRepository = RecherchesRecentesRepositoryEmptyStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldBeEmpty()]);
      });
    });

    group("when a search succeed", () {
      sut.whenDispatchingAction(
          () => RechercheSuccessAction(rechercheEmploiChevalierValenceCDI(), <OffreEmploi>[], true));

      test('should add it in recent searches', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store();

        sut.thenExpectChangingStatesThroughOrder([_shouldAddRecentSearch()]);
      });
    });
  });
}

Matcher _shouldBeEmpty() {
  return StateMatch(
    (state) => state.recherchesRecentesState.recentSearches.isEmpty,
  );
}

Matcher _shouldRetreiveRecentSearches() {
  return StateMatch(
    (state) => state.recherchesRecentesState.recentSearches.isNotEmpty,
    (state) {
      expect(state.recherchesRecentesState.recentSearches, [offreEmploiAlerte()]);
    },
  );
}

Matcher _shouldAddRecentSearch() {
  return StateMatch(
    (state) => state.recherchesRecentesState.recentSearches.isNotEmpty,
    (state) {
      expect(state.recherchesRecentesState.recentSearches, [rechercheEmploiSauvegardeeChevalierValenceCDI()]);
    },
  );
}

class RecherchesRecentesRepositorySuccessStub extends RecherchesRecentesRepository {
  RecherchesRecentesRepositorySuccessStub() : super(MockFlutterSecureStorage());

  @override
  Future<List<Alerte>> get() async {
    return [offreEmploiAlerte()];
  }
}

class RecherchesRecentesRepositoryEmptyStub extends RecherchesRecentesRepository {
  RecherchesRecentesRepositoryEmptyStub() : super(MockFlutterSecureStorage());

  @override
  Future<List<Alerte>> get() async {
    return [];
  }
}
