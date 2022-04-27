import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_action.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

void main() {
  test("delete user when repo succeeds should display loading and then delete user and logout", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.suppressionCompteRepository = SuppressionCompteRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        suppressionCompteState: SuppressionCompteSuccessState(),
        loginState: successMiloUserState(),
      ),
    );
    final displayedLoading = store.onChange.any((e) => e.suppressionCompteState is SuppressionCompteLoadingState);
    final success = store.onChange.firstWhere((e) => e.suppressionCompteState is SuppressionCompteSuccessState);
    final userLoggedOut = store.onChange.firstWhere((e) => e.loginState is LoginNotInitializedState);

    // When
    store.dispatch(SuppressionCompteRequestAction());

    // Then
    expect(await displayedLoading, true);
    expect((await success).suppressionCompteState is SuppressionCompteSuccessState, isTrue);
    expect((await userLoggedOut).loginState is LoginNotInitializedState, isTrue);
  });

  test("delete user when repo fails should display loading and keep user logged", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.suppressionCompteRepository = SuppressionCompteRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        suppressionCompteState: SuppressionCompteSuccessState(),
        loginState: successMiloUserState(),
      ),
    );
    final displayedLoading = store.onChange.any((e) => e.suppressionCompteState is SuppressionCompteLoadingState);
    final failure = store.onChange.firstWhere((e) => e.suppressionCompteState is SuppressionCompteFailureState);

    // When
    store.dispatch(SuppressionCompteRequestAction());

    // Then
    expect(await displayedLoading, true);
    final successAppState = await failure;
    expect(successAppState.suppressionCompteState is SuppressionCompteFailureState, isTrue);
  });
}
