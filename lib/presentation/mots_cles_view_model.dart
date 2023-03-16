import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:redux/redux.dart';

class MotsClesViewModel extends Equatable {
  final List<MotsClesItem> motsCles;

  MotsClesViewModel({required this.motsCles});

  factory MotsClesViewModel.create(Store<AppState> store) {
    return MotsClesViewModel(
      motsCles: _derniersMotsCles(_mots(store)),
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

List<MotsClesItem> _derniersMotsCles(List<String> motCles) {
  if (motCles.isEmpty) return [];
  final title = motCles.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    MotsClesTitleItem(title),
    ...motCles.map((e) => MotsClesSuggestionItem(e)),
  ];
}

List<String> _mots(Store<AppState> store) {
  return store.state.recherchesRecentesState.recentSearches
      .whereType<OffreEmploiSavedSearch>()
      .map((offre) => offre.keyword)
      .whereNotNull()
      .whereNot((keyword) => keyword.isEmpty)
      .distinct()
      .take(3)
      .toList();
}
