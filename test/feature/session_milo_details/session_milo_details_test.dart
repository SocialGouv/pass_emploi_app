import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_actions.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('SessionMiloDetails', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => SessionMiloDetailsRequestAction("sessionId"));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.sessionMiloRepository = MockSessionMiloRepository()..mockGetDetailsSuccess()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.sessionMiloRepository = MockSessionMiloRepository()..mockGetDetailsFailure()});

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
      expect(state.details, mockSessionMiloDetails());
    },
  );
}
