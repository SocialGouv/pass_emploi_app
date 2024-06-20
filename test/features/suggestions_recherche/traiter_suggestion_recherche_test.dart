import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group('when requesting to accepter une suggestion with location and rayon', () {
    sut.whenDispatchingAction(() => TraiterSuggestionRechercheRequestAction(
          suggestionCaristeFromPoleEmploi(),
          TraiterSuggestionType.accepter,
          location: mockLocation(),
          rayon: 3,
        ));

    test('should load then succeed when request succeed', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedAccepter()]);
    });
  });

  group("when requesting to accepter une suggestion", () {
    sut.whenDispatchingAction(() =>
        TraiterSuggestionRechercheRequestAction(suggestionCaristeFromPoleEmploi(), TraiterSuggestionType.accepter));

    test('should load then succeed when request succeed', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedAccepter()]);
    });

    test('should remove suggestion when request succeed', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .withSuggestionsRecherche()
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_suggestionShouldBeRemoved()]);
    });

    test('should refresh alerte list when request succeed', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .withSuggestionsRecherche()
          .store((f) => {
                f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: true),
                f.getAlerteRepository = AlerteRepositorySuccessStub(),
              });

      sut.thenExpectChangingStatesThroughOrder([_shouldReloadAlerteList()]);
    });

    test('should load then fail when request fail', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .store(
              (f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(accepterSucceed: false)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });

  group("when requesting to refuser une suggestion", () {
    sut.whenDispatchingAction(() =>
        TraiterSuggestionRechercheRequestAction(suggestionCaristeFromPoleEmploi(), TraiterSuggestionType.refuser));

    test('should load then succeed when request succeed', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(refuserSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedRefuser()]);
    });

    test('should remove suggestion when request succeed', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .withSuggestionsRecherche()
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(refuserSucceed: true)});

      sut.thenExpectChangingStatesThroughOrder([_suggestionShouldBeRemoved()]);
    });

    test('should load then fail when request fail', () {
      sut.givenStore = givenState()
          .loggedIn() //
          .store((f) => {f.suggestionsRechercheRepository = SuggestionsRechercheRepositoryStub(refuserSucceed: false)});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });

  group("when reseting traiter une suggestion", () {
    sut.whenDispatchingAction(() => TraiterSuggestionRechercheResetAction());

    test("should reset state", () {
      sut.givenStore = givenState().succeedAccepterSuggestionRecherche().store();

      sut.thenExpectChangingStatesThroughOrder([_shouldResetTraiterState()]);
    });
  });
}

Matcher _shouldLoad() =>
    StateIs<TraiterSuggestionRechercheLoadingState>((state) => state.traiterSuggestionRechercheState);

Matcher _shouldFail() =>
    StateIs<TraiterSuggestionRechercheFailureState>((state) => state.traiterSuggestionRechercheState);

Matcher _shouldSucceedAccepter() {
  return StateIs<AccepterSuggestionRechercheSuccessState>(
    (state) => state.traiterSuggestionRechercheState,
    (state) {
      expect(state.alerte, offreEmploiAlerte());
    },
  );
}

Matcher _shouldSucceedRefuser() {
  return StateIs<RefuserSuggestionRechercheSuccessState>((state) => state.traiterSuggestionRechercheState);
}

Matcher _suggestionShouldBeRemoved() {
  return StateMatch((state) {
    final suggestionState = state.suggestionsRechercheState;
    return suggestionState is SuggestionsRechercheSuccessState &&
        suggestionState.suggestions.firstWhereOrNull((e) => e.id == suggestionCaristeFromPoleEmploi().id) == null;
  });
}

Matcher _shouldReloadAlerteList() => StateIs<AlerteListSuccessState>((state) => state.alerteListState);

Matcher _shouldResetTraiterState() =>
    StateIs<TraiterSuggestionRechercheNotInitializedState>((state) => state.traiterSuggestionRechercheState);

class SuggestionsRechercheRepositoryStub extends SuggestionsRechercheRepository {
  final bool accepterSucceed;
  final bool refuserSucceed;

  SuggestionsRechercheRepositoryStub({this.accepterSucceed = true, this.refuserSucceed = true})
      : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<Alerte?> accepterSuggestion({
    required String userId,
    required String suggestionId,
    Location? location,
    double? rayon,
  }) async {
    return accepterSucceed ? offreEmploiAlerte() : null;
  }

  @override
  Future<bool> refuserSuggestion({required String userId, required String suggestionId}) async {
    return refuserSucceed;
  }
}

class AlerteRepositorySuccessStub extends GetAlerteRepository {
  AlerteRepositorySuccessStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<Alerte>?> getAlerte(String userId) async {
    return [];
  }
}
