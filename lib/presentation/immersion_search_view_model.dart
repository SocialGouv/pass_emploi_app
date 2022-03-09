import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_request.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum ImmersionSearchDisplayState { SHOW_SEARCH_FORM, SHOW_RESULTS, SHOW_LOADER, SHOW_ERROR }

class ImmersionSearchViewModel extends Equatable {
  final ImmersionSearchDisplayState displayState;
  final List<LocationViewModel> locations;
  final List<Metier> metiers;
  final List<Immersion> immersions;
  final String errorMessage;
  final Function(String? input) onInputLocation;
  final Function(String? input) onInputMetier;
  final Function(String? codeRome, Location? location, String? title) onSearchingRequest;

  ImmersionSearchViewModel._({
    required this.displayState,
    required this.locations,
    required this.metiers,
    required this.immersions,
    required this.errorMessage,
    required this.onInputLocation,
    required this.onInputMetier,
    required this.onSearchingRequest,
  });

  factory ImmersionSearchViewModel.create(Store<AppState> store) {
    final immersionSearchState = store.state.immersionListState;
    return ImmersionSearchViewModel._(
      displayState: _displayState(immersionSearchState),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      metiers: store.state.searchMetierState.metiers,
      immersions: _immersions(immersionSearchState),
      errorMessage: _errorMessage(immersionSearchState),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input, villesOnly: true)),
      onInputMetier: (input) => store.dispatch(SearchMetierRequestAction(input)),
      onSearchingRequest: (codeRome, location, title) {
        store.dispatch(
          codeRome != null && location != null
              ? ImmersionListRequestAction(ImmersionListRequest(codeRome, location, title))
              : ImmersionListFailureAction(),
        );
      },
    );
  }

  @override
  List<Object?> get props => [displayState, locations, errorMessage, metiers];
}

ImmersionSearchDisplayState _displayState(ImmersionListState state) {
  if (state is ImmersionListSuccessState) {
    return ImmersionSearchDisplayState.SHOW_RESULTS;
  } else if (state is ImmersionListLoadingState) {
    return ImmersionSearchDisplayState.SHOW_LOADER;
  } else if (state is ImmersionListFailureState) {
    return ImmersionSearchDisplayState.SHOW_ERROR;
  } else {
    return ImmersionSearchDisplayState.SHOW_SEARCH_FORM;
  }
}

List<Immersion> _immersions(ImmersionListState state) {
  if (state is ImmersionListSuccessState) return state.immersions;
  return [];
}

String _errorMessage(ImmersionListState state) {
  return state is ImmersionListFailureState ? Strings.genericError : "";
}
