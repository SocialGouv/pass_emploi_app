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
  group('ThematiquesDemarche', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => ThematiquesDemarcheRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.thematiquesDemarcheRepository = ThematiquesDemarcheRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.thematiquesDemarcheRepository = ThematiquesDemarcheRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ThematiquesDemarcheLoadingState>((state) => state.thematiquesDemarcheState);

Matcher _shouldFail() => StateIs<ThematiquesDemarcheFailureState>((state) => state.thematiquesDemarcheState);

Matcher _shouldSucceed() {
  return StateIs<ThematiquesDemarcheSuccessState>(
    (state) => state.thematiquesDemarcheState,
    (state) {
      expect(state.result, [dummyThematiqueDeDemarche()]);
    },
  );
}

class ThematiquesDemarcheRepositorySuccessStub extends ThematiquesDemarcheRepository {
  ThematiquesDemarcheRepositorySuccessStub() : super(DioMock());

  @override
  Future<List<ThematiqueDeDemarche>?> get() async {
    return [dummyThematiqueDeDemarche()];
  }
}

class ThematiquesDemarcheRepositoryErrorStub extends ThematiquesDemarcheRepository {
  ThematiquesDemarcheRepositoryErrorStub() : super(DioMock());

  @override
  Future<List<ThematiqueDeDemarche>?> get() async {
    return null;
  }
}
