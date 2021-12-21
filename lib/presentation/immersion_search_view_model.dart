import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ImmersionSearchViewModel {
  final List<LocationViewModel> locations;
  final Function(String? input) onInputLocation;

  ImmersionSearchViewModel._({
    required this.locations,
    required this.onInputLocation,
  });

  factory ImmersionSearchViewModel.create(Store<AppState> store) {
    return ImmersionSearchViewModel._(
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      onInputLocation: (input) => store.dispatch(RequestLocationAction(input, villesOnly: true)),
    );
  }
}
