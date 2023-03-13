import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('RecherchesDerniersMotsCles', () {
    final sut = StoreSut();

    group("when offres emploi search succeed", () {
      sut.when(() => RechercheSuccessAction(rechercheEmploiChevalierValenceCDI(), <OffreEmploi>[], true));

      test('should save first keyword', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store();

        sut.thenExpectChangingStatesThroughOrder([_shouldHaveOnlyChevalierKeyword()]);
      });

      test('should put on first position a new keyword', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .withRecherchesDerniersMotsCles(["roi"]).store();

        sut.thenExpectChangingStatesThroughOrder([_shouldPutChevalierInFirstPosition()]);
      });

      test('should not save keyword if already saved', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .withRecherchesDerniersMotsCles(["chevalier"]).store();

        sut.thenExpectChangingStatesThroughOrder([_shouldHaveOnlyChevalierKeyword()]);
      });

      test('should put on first position an existing keyword', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .withRecherchesDerniersMotsCles(["roi", "chevalier"]).store();

        sut.thenExpectChangingStatesThroughOrder([_shouldPutChevalierInFirstPosition()]);
      });

      test('should delete oldest keyword if there is more than 3', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .withRecherchesDerniersMotsCles(["roi", "princesse", "prince"]).store();

        sut.thenExpectChangingStatesThroughOrder([_shouldKeepLast3MostRecentsKeyword()]);
      });
    });
  });
}

Matcher _shouldKeepLast3MostRecentsKeyword() {
  return StateMatch((state) =>
      ListEquality().equals(state.recherchesDerniersMotsClesState.motsCles, ["chevalier", "roi", "princesse"]));
}

Matcher _shouldPutChevalierInFirstPosition() {
  return StateMatch(
      (state) => ListEquality().equals(state.recherchesDerniersMotsClesState.motsCles, ["chevalier", "roi"]));
}

Matcher _shouldHaveOnlyChevalierKeyword() {
  return StateMatch(
    (state) => ListEquality().equals(state.recherchesDerniersMotsClesState.motsCles, ["chevalier"]),
  );
}
