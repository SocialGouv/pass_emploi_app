import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldGoBack;
  final Function(String, DateTime) onCreateDemarche;

  CreateDemarcheViewModel({
    required this.displayState,
    required this.shouldGoBack,
    required this.onCreateDemarche,
  });

  factory CreateDemarcheViewModel.create(Store<AppState> store) {
    return CreateDemarcheViewModel(
      displayState: _displayState(store),
      shouldGoBack: store.state.createDemarcheState is CreateDemarcheSuccessState,
      onCreateDemarche: (commentaire, echeanceDate) => store.dispatch(
        CreateDemarcheRequestAction(commentaire, echeanceDate),
      ),
    );
  }

  @override
  List<Object> get props => [shouldGoBack, displayState];
}

DisplayState _displayState(Store<AppState> store) {
  if (store.state.createDemarcheState is CreateDemarcheFailureState) return DisplayState.FAILURE;
  if (store.state.createDemarcheState is CreateDemarcheLoadingState) return DisplayState.LOADING;
  return DisplayState.CONTENT;
}
