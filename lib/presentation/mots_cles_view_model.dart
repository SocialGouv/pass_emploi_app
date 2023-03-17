import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

//TODO: fetch métiers favoris
//TODO: modifier backend pour avoir le champs codeRome sur la route diagoriente (àlaplace de "rome" tout court)

class MotsClesViewModel extends Equatable {
  final List<MotsClesItem> motsCles;

  MotsClesViewModel({required this.motsCles});

  factory MotsClesViewModel.create(Store<AppState> store) {
    return MotsClesViewModel(
      motsCles: _motsClesItems(store),
    );
  }

  @override
  List<Object?> get props => [motsCles];
}

abstract class MotsClesItem extends Equatable {}

class MotsClesTitleItem extends MotsClesItem {
  final String title;

  MotsClesTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class MotsClesSuggestionItem extends MotsClesItem {
  final String text;

  MotsClesSuggestionItem(this.text);

  @override
  List<Object?> get props => [text];
}

List<MotsClesItem> _motsClesItems(Store<AppState> store) {
  return _motsClesFavorisItems(store) + _derniersMotsClesItems(store);
}

List<MotsClesItem> _motsClesFavorisItems(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is! DiagorientePreferencesMetierSuccessState || state.metiersFavoris.isEmpty) return [];
  return [
    MotsClesTitleItem(Strings.vosPreferencesMetiers),
    ...state.metiersFavoris //
        .map((e) => e.libelle)
        .toList()
        .sortedAlphabetically()
        .map((e) => MotsClesSuggestionItem(e)),
  ];
}

List<MotsClesItem> _derniersMotsClesItems(Store<AppState> store) {
  final motCles = _derniersMotsCles(store);
  if (motCles.isEmpty) return [];
  final title = motCles.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    MotsClesTitleItem(title),
    ...motCles.map((e) => MotsClesSuggestionItem(e)),
  ];
}

List<String> _derniersMotsCles(Store<AppState> store) {
  return store.state.recherchesRecentesState.recentSearches
      .whereType<OffreEmploiSavedSearch>()
      .map((offre) => offre.keyword)
      .whereNotNull()
      .whereNot((keyword) => keyword.isEmpty)
      .distinct()
      .take(3)
      .toList();
}
