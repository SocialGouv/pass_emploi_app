import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:redux/redux.dart';

abstract class DerniersMotsClesAutocompleteItem extends Equatable {}

class DerniersMotsClesAutocompleteTitleItem extends DerniersMotsClesAutocompleteItem {
  final String title;

  DerniersMotsClesAutocompleteTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class DerniersMotsClesAutocompleteSuggestionItem extends DerniersMotsClesAutocompleteItem {
  final String text;

  DerniersMotsClesAutocompleteSuggestionItem(this.text);

  @override
  List<Object?> get props => [text];
}

class DerniersMotsClesViewModel extends Equatable {
  final List<DerniersMotsClesAutocompleteItem> derniersMotsCles;

  DerniersMotsClesViewModel({required this.derniersMotsCles});

  factory DerniersMotsClesViewModel.create(Store<AppState> store) {
    return DerniersMotsClesViewModel(
      derniersMotsCles: _derniersMotsCles(_mots(store)),
    );
  }

  @override
  List<Object?> get props => [derniersMotsCles];
}

List<String> _mots(Store<AppState> store) {
  return store.state.recherchesRecentesState.recentSearches
      .whereType<OffreEmploiSavedSearch>()
      .map((offre) => offre.keyword)
      .whereNotNull()
      .whereNot((offre) => offre.isEmpty)
      .distinct()
      .take(3)
      .toList();
}

List<DerniersMotsClesAutocompleteItem> _derniersMotsCles(List<String> motCles) {
  if (motCles.isEmpty) return [];
  final title = motCles.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    DerniersMotsClesAutocompleteTitleItem(title),
    ...motCles.map((e) => DerniersMotsClesAutocompleteSuggestionItem(e)),
  ];
}

//TODO: adapter les tests de recherches recentes
//TODO: supprimer l'ancienne boucle redux "mots clés"
