import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/actions/immersion_search_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum ImmersionSearchDisplayState { SHOW_SEARCH_FORM, SHOW_RESULTS, SHOW_LOADER, SHOW_ERROR, SHOW_EMPTY_ERROR }

class ImmersionSearchViewModel extends Equatable {
  final ImmersionSearchDisplayState displayState;
  final List<LocationViewModel> locations;
  final List<Immersion> immersions;
  final String errorMessage;
  final Function(String? input) onInputLocation;
  final Function(String? codeRome, Location? location) onSearchingRequest;

  ImmersionSearchViewModel._({
    required this.displayState,
    required this.locations,
    required this.immersions,
    required this.errorMessage,
    required this.onInputLocation,
    required this.onSearchingRequest,
  });

  factory ImmersionSearchViewModel.create(Store<AppState> store) {
    final immersionSearchState = store.state.immersionSearchState;
    return ImmersionSearchViewModel._(
      displayState: _displayState(immersionSearchState),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      immersions: _immersions(immersionSearchState),
      errorMessage: _errorMessage(immersionSearchState),
      onInputLocation: (input) => store.dispatch(RequestLocationAction(input, villesOnly: true)),
      onSearchingRequest: (codeRome, location) {
        store.dispatch(codeRome != null && location != null
            ? SearchImmersionAction(codeRome, location)
            : ImmersionSearchFailureAction());
      },
    );
  }

  @override
  List<Object?> get props => [displayState, locations, errorMessage];
}

ImmersionSearchDisplayState _displayState(ImmersionSearchState immersionSearchState) {
  if (immersionSearchState is ImmersionSearchSuccessState && immersionSearchState.immersions.isNotEmpty) {
    return ImmersionSearchDisplayState.SHOW_RESULTS;
  } else if (immersionSearchState is ImmersionSearchSuccessState && immersionSearchState.immersions.isEmpty) {
    return ImmersionSearchDisplayState.SHOW_EMPTY_ERROR;
  } else if (immersionSearchState is ImmersionSearchLoadingState) {
    return ImmersionSearchDisplayState.SHOW_LOADER;
  } else if (immersionSearchState is ImmersionSearchFailureState) {
    return ImmersionSearchDisplayState.SHOW_ERROR;
  } else {
    return ImmersionSearchDisplayState.SHOW_SEARCH_FORM;
  }
}

List<Immersion> _immersions(ImmersionSearchState immersionSearchState) {
  if (immersionSearchState is ImmersionSearchSuccessState) {
    return immersionSearchState.immersions;
  }
  return [];
}

String _errorMessage(ImmersionSearchState immersionSearchState) {
  if (immersionSearchState is ImmersionSearchSuccessState && immersionSearchState.immersions.isEmpty) {
    return Strings.noContentError;
  } else if (immersionSearchState is ImmersionSearchFailureState) {
    return Strings.genericError;
  }
  return "";
}
