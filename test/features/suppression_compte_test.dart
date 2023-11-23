import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_action.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';

import '../doubles/mocks.dart';
import '../doubles/stubs.dart';
import '../dsl/app_state_dsl.dart';
import '../dsl/matchers.dart';
import '../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when deleting user", () {
    sut.whenDispatchingAction(() => SuppressionCompteRequestAction());

    test('should display loading and then delete user and logout when request succeeds', () {
      sut.givenStore = givenState()
          .loggedInMiloUser() //
          .store((f) {
        f.suppressionCompteRepository = SuppressionCompteRepositorySuccessStub();
        f.matomoTracker = MockMatomoTracker();
      });

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed(), _shouldLogout()]);
    });

    test('should display loading then fail and not logout user when request fails', () async {
      sut.givenStore = givenState()
          .loggedInMiloUser() //
          .store((f) {
        f.suppressionCompteRepository = SuppressionCompteRepositoryFailureStub();
        f.matomoTracker = MockMatomoTracker();
      });

      await sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      expect(sut.givenStore.state.loginState, isA<LoginSuccessState>());
    });
  });
}

Matcher _shouldLoad() => StateIs<SuppressionCompteLoadingState>((state) => state.suppressionCompteState);

Matcher _shouldFail() => StateIs<SuppressionCompteFailureState>((state) => state.suppressionCompteState);

Matcher _shouldSucceed() => StateIs<SuppressionCompteSuccessState>((state) => state.suppressionCompteState);

Matcher _shouldLogout() => StateIs<LoginNotInitializedState>((state) => state.loginState);
