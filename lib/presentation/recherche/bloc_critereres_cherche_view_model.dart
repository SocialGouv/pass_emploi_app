import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class BlocCriteresRechercheViewModel extends Equatable {
  final bool isOpen;

  BlocCriteresRechercheViewModel(this.isOpen);

  factory BlocCriteresRechercheViewModel.create(Store<AppState> store) {
    final isOpen = [
      RechercheStatus.newSearch,
      RechercheStatus.loading,
      RechercheStatus.failure,
    ].contains(store.state.rechercheEmploiState.status);
    return BlocCriteresRechercheViewModel(isOpen);
  }

  @override
  List<Object?> get props => [isOpen];
}
