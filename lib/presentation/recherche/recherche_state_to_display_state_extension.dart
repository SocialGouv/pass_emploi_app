import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

extension RechercheStateToDisplayState on RechercheState {
  DisplayState displayState() {
    if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
    if (status == RechercheStatus.failure) return DisplayState.FAILURE;
    return DisplayState.CONTENT;
  }
}
