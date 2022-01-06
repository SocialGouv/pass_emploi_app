import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("immersions should be loaded and results displayed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading = store.onChange.any((e) => e.immersionSearchState.isLoading());
    final Future<AppState> successStateFuture = store.onChange.firstWhere((e) => e.immersionSearchState.isSuccess());

    // When
    store.dispatch(ImmersionAction.request(ImmersionRequest("code-rome", mockLocation())));

    // Then
    expect(await displayedLoading, isTrue);
    final successState = await successStateFuture;
    expect(successState.immersionSearchState.getResultOrThrow(), [mockImmersion()]);
  });

  test("immersions should be loaded and error displayed when repository returns null", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading = store.onChange.any((e) => e.immersionSearchState.isLoading());
    final Future<bool> displayedError = store.onChange.any((e) => e.immersionSearchState.isFailure());

    // When
    store.dispatch(ImmersionAction.request(ImmersionRequest("code-rome", mockLocation())));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });

  test("immersions should be reset on reset action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInState().copyWith(immersionSearchState: State<List<Immersion>>.failure()),
    );

    final Future<AppState> resultStateFuture = store.onChange.first;

    // When
    store.dispatch(ImmersionAction.reset());

    // Then
    final resultState = await resultStateFuture;
    expect(resultState.immersionSearchState.isNotInitialized(), isTrue);
  });
}

class ImmersionRepositorySuccessStub extends ImmersionRepository {
  ImmersionRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Immersion>?> fetch(String userId, ImmersionRequest request) async {
    return request.codeRome == "code-rome" ? [mockImmersion()] : [];
  }
}

class ImmersionRepositoryFailureStub extends ImmersionRepository {
  ImmersionRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Immersion>?> fetch(String userId, ImmersionRequest request) async {
    return null;
  }
}
