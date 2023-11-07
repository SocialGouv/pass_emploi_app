import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('ThematiqueDemarche', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => RequestAction<NoRequest, List<ThematiqueDeDemarche>>(NoRequest()));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.thematiquesDemarcheRepository = ThematiqueDemarcheRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.thematiquesDemarcheRepository = ThematiqueDemarcheRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<LoadingState<List<ThematiqueDeDemarche>>>((state) => state.thematiquesDemarcheState);

Matcher _shouldFail() => StateIs<FailureState<List<ThematiqueDeDemarche>>>((state) => state.thematiquesDemarcheState);

Matcher _shouldSucceed() {
  return StateIs<SuccessState<List<ThematiqueDeDemarche>>>(
    (state) => state.thematiquesDemarcheState,
    (state) {
      expect(state.data, [dummyThematiqueDeDemarche()]);
    },
  );
}

class ThematiqueDemarcheRepositorySuccessStub extends ThematiqueDemarcheRepository {
  ThematiqueDemarcheRepositorySuccessStub() : super(DioMock());

  @override
  Future<List<ThematiqueDeDemarche>?> getThematique() async {
    return [dummyThematiqueDeDemarche()];
  }
}

class ThematiqueDemarcheRepositoryErrorStub extends ThematiqueDemarcheRepository {
  ThematiqueDemarcheRepositoryErrorStub() : super(DioMock());

  @override
  Future<List<ThematiqueDeDemarche>?> getThematique() async {
    return null;
  }
}
