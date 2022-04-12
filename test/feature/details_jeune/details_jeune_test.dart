import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("should display details jeune", () async {
    // Given
    final store = _storeWithSuccessFetchingRepositories();
    final newState = store.onChange.firstWhere((element) => element.detailsJeuneState is DetailsJeuneSuccessState);

    // When
    store.dispatch(DetailsJeuneRequestAction());

    // Then
    expect((await newState).detailsJeuneState, DetailsJeuneSuccessState(detailsJeune: detailsJeune()));
  });

  test("should display loading", () async {
    // Given
    final store = _storeWithSuccessFetchingRepositories();
    final loadingDisplayed = store.onChange.any((element) => element.detailsJeuneState is DetailsJeuneLoadingState);

    // When
    store.dispatch(DetailsJeuneRequestAction());

    // Then
    expect(await loadingDisplayed, true);
  });
}

Store<AppState> _storeWithSuccessFetchingRepositories() {
  final factory = TestStoreFactory();
  final repository = DetailsJeuneRepositorySuccessStub();
  factory.detailsJeuneRepository = repository;
  return factory.initializeReduxStore(initialState: loggedInState());
}

class DetailsJeuneRepositorySuccessStub extends DetailsJeuneRepository {
  DetailsJeuneRepositorySuccessStub() : super('', DummyHttpClient());

  @override
  Future<DetailsJeune?> fetch(String userId) async {
    return detailsJeune();
  }
}
