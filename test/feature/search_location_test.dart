import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("Returns locations list when user search location", () async {
    // Given
    final factory = TestStoreFactory();
    factory.searchLocationRepository = SearchLocationRepositorySuccessStub();
    final store = factory.initializeReduxStore(initialState: loggedInAppState());
    store.dispatch(RequestLocationAction("input"));

    // When
    final AppState resultState = await store.onChange.first;

    // Then
    final locationState = resultState.searchLocationState;
    expect(locationState.locations, _location());
  });

  test("Returns locations empty list when user search input is empty", () async {
    // Given
    final factory = TestStoreFactory();
    factory.searchLocationRepository = SearchLocationRepositorySuccessStub();
    final store = factory.initializeReduxStore(initialState: loggedInAppState());
    store.dispatch(RequestLocationAction(""));

    // When
    final AppState resultState = await store.onChange.first;

    // Then
    final locationState = resultState.searchLocationState;
    expect(locationState.locations, []);
  });

}

class SearchLocationRepositorySuccessStub extends SearchLocationRepository {
  SearchLocationRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Location>> getLocations({required String userId, required String query}) async {
    if (userId == "id" && query == "input") return _location();
    return [];
  }
}

List<Location> _location() =>
    [Location(libelle: "Marseille", code: "13002", codePostal: "13002", type: LocationType.COMMUNE)];
