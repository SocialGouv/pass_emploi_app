import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ThematiquesDemarchePageViewModel extends Equatable {
  final DisplayState displayState;
  final List<ThematiquesDemarcheItem> thematiques;

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

List<ThematiquesDemarcheItem> _thematiques(ThematiquesDemarcheState state) {
  return state is ThematiquesDemarcheSuccessState
      ? state.thematiques.map((e) => ThematiquesDemarcheItem(id: e.code, title: e.libelle)).toList()
      : <ThematiquesDemarcheItem>[];
}

DisplayState _displayState(ThematiquesDemarcheState state) {
  if (state is ThematiquesDemarcheFailureState) return DisplayState.FAILURE;
  if (state is ThematiquesDemarcheSuccessState) return DisplayState.CONTENT;
  return DisplayState.LOADING;
}

class ThematiquesDemarcheItem extends Equatable {
  final String id;
  final String title;

  ThematiquesDemarcheItem({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}
