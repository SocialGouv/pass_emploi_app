import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:redux/redux.dart';

import '../redux/actions/search_location_action.dart';
import '../redux/actions/search_service_civique_actions.dart';
import '../redux/states/app_state.dart';

class ServiceCiviqueViewModel extends Equatable {
  final List<LocationViewModel> locations;
  final Function(Location? location) onSearchRequest;
  final Function(String? input) onInputLocation;

  ServiceCiviqueViewModel._({
    required this.locations,
    required this.onSearchRequest,
    required this.onInputLocation,
  });

  factory ServiceCiviqueViewModel.create(Store<AppState> store) {
    return ServiceCiviqueViewModel._(
        locations: store.state.searchLocationState.locations
            .map((location) => LocationViewModel.fromLocation(location))
            .toList(),
        onSearchRequest: (location) {
          SearchServiceCiviqueAction(location: location);
        },
        onInputLocation: (input) => store.dispatch(RequestLocationAction(input, villesOnly: true)));
  }

  @override
  List<Object?> get props => [locations];
}
