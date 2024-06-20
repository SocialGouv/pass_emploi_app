import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('locations should return locations from state', () {
    // Given
    final locations = [mockLocation()];
    final store = givenState().copyWith(searchLocationState: SearchLocationState(locations)).store();

    // When
    final viewModel = LocationViewModel.create(store, villesOnly: false);

    // Then
    expect(viewModel.locations, [
      LocationSuggestionItem(mockLocation(), LocationSource.autocomplete),
    ]);
  });

  group('dernieres locations', () {
    test('with empty recherches recentes', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: false);
      // Then
      expect(viewModel.dernieresLocations, []);
    });

    test('with 1 recherche recente', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockOffreEmploiAlerte(location: mockLocation()),
      ]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: false);
      // Then
      expect(viewModel.dernieresLocations, [
        LocationTitleItem("Dernière recherche"),
        LocationSuggestionItem(mockLocation(), LocationSource.dernieresRecherches),
      ]);
    });

    test('with many recherches recentes should only take 3', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockOffreEmploiAlerte(
          location: Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '3', code: '3', codePostal: '3', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '4', code: '4', codePostal: '4', type: LocationType.COMMUNE),
        ),
      ]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: false);
      // Then
      expect(viewModel.dernieresLocations, [
        LocationTitleItem("Dernières recherches"),
        LocationSuggestionItem(
          Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
        LocationSuggestionItem(
          Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
        LocationSuggestionItem(
          Location(libelle: '3', code: '3', codePostal: '3', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
      ]);
    });

    test('with null location in recherches recentes should remove them', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockOffreEmploiAlerte(
          location: Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(location: null),
      ]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: false);
      // Then
      expect(viewModel.dernieresLocations, [
        LocationTitleItem("Dernières recherches"),
        LocationSuggestionItem(
          Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
        LocationSuggestionItem(
          Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
      ]);
    });

    test('with invalid location in recherches recentes should remove them - REQUIRED WHEN COMING FROM SUGGESTIONS', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockOffreEmploiAlerte(
          location: Location(libelle: '1', code: '', codePostal: '1', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '2', code: '2', codePostal: null, type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '3', code: '3', codePostal: '3', type: LocationType.COMMUNE),
        ),
      ]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: false);
      // Then
      expect(viewModel.dernieresLocations, [
        LocationTitleItem("Dernière recherche"),
        LocationSuggestionItem(
          Location(libelle: '3', code: '3', codePostal: '3', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
      ]);
    });

    test('with duplicated location in recherches recentes should remove them', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockOffreEmploiAlerte(
          location: Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
        ),
      ]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: false);
      // Then
      expect(viewModel.dernieresLocations, [
        LocationTitleItem("Dernières recherches"),
        LocationSuggestionItem(
          Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
        LocationSuggestionItem(
          Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
      ]);
    });

    test('with villesOnly should only return villes', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockOffreEmploiAlerte(
          location: Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '2', code: '2', codePostal: '2', type: LocationType.DEPARTMENT),
        ),
        mockOffreEmploiAlerte(
          location: Location(libelle: '3', code: '3', codePostal: '3', type: LocationType.COMMUNE),
        ),
      ]).store();
      // When
      final viewModel = LocationViewModel.create(store, villesOnly: true);
      // Then
      expect(viewModel.dernieresLocations, [
        LocationTitleItem("Dernières recherches"),
        LocationSuggestionItem(
          Location(libelle: '1', code: '1', codePostal: '1', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
        LocationSuggestionItem(
          Location(libelle: '3', code: '3', codePostal: '3', type: LocationType.COMMUNE),
          LocationSource.dernieresRecherches,
        ),
      ]);
    });
  });

  test('onInputLocation should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = LocationViewModel.create(store, villesOnly: true);

    // When
    viewModel.onInputLocation('input');

    // Then
    expect(store.dispatchedAction, isA<SearchLocationRequestAction>());
    final action = store.dispatchedAction as SearchLocationRequestAction;
    expect(action.input, 'input');
    expect(action.villesOnly, true);
  });
}
