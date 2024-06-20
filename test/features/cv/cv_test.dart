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
      sut.whenDispatchingAction(() => CvRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.cvRepository = CvRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.cvRepository = CvRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });

    group("when downloading", () {
      final cv = mockCvPoleEmploi();
      sut.whenDispatchingAction(() => CvDownloadRequestAction(cv));

      test('status should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .withCvSuccess()
            .store((f) => {f.cvRepository = CvRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadDownload(), _shouldSucceedDownload()]);
      });

      test('status should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .withCvSuccess()
            .store((f) => {f.cvRepository = CvRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoadDownload(), _shouldFailDownload()]);
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

Matcher _shouldLoadDownload() => _downloadShouldBeInStatus(CvDownloadStatus.loading);

Matcher _shouldFailDownload() => _downloadShouldBeInStatus(CvDownloadStatus.failure);

Matcher _shouldSucceedDownload() => _downloadShouldBeInStatus(CvDownloadStatus.success);

Matcher _downloadShouldBeInStatus(CvDownloadStatus status) {
  final cv = mockCvPoleEmploi();

  return StateMatch(
    (state) => state.cvState is CvSuccessState && (state.cvState as CvSuccessState).cvDownloadStatus[cv.url] == status,
    (state) {
      expect((state.cvState as CvSuccessState).cvDownloadStatus[cv.url], status);
    },
  );
}

class CvRepositorySuccessStub extends CvRepository {
  CvRepositorySuccessStub() : super(DioMock());

  @override
  Future<List<CvPoleEmploi>?> getCvs(String userId) async {
    return mockCvPoleEmploiList();
  }

  @override
  Future<String?> download({required String url, required String fileName}) async {
    return "path";
  }
}

class CvRepositoryErrorStub extends CvRepository {
  CvRepositoryErrorStub() : super(DioMock());

  @override
  Future<List<CvPoleEmploi>?> getCvs(String userId) async {
    return null;
  }

  @override
  Future<String?> download({required String url, required String fileName}) async {
    return null;
  }
}
