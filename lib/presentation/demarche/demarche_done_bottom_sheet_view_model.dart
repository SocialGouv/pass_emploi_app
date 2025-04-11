import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheDoneBottomSheetViewModel extends Equatable {
  final DisplayState displayState;
  final void Function(DateTime) onDemarcheDone;

  DemarcheDoneBottomSheetViewModel({
    required this.onDemarcheDone,
    required this.displayState,
  });

  factory DemarcheDoneBottomSheetViewModel.create(Store<AppState> store, String demarcheId) {
    final demarche = store.getDemarcheOrNull(demarcheId);

    if (demarche == null) {
      return DemarcheDoneBottomSheetViewModel(
        onDemarcheDone: (_) {},
        displayState: DisplayState.FAILURE,
      );
    }

    return DemarcheDoneBottomSheetViewModel(
      onDemarcheDone: (dateFin) => store.dispatch(
        UpdateDemarcheRequestAction(
          id: demarche.id,
          dateFin: dateFin,
          dateDebut: demarche.creationDate,
          status: DemarcheStatus.DONE,
        ),
      ),
      displayState: _updateStateDisplayState(store.state.updateDemarcheState),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
      ];
}

DisplayState _updateStateDisplayState(UpdateDemarcheState state) {
  if (state is UpdateDemarcheLoadingState) return DisplayState.LOADING;
  if (state is UpdateDemarcheFailureState) return DisplayState.FAILURE;
  if (state is UpdateDemarcheSuccessState) return DisplayState.CONTENT;
  return DisplayState.EMPTY;
}
