import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
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
      sut.whenDispatchingAction(() => ThematiqueDemarcheRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.thematiquesDemarcheRepository = ThematiqueDemarcheRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.thematiquesDemarcheRepository = ThematiqueDemarcheRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ThematiqueDemarcheLoadingState>((state) => state.thematiquesDemarcheState);

Matcher _shouldFail() => StateIs<ThematiqueDemarcheFailureState>((state) => state.thematiquesDemarcheState);

Matcher _shouldSucceed() {
  return StateIs<ThematiqueDemarcheSuccessState>(
    (state) => state.thematiquesDemarcheState,
    (state) {
      expect(state.thematiques, [dummyThematiqueDeDemarche()]);
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
