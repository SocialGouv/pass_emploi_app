import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("should fetch details jeune", () async {
    // Given
    final store = _storeWithSuccessFetchingRepositories();
    final newState = store.onChange.firstWhere((element) => element.detailsJeuneState is DetailsJeuneSuccessState);
    final loadingDisplayed = store.onChange.any((element) => element.detailsJeuneState is DetailsJeuneLoadingState);

    // When
    store.dispatch(DetailsJeuneRequestAction());

    // Then
    expect(await loadingDisplayed, true);
    expect((await newState).detailsJeuneState, DetailsJeuneSuccessState(detailsJeune: detailsJeune()));
  });

  test("should handle fetch failure", () async {
    // Given
    final store = _storeWithErrorFetchingRepositories();
    final newState = store.onChange.firstWhere((element) => element.detailsJeuneState is DetailsJeuneFailureState);
    final loadingDisplayed = store.onChange.any((element) => element.detailsJeuneState is DetailsJeuneLoadingState);

    // When
    store.dispatch(DetailsJeuneRequestAction());

    // Then
    expect(await loadingDisplayed, true);
    expect((await newState).detailsJeuneState, DetailsJeuneFailureState());
  });
}

Store<AppState> _storeWithSuccessFetchingRepositories() {
  final factory = TestStoreFactory();
  final repository = DetailsJeuneRepositorySuccessStub();
  factory.detailsJeuneRepository = repository;
  return factory.initializeReduxStore(initialState: loggedInState());
}

Store<AppState> _storeWithErrorFetchingRepositories() {
  final factory = TestStoreFactory();
  final repository = DetailsJeuneRepositoryErrorStub();
  factory.detailsJeuneRepository = repository;
  return factory.initializeReduxStore(initialState: loggedInState());
}

class DetailsJeuneRepositorySuccessStub extends DetailsJeuneRepository {
  DetailsJeuneRepositorySuccessStub() : super(DioMock());

  @override
  Future<DetailsJeune?> get(String userId) async {
    return detailsJeune();
  }
}

class DetailsJeuneRepositoryErrorStub extends DetailsJeuneRepository {
  DetailsJeuneRepositoryErrorStub() : super(DioMock());

  @override
  Future<DetailsJeune?> get(String userId) async {
    return null;
  }
}
