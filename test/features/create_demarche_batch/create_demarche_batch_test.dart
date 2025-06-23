import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_actions.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('CreateDemarcheBatch', () {
    final sut = StoreSut();
    final repository = MockCreateDemarcheBatchRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => CreateDemarcheBatchRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.createDemarcheBatchRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.get()).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.createDemarcheBatchRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<CreateDemarcheBatchLoadingState>((state) => state.createDemarcheBatchState);

Matcher _shouldFail() => StateIs<CreateDemarcheBatchFailureState>((state) => state.createDemarcheBatchState);

Matcher _shouldSucceed() {
  return StateIs<CreateDemarcheBatchSuccessState>(
    (state) => state.createDemarcheBatchState,
    (state) {
      expect(state.result, true);
    },
  );
}
