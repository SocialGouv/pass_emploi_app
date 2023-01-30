import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/raclette/raclette_actions.dart';
import 'package:pass_emploi_app/features/raclette/raclette_state.dart';
import 'package:pass_emploi_app/repositories/raclette_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Raclette', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => RacletteRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.racletteRepository = RacletteRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.racletteRepository = RacletteRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<RacletteLoadingState>((state) => state.racletteState);

Matcher _shouldFail() => StateIs<RacletteFailureState>((state) => state.racletteState);

Matcher _shouldSucceed() {
  return StateIs<RacletteSuccessState>(
    (state) => state.racletteState,
    (state) {
      expect(state.result, true);
    },
  );
}

class RacletteRepositorySuccessStub extends RacletteRepository {
  RacletteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool?> get() async {
    return true;
  }
}

class RacletteRepositoryErrorStub extends RacletteRepository {
  RacletteRepositoryErrorStub() : super(DioMock());

  @override
  Future<bool?> get() async {
    return null;
  }
}
