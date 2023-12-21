import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class FavoriListViewModel extends Equatable {
  final DisplayState displayState;
  final List<Favori> favoris;
  final Function onRetry;

  FavoriListViewModel({
    required this.displayState,
    required this.favoris,
    required this.onRetry,
  });

  static FavoriListViewModel create(Store<AppState> store) {
    return FavoriListViewModel(
      displayState: _displayState(store),
      favoris: _favoris(store),
      onRetry: () => store.dispatch(FavoriListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, favoris];

  List<Favori> getOffresEmploi() => _getFavoriFiltered(OffreType.emploi);

  List<Favori> getOffresAlternance() => _getFavoriFiltered(OffreType.alternance);

  List<Favori> getOffresImmersion() => _getFavoriFiltered(OffreType.immersion);

  List<Favori> getOffresServiceCivique() => _getFavoriFiltered(OffreType.serviceCivique);

  List<Favori> _getFavoriFiltered(OffreType type) => favoris.where((favori) => favori.type == type).toList();
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.favoriListState;
  if (state is FavoriListLoadingState) return DisplayState.chargement;
  if (state is FavoriListSuccessState && state.results.isNotEmpty) return DisplayState.contenu;
  if (state is FavoriListSuccessState && state.results.isEmpty) return DisplayState.vide;
  return DisplayState.erreur;
}

List<Favori> _favoris(Store<AppState> store) {
  final state = store.state.favoriListState;
  return state is FavoriListSuccessState ? state.results : [];
}
