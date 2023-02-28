import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('DiagorienteUrls', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => DiagorienteUrlsRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.diagorienteUrlsRepository = DiagorienteUrlsRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.diagorienteUrlsRepository = DiagorienteUrlsRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<DiagorienteUrlsLoadingState>((state) => state.diagorienteUrlsState);

Matcher _shouldFail() => StateIs<DiagorienteUrlsFailureState>((state) => state.diagorienteUrlsState);

Matcher _shouldSucceed() {
  return StateIs<DiagorienteUrlsSuccessState>(
    (state) => state.diagorienteUrlsState,
    (state) {
      expect(state.result, mockDiagorienteUrls());
    },
  );
}

class DiagorienteUrlsRepositorySuccessStub extends DiagorienteUrlsRepository {
  DiagorienteUrlsRepositorySuccessStub() : super(DioMock());

  @override
  Future<DiagorienteUrls?> getUrls(String userId) async => mockDiagorienteUrls();
}

class DiagorienteUrlsRepositoryErrorStub extends DiagorienteUrlsRepository {
  DiagorienteUrlsRepositoryErrorStub() : super(DioMock());

  @override
  Future<DiagorienteUrls?> getUrls(String userId) async => null;
}
