import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  test("applying new filtres when call succeeds should replace all existing data and filtres should be stored",
      () async {
    // Given
        final testStoreFactory = TestStoreFactory();
    final repositoryMock = ImmersionRepositorySuccessWithMoreDataMock();
    testStoreFactory.immersionRepository = repositoryMock;
    final store = _initializeReduxStore(testStoreFactory);

    final displayedLoading = store.onChange.any((element) => element.immersionListState is ImmersionListLoadingState);
    final successState =
        store.onChange.firstWhere((element) => element.immersionListState is ImmersionListSuccessState);

    // When
    store.dispatch(ImmersionSearchUpdateFiltresRequestAction(ImmersionSearchParametersFiltres.distance(40)));

    // Then
    expect(await displayedLoading, true);
    final appState = await successState;
    expect(appState.immersionListState is ImmersionListSuccessState, true);

    final paramsState = (appState.immersionSearchParametersState as ImmersionSearchParametersInitializedState);
    expect(paramsState.filtres.distance, 40);

    expect(repositoryMock.wasCalledWithFiltres, isTrue);
  });

  test("applying new filtres when call fails should erase existing data and filtres should be erased", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositoryFailureStub();
    final store = _initializeReduxStore(testStoreFactory);

    final displayedLoading = store.onChange.any((element) => element.immersionListState is ImmersionListLoadingState);
    final failureState =
        store.onChange.firstWhere((element) => element.immersionListState is ImmersionListFailureState);

    // When
    store.dispatch(
      ImmersionSearchUpdateFiltresRequestAction(
        ImmersionSearchParametersFiltres.distance(40),
      ),
    );

    // Then
    expect(await displayedLoading, true);
    final appState = await failureState;
    expect(appState.immersionListState is ImmersionListFailureState, true);

    final parametersState = appState.immersionSearchParametersState as ImmersionSearchParametersInitializedState;
    expect(parametersState.filtres.distance, null);
  });
}

Store<AppState> _initializeReduxStore(TestStoreFactory testStoreFactory) {
  return testStoreFactory.initializeReduxStore(
    initialState: loggedInState().copyWith(
      immersionSearchParametersState: ImmersionSearchParametersInitializedState(
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
        ville: "Paris",
        codeRome: "ROME",
        location: mockLocation(lat: 12, lon: 34),
      ),
    ),
  );
}

class ImmersionRepositorySuccessWithMoreDataMock extends ImmersionRepository {
  ImmersionRepositorySuccessWithMoreDataMock() : super("", DummyHttpClient(), DummyHeadersBuilder());

  bool wasCalledWithFiltres = false;

  @override
  Future<List<Immersion>?> search({required String userId, required SearchImmersionRequest request}) async {
    if (request.filtres.distance == 40) {
      wasCalledWithFiltres = true;
    }
    return [mockImmersion(), mockImmersion(), mockImmersion()];
  }
}
