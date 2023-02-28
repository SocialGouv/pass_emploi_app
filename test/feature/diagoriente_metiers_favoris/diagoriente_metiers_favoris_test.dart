import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_state.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('DiagorienteMetiersFavoris', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => DiagorienteMetiersFavorisRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.diagorienteMetiersFavorisRepository = DiagorienteMetiersFavorisRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.diagorienteMetiersFavorisRepository = DiagorienteMetiersFavorisRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() =>
    StateIs<DiagorienteMetiersFavorisLoadingState>((state) => state.diagorienteMetiersFavorisState);

Matcher _shouldFail() =>
    StateIs<DiagorienteMetiersFavorisFailureState>((state) => state.diagorienteMetiersFavorisState);

Matcher _shouldSucceed() {
  return StateIs<DiagorienteMetiersFavorisSuccessState>(
    (state) => state.diagorienteMetiersFavorisState,
    (state) {
      expect(state.aDesMetiersFavoris, true);
    },
  );
}

class DiagorienteMetiersFavorisRepositorySuccessStub extends DiagorienteMetiersFavorisRepository {
  DiagorienteMetiersFavorisRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool?> get(String userId) async {
    return true;
  }
}

class DiagorienteMetiersFavorisRepositoryErrorStub extends DiagorienteMetiersFavorisRepository {
  DiagorienteMetiersFavorisRepositoryErrorStub() : super(DioMock());

  @override
  Future<bool?> get(String userId) async {
    return null;
  }
}
