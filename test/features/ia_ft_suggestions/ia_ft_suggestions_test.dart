import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_actions.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_state.dart';

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
        when(() => repository.get()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.iaFtSuggestionsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.get()).thenAnswer((_) async => null);

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
      expect(state.result, true);
    },
  );
}
