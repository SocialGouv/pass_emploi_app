import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("Returns metiers list when user search metier", () async {
    // Given
    final factory = TestStoreFactory();
    factory.metierRepository = MetierRepositorySuccessStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final Future<AppState> newStateFuture = store.onChange.firstWhere((e) => e.searchMetierState.metiers.isNotEmpty);

    // When
    store.dispatch(SearchMetierRequestAction("input"));

    // Then
    final newState = await newStateFuture;
    expect(newState.searchMetierState.metiers, mockAutocompleteMetiers());
  });

  test("Reset search metier remove previous metier results", () async {
    // Given
    final factory = TestStoreFactory();
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        searchMetierState: SearchMetierState(mockAutocompleteMetiers()),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(SearchMetierResetAction());

    // Then
    final newState = await newStateFuture;
    expect(newState.searchMetierState.metiers, isEmpty);
  });
}

class MetierRepositorySuccessStub extends MetierRepository {
  MetierRepositorySuccessStub(): super("", DummyHttpClient());

  @override
  Future<List<Metier>> getMetiers(String userInput) async {
    if (userInput == "input") return mockAutocompleteMetiers();
    return [];
  }
}
