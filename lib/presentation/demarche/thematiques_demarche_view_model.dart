import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
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
      onRetry: () => store.dispatch(ThematiqueDemarcheRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, thematiques];
}

List<ThematiqueDemarcheItem> _thematiques(ThematiqueDemarcheState state) {
  if (state is ThematiqueDemarcheSuccessState) {
    return state.thematiques
        .where((e) => e.demarches.isNotEmpty)
        .map((e) => ThematiqueDemarcheItem(id: e.code, title: e.libelle))
        .toList();
  } else {
    return <ThematiqueDemarcheItem>[];
  }
}

DisplayState _displayState(ThematiqueDemarcheState state) {
  return switch (state) {
    ThematiqueDemarcheFailureState() => DisplayState.FAILURE,
    ThematiqueDemarcheSuccessState() => DisplayState.CONTENT,
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
