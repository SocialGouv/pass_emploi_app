import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/immersion_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_state.dart';
import 'package:pass_emploi_app/repositories/Immersion_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("immersions should be loaded and results displayed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading =
        store.onChange.any((e) => e.immersionSearchState is ImmersionSearchLoadingState);
    final Future<AppState> successStateFuture =
        store.onChange.firstWhere((e) => e.immersionSearchState is ImmersionSearchSuccessState);

    // When
    store.dispatch(SearchImmersionAction("code-rome", mockLocation()));

    // Then
    expect(await displayedLoading, true);
    final successState = await successStateFuture;
    final immersionState = (successState.immersionSearchState as ImmersionSearchSuccessState);
    expect(immersionState.immersions, [mockImmersion()]);
  });

  test("immersions should be loaded and error displayed when repository returns null", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading =
        store.onChange.any((e) => e.immersionSearchState is ImmersionSearchLoadingState);
    final Future<bool> displayedError =
        store.onChange.any((e) => e.immersionSearchState is ImmersionSearchFailureState);

    // When
    store.dispatch(SearchImmersionAction("code-rome", mockLocation()));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });

  test("immersions should be reset on reset action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInState().copyWith(immersionSearchState: ImmersionSearchState.failure()),
    );

    final Future<AppState> resultStateFuture = store.onChange.first;

    // When
    store.dispatch(ImmersionSearchResetResultsAction());

    // Then
    final resultState = await resultStateFuture;
    expect(resultState.immersionSearchState is ImmersionSearchNotInitializedState, true);
  });
}

class ImmersionRepositorySuccessStub extends ImmersionRepository {
  ImmersionRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<List<Immersion>?> getImmersions({
    required String userId,
    required String codeRome,
    required Location location,
  }) async {
    return codeRome == "code-rome" ? [mockImmersion()] : [];
  }
}

class ImmersionRepositoryFailureStub extends ImmersionRepository {
  ImmersionRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<List<Immersion>?> getImmersions({
    required String userId,
    required String codeRome,
    required Location location,
  }) async {
    return null;
  }
}
