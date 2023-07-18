import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_actions.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';

import '../../doubles/dio_mock.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('SessionMiloDetails', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => SessionMiloDetailsRequestAction());

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.sessionMiloDetailsRepository = SessionMiloDetailsRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.sessionMiloDetailsRepository = SessionMiloDetailsRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<SessionMiloDetailsLoadingState>((state) => state.sessionMiloDetailsState);

Matcher _shouldFail() => StateIs<SessionMiloDetailsFailureState>((state) => state.sessionMiloDetailsState);

Matcher _shouldSucceed() {
  return StateIs<SessionMiloDetailsSuccessState>(
    (state) => state.sessionMiloDetailsState,
    (state) {
      expect(state.result, true);
    },
  );
}

class SessionMiloDetailsRepositorySuccessStub extends SessionMiloDetailsRepository {
  SessionMiloDetailsRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool?> get() async {
    return true;
  }
}

class SessionMiloDetailsRepositoryErrorStub extends SessionMiloDetailsRepository {
  SessionMiloDetailsRepositoryErrorStub() : super(DioMock());

  @override
  Future<bool?> get() async {
    return null;
  }
}
