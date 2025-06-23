import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_actions.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_state.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('IaFtSuggestions', () {
    final sut = StoreSut();
    final repository = MockIaFtSuggestionsRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => IaFtSuggestionsRequestAction());

      test('should load then succeed when request succeeds', () {
        repository.withGetAndReturnSuccess();

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.iaFtSuggestionsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        repository.withGetAndReturnFailure();

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.iaFtSuggestionsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<IaFtSuggestionsLoadingState>((state) => state.iaFtSuggestionsState);

Matcher _shouldFail() => StateIs<IaFtSuggestionsFailureState>((state) => state.iaFtSuggestionsState);

Matcher _shouldSucceed() {
  return StateIs<IaFtSuggestionsSuccessState>(
    (state) => state.iaFtSuggestionsState,
    (state) {
      expect(
          state.suggestions,
          isA<List<DemarcheIaSuggestion>>()
              .having((list) => list.length, "length", 1)
              .having((list) => list.first, "type", isA<DemarcheIaSuggestion>()));
    },
  );
}
