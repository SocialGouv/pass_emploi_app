import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ImmersionSearchResultsViewModel extends Equatable {
  final DisplayState displayState;
  final List<Immersion> items;
  final int? filtresCount;
  final String errorMessage;

  ImmersionSearchResultsViewModel._({
    required this.displayState,
    required this.items,
    required this.filtresCount,
    required this.errorMessage,
  });

  factory ImmersionSearchResultsViewModel.create(Store<AppState> store) {
    final searchState = store.state.immersionListState;
    final searchParamsState = store.state.immersionSearchParametersState;
    return ImmersionSearchResultsViewModel._(
      displayState: _displayState(searchState),
      items: _items(searchState),
      filtresCount: _filtresCount(searchParamsState),
      errorMessage: _errorMessage(searchState),
    );
  }

  @override
  List<Object?> get props => [displayState, items, filtresCount, errorMessage];
}

int? _filtresCount(ImmersionSearchParametersState searchParamsState) {
  return null;
}

List<Immersion> _items(ImmersionListState searchState) =>
    searchState is ImmersionListSuccessState ? searchState.immersions : [];

DisplayState _displayState(ImmersionListState searchState) {
  if (searchState is ImmersionListSuccessState) {
    return searchState.immersions.isNotEmpty ? DisplayState.CONTENT : DisplayState.EMPTY;
  } else if (searchState is ImmersionListLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

String _errorMessage(ImmersionListState searchState) {
  return searchState is ImmersionListFailureState ? Strings.genericError : "";
}
