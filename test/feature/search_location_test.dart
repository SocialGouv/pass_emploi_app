import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("Returns locations list when user search location", () async {
    // Given
    final factory = TestStoreFactory();
    factory.searchLocationRepository = SearchLocationRepositorySuccessStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final Future<AppState> newStateFuture =
        store.onChange.firstWhere((state) => state.searchLocationState.locations.isNotEmpty);

    // When
    store.dispatch(RequestLocationAction("input"));

    // Then
    final newState = await newStateFuture;
    expect(newState.searchLocationState.locations, _locations());
  });

  test("Returns locations list when user search only villes", () async {
    // Given
    final factory = TestStoreFactory();
    final repositorySpy = SearchLocationRepositorySpy();
    factory.searchLocationRepository = repositorySpy;
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final Future<AppState> newStateFuture =
        store.onChange.firstWhere((state) => state.searchLocationState.locations.isNotEmpty);

    // When
    store.dispatch(RequestLocationAction("input", villesOnly: true));

    // Then
    final newState = await newStateFuture;
    expect(newState.searchLocationState.locations, _locations());
    expect(repositorySpy.getLocationsHasBeenCalledWithVillesOnly, isTrue);
  });

  test("Does not call repository user search input is less than 2 characters… and return empty locations result",
      () async {
    // Given
        final factory = TestStoreFactory();
    final repositorySpy = SearchLocationRepositorySpy();
    factory.searchLocationRepository = repositorySpy;
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(RequestLocationAction("i"));

    // Then
    final newState = await newStateFuture;
    expect(newState.searchLocationState.locations, isEmpty);
    expect(repositorySpy.getLocationsHasBeenCalled, isFalse);
  });

  test("Reset search locations remove previous location results", () async {
    // Given
    final factory = TestStoreFactory();
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        searchLocationState: SearchLocationState(_locations()),
      ),
    );
    final Future<AppState> newStateFuture = store.onChange.first;

    // When
    store.dispatch(ResetLocationAction());

    // Then
    final newState = await newStateFuture;
    expect(newState.searchLocationState.locations, isEmpty);
  });
}

class SearchLocationRepositorySuccessStub extends SearchLocationRepository {
  SearchLocationRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Location>> getLocations({required String userId, required String query, bool villesOnly = false}) async {
    if (userId == "id" && query == "input") return _locations();
    return [];
  }
}

class SearchLocationRepositorySpy extends SearchLocationRepository {
  bool getLocationsHasBeenCalled = false;
  bool getLocationsHasBeenCalledWithVillesOnly = false;

  SearchLocationRepositorySpy() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<Location>> getLocations({required String userId, required String query, bool villesOnly = false}) async {
    getLocationsHasBeenCalled = true;
    getLocationsHasBeenCalledWithVillesOnly = villesOnly;
    return _locations();
  }
}

List<Location> _locations() =>
    [Location(libelle: "Marseille", code: "13002", codePostal: "13002", type: LocationType.COMMUNE)];
