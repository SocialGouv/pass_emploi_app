import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
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
    final searchState = store.state.immersionSearchState;
    final searchParamsState = store.state.immersionSearchRequestState;
    return ImmersionSearchResultsViewModel._(
      displayState: _displayState(searchState),
      items: _items(searchState),
      filtresCount: _filtresCount(searchParamsState),
      errorMessage: _errorMessage(searchState),
    );
  }

  @override
  List<Object?> get props => [displayState, items, filtresCount];
}

int? _filtresCount(ImmersionSearchRequestState searchParamsState) {
  return null;
}

List<Immersion> _items(State<List<Immersion>> searchState) =>
    searchState.isSuccess() ? searchState.getResultOrThrow() : [];

DisplayState _displayState(State<List<Immersion>> searchState) {
  if (searchState.isSuccess()) {
    return searchState.getResultOrThrow().isNotEmpty ? DisplayState.CONTENT : DisplayState.EMPTY;
  } else if (searchState.isLoading()) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

String _errorMessage(State<List<Immersion>> searchState) {
  return searchState.isFailure() ? Strings.genericError : "";
}
