import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class BlocCriteresRechercheViewModel<Result> extends Equatable {
  final bool isOpen;
  final Function(bool isOpen) onExpansionChanged;

  BlocCriteresRechercheViewModel({
    required this.isOpen,
    required this.onExpansionChanged,
  });

  factory BlocCriteresRechercheViewModel.create(
    Store<AppState> store,
    RechercheState Function(AppState) rechercheState,
  ) {
    return BlocCriteresRechercheViewModel(
      isOpen: _isOpen(rechercheState(store.state)),
      onExpansionChanged: (isOpen) {
        store.dispatch(isOpen ? RechercheOpenCriteresAction<Result>() : RechercheCloseCriteresAction<Result>());
      },
    );
  }

  @override
  List<Object?> get props => [isOpen];
}

bool _isOpen(RechercheState state) {
  final isOpen = [
    RechercheStatus.nouvelleRecherche,
    RechercheStatus.initialLoading,
    RechercheStatus.failure,
  ].contains(state.status);
  return isOpen;
}
