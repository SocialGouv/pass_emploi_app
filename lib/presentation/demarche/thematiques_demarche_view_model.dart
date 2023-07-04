import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ThematiquesDemarchePageViewModel extends Equatable {
  final DisplayState displayState;
  final List<ThematiqueDeDemarche> thematiques;

  ThematiquesDemarchePageViewModel({required this.displayState, required this.thematiques});

  factory ThematiquesDemarchePageViewModel.create(Store<AppState> store) {
    final state = store.state.thematiquesDemarcheState;
    return ThematiquesDemarchePageViewModel(
      displayState: _displayState(state),
      thematiques: _thematiques(state),
    );
  }

  @override
  List<Object?> get props => [displayState, thematiques];
}

List<ThematiqueDeDemarche> _thematiques(ThematiquesDemarcheState state) {
  return state is ThematiquesDemarcheSuccessState ? state.thematiques : [];
}

DisplayState _displayState(ThematiquesDemarcheState state) {
  if (state is ThematiquesDemarcheFailureState) return DisplayState.FAILURE;
  if (state is ThematiquesDemarcheSuccessState) return DisplayState.CONTENT;
  return DisplayState.LOADING;
}
