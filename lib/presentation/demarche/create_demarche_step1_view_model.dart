import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep1ViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldGoToStep2;
  final Function(String) onSearchDemarche;

  CreateDemarcheStep1ViewModel({
    required this.displayState,
    required this.shouldGoToStep2,
    required this.onSearchDemarche,
  });

  factory CreateDemarcheStep1ViewModel.create(Store<AppState> store) {
    final state = store.state.searchDemarcheState;
    return CreateDemarcheStep1ViewModel(
      displayState: _displayState(state),
      shouldGoToStep2: state is SearchDemarcheSuccessState,
      onSearchDemarche: (query) => store.dispatch(SearchDemarcheRequestAction(query)),
    );
  }

  @override
  List<Object?> get props => [displayState, shouldGoToStep2];
}

DisplayState _displayState(SearchDemarcheState state) {
  if (state is SearchDemarcheLoadingState) return DisplayState.LOADING;
  if (state is SearchDemarcheFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
