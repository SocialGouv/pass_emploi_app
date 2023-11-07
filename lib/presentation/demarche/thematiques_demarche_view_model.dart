import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ThematiqueDemarchePageViewModel extends Equatable {
  final DisplayState displayState;
  final List<ThematiqueDemarcheItem> thematiques;
  final void Function() onRetry;

  ThematiqueDemarchePageViewModel({required this.displayState, required this.thematiques, required this.onRetry});

  factory ThematiqueDemarchePageViewModel.create(Store<AppState> store) {
    final state = store.state.thematiquesDemarcheState;
    return ThematiqueDemarchePageViewModel(
      displayState: _displayState(state),
      thematiques: _thematiques(state),
      onRetry: () => store.dispatch(RequestAction<NoRequest, List<ThematiqueDeDemarche>>(NoRequest())),
    );
  }

  @override
  List<Object?> get props => [displayState, thematiques];
}

List<ThematiqueDemarcheItem> _thematiques(State<List<ThematiqueDeDemarche>> state) {
  return state is SuccessState<List<ThematiqueDeDemarche>>
      ? state.data.map((e) => ThematiqueDemarcheItem(id: e.code, title: e.libelle)).toList()
      : <ThematiqueDemarcheItem>[];
}

DisplayState _displayState(State<List<ThematiqueDeDemarche>> state) {
  return switch (state) {
    FailureState() => DisplayState.FAILURE,
    SuccessState() => DisplayState.CONTENT,
    _ => DisplayState.LOADING,
  };
}

class ThematiqueDemarcheItem extends Equatable {
  final String id;
  final String title;

  ThematiqueDemarcheItem({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}
