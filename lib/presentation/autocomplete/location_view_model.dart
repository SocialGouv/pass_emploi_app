import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class LocationViewModel extends Equatable {
  final List<Location> locations;
  final Function(String? input, bool villesOnly) onInputLocation;

  LocationViewModel._({
    required this.locations,
    required this.onInputLocation,
  });

  factory LocationViewModel.create(Store<AppState> store) {
    return LocationViewModel._(
      locations: store.state.searchLocationState.locations,
      onInputLocation: (input, villesOnly) {
        return store.dispatch(SearchLocationRequestAction(input, villesOnly: villesOnly));
      },
    );
  }

  @override
  List<Object?> get props => [locations];
}
