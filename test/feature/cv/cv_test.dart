import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/features/cv/cv_state.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Cv', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => CvRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.cvRepository = CvRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.cvRepository = CvRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<CvLoadingState>((state) => state.cvState);

Matcher _shouldFail() => StateIs<CvFailureState>((state) => state.cvState);

Matcher _shouldSucceed() {
  return StateIs<CvSuccessState>(
    (state) => state.cvState,
    (state) {
      expect(state.cvList, mockCvPoleEmploiList());
    },
  );
}

class CvRepositorySuccessStub extends CvRepository {
  CvRepositorySuccessStub() : super(DioMock());

  @override
  Future<List<CvPoleEmploi>?> getCvs(String userId) async {
    return mockCvPoleEmploiList();
  }
}

class CvRepositoryErrorStub extends CvRepository {
  CvRepositoryErrorStub() : super(DioMock());

  @override
  Future<List<CvPoleEmploi>?> getCvs(String userId) async {
    return null;
  }
}
