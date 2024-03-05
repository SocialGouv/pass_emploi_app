import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_actions.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('PreferredLoginMode', () {
    final sut = StoreSut();
    final repository = MockPreferredLoginModeRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => PreferredLoginModeRequestAction());

      test('should load then succeed when request succeeds', () {
        const loginMode = LoginMode.MILO;
        when(() => repository.getPreferredMode()).thenAnswer((_) async => loginMode);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.preferredLoginModeRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed(loginMode)]);
      });
    });
  });
}

Matcher _shouldSucceed(LoginMode? loginMode) {
  return StateIs<PreferredLoginModeSuccessState>(
    (state) => state.preferredLoginModeState,
    (state) {
      expect(state.loginMode, loginMode);
    },
  );
}
