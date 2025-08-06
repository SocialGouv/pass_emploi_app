import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheSuccessViewModel extends Equatable {
  final String demarcheId;
  final DisplayState displayState;

  CreateDemarcheSuccessViewModel({
    required this.demarcheId,
    required this.displayState,
  });

  factory CreateDemarcheSuccessViewModel.create(Store<AppState> store) {
    return CreateDemarcheSuccessViewModel(
      demarcheId: _demarcheId(store),
      displayState: _displayState(store),
    );
  }

  @override
  List<Object?> get props => [demarcheId, displayState];
}

String _demarcheId(Store<AppState> store) {
  final createState = store.state.createDemarcheState;
  return createState is CreateDemarcheSuccessState ? createState.demarcheCreatedId : "";
}

DisplayState _displayState(Store<AppState> store) {
  final createState = store.state.createDemarcheState;
  return switch (createState) {
    CreateDemarcheNotInitializedState() => DisplayState.LOADING,
    CreateDemarcheLoadingState() => DisplayState.LOADING,
    CreateDemarcheSuccessState() => DisplayState.CONTENT,
    CreateDemarcheFailureState() => DisplayState.FAILURE,
  };
}
