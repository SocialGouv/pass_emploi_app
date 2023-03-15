import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:redux/redux.dart';

class LocationViewModel extends Equatable {
  final List<LocationItem> locations;
  final List<LocationItem> dernieresLocations;
  final Function(String? input) onInputLocation;

  LocationViewModel._({
    required this.locations,
    required this.dernieresLocations,
    required this.onInputLocation,
  });

  factory LocationViewModel.create(Store<AppState> store, {required bool villesOnly}) {
    return LocationViewModel._(
      locations: _locationItems(store),
      dernieresLocations: _dernieresLocationItems(_dernieresLocations(store, villesOnly)),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input, villesOnly: villesOnly)),
    );
  }

  List<LocationItem> getAutocompleteItems(bool emptyInput) => emptyInput ? dernieresLocations : locations;

  @override
  List<Object?> get props => [locations, dernieresLocations];
}

abstract class LocationItem extends Equatable {}

enum LocationSource { autocomplete, dernieresRecherches }

class LocationTitleItem extends LocationItem {
  final String title;

  LocationTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class LocationSuggestionItem extends LocationItem {
  final Location location;
  final LocationSource source;

  LocationSuggestionItem(this.location, this.source);

  @override
  List<Object?> get props => [location, source];
}

List<LocationItem> _locationItems(Store<AppState> store) {
  return store.state.searchLocationState.locations
      .map((e) => LocationSuggestionItem(e, LocationSource.autocomplete))
      .toList();
}

List<LocationItem> _dernieresLocationItems(List<Location> locations) {
  if (locations.isEmpty) return [];
  final title = locations.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    LocationTitleItem(title),
    ...locations.map((e) => LocationSuggestionItem(e, LocationSource.dernieresRecherches)),
  ];
}

List<Location> _dernieresLocations(Store<AppState> store, bool villesOnly) {
  return store.state.recherchesRecentesState.recentSearches
      .map((offre) => offre.getLocation())
      .whereNotNull()
      .distinct()
      .where((location) => villesOnly ? location.type == LocationType.COMMUNE : true)
      .take(3)
      .toList();
}
