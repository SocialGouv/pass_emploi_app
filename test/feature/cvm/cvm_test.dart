import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';

import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Cvm', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => CvmRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.cvmRepository = MockCvmRepository()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.cvmRepository = MockCvmRepository()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<CvmLoadingState>((state) => state.cvmState);

Matcher _shouldFail() => StateIs<CvmFailureState>((state) => state.cvmState);

Matcher _shouldSucceed() {
  return StateIs<CvmSuccessState>(
    (state) => state.cvmState,
    (state) {
      expect(state.result, true);
    },
  );
}

class MockCvmRepository extends Mock implements CvmRepository {}
