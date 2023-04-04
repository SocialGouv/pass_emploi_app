import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Accueil', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => AccueilRequestAction());

      test('should load then succeed when request succeed for milo', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedMilo()]);
      });

      test('should load then fail when request fail for milo', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.accueilRepository = AccueilRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then succeed when request succeed for PoleEmploi', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedPoleEmploi()]);
      });

      test('should load then fail when request fail for PoleEmploi', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.accueilRepository = AccueilRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<AccueilLoadingState>((state) => state.accueilState);

Matcher _shouldFail() => StateIs<AccueilFailureState>((state) => state.accueilState);

Matcher _shouldSucceedMilo() {
  return StateIs<AccueilSuccessState>(
    (state) => state.accueilState,
    (state) {
      expect(state.accueil, mockAccueilMilo());
    },
  );
}

Matcher _shouldSucceedPoleEmploi() {
  return StateIs<AccueilSuccessState>(
    (state) => state.accueilState,
    (state) {
      expect(state.accueil, mockAccueilPoleEmploi());
    },
  );
}

class AccueilRepositorySuccessStub extends AccueilRepository {
  AccueilRepositorySuccessStub() : super(DioMock());

  @override
  Future<Accueil?> getAccueilMissionLocale(String userId, DateTime maintenant) async {
    return mockAccueilMilo();
  }

  @override
  Future<Accueil?> getAccueilPoleEmploi(String userId, DateTime maintenant) async {
    return mockAccueilPoleEmploi();
  }
}

class AccueilRepositoryErrorStub extends AccueilRepository {
  AccueilRepositoryErrorStub() : super(DioMock());

  @override
  Future<Accueil?> getAccueilMissionLocale(String userId, DateTime maintenant) async {
    return null;
  }

  @override
  Future<Accueil?> getAccueilPoleEmploi(String userId, DateTime maintenant) async {
    return null;
  }
}
