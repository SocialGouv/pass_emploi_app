import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarchePersonnaliseeViewModel extends Equatable {
  final DisplayState displayState;
  final DemarcheCreationState demarcheCreationState;
  final Function(String, DateTime) onCreateDemarche;

  CreateDemarchePersonnaliseeViewModel({
    required this.displayState,
    required this.demarcheCreationState,
    required this.onCreateDemarche,
  });

  factory CreateDemarchePersonnaliseeViewModel.create(Store<AppState> store, bool estDuplicata) {
    return CreateDemarchePersonnaliseeViewModel(
      displayState: _displayState(store),
      demarcheCreationState: _demarcheCreationState(store),
      onCreateDemarche: (commentaire, dateEcheance) => store.dispatch(
        CreateDemarchePersonnaliseeRequestAction(commentaire, dateEcheance, estDuplicata),
      ),
    );
  }

  @override
  List<Object> get props => [demarcheCreationState, displayState];
}

DisplayState _displayState(Store<AppState> store) {
  if (store.state.createDemarcheState is CreateDemarcheFailureState) return DisplayState.FAILURE;
  if (store.state.createDemarcheState is CreateDemarcheLoadingState) return DisplayState.LOADING;
  return DisplayState.CONTENT;
}

DemarcheCreationState _demarcheCreationState(Store<AppState> store) {
  final createState = store.state.createDemarcheState;
  return createState is CreateDemarcheSuccessState
      ? DemarcheCreationSuccessState(createState.demarcheCreatedId)
      : DemarcheCreationPendingState();
}
