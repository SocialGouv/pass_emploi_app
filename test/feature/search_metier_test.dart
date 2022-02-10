import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/redux/actions/search_metier_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/search_metier_state.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("Returns metiers list when user search metier", () async {
    // Given
    final factory = TestStoreFactory();
    factory.metierRepository = MetierRepositorySuccessStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final Future<AppState> newStateFuture =
        store.onChange.firstWhere((state) => state.searchMetierState.metiers.isNotEmpty);

    // When
    store.dispatch(RequestMetierAction("input"));

    // Then
    final newState = await newStateFuture;
    expect(newState.searchMetierState.metiers, _metiers());
  });

  test("Reset search metier remove previous metier results", () async {
    // Given
    final factory = TestStoreFactory();
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        searchMetierState: SearchMetierState(_metiers()),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(ResetMetierAction());

    // Then
    final newState = await newStateFuture;
    expect(newState.searchMetierState.metiers, isEmpty);
  });
}

class MetierRepositorySuccessStub extends MetierRepository {
  @override
  Future<List<Metier>> getMetiers(String userInput) async {
    if (userInput == "input") return _metiers();
    return [];
  }
}

List<Metier> _metiers() => [Metier.values.first];
