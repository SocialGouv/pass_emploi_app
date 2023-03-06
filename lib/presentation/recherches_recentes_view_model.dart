import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RecherchesRecentesViewModel extends Equatable {
  RecherchesRecentesViewModel({this.rechercheRecente});

  final SavedSearch? rechercheRecente;

  static RecherchesRecentesViewModel create(Store<AppState> store) {
    final state = store.state.recherchesRecentesState;
    if (state is RecherchesRecentesSuccessState) {
      return RecherchesRecentesViewModel(rechercheRecente: state.recentSearches.firstOrNull);
    }
    return RecherchesRecentesViewModel();
  }

  @override
  List<Object?> get props => [rechercheRecente];
}
