import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('RecherchesRecentes', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => RecherchesRecentesRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.recherchesRecentesRepository = RecherchesRecentesRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.recherchesRecentesRepository = RecherchesRecentesRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<RecherchesRecentesLoadingState>((state) => state.recherchesRecentesState);

Matcher _shouldFail() => StateIs<RecherchesRecentesFailureState>((state) => state.recherchesRecentesState);

Matcher _shouldSucceed() {
  return StateIs<RecherchesRecentesSuccessState>(
    (state) => state.recherchesRecentesState,
    (state) {
      expect(state.recentSearches, [offreEmploiSavedSearch()]);
    },
  );
}

class RecherchesRecentesRepositorySuccessStub extends RecherchesRecentesRepository {
  RecherchesRecentesRepositorySuccessStub() : super(DioMock());

  @override
  Future<List<SavedSearch>?> get() async {
    return [offreEmploiSavedSearch()];
  }
}

class RecherchesRecentesRepositoryErrorStub extends RecherchesRecentesRepository {
  RecherchesRecentesRepositoryErrorStub() : super(DioMock());

  @override
  Future<List<SavedSearch>?> get() async {
    return null;
  }
}
