import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

import 'package:pass_emploi_app/redux/app_state.dart';

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
      derniersMotsCles: _derniersMotsCles(store.state.recherchesDerniersMotsClesState.motsCles),
    );
  }

  @override
  List<Object?> get props => [derniersMotsCles];
}

List<DerniersMotsClesAutocompleteItem> _derniersMotsCles(List<String> motCles) {
  if (motCles.isEmpty) return [];
  final title = motCles.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    DerniersMotsClesAutocompleteTitleItem(title),
    ...motCles.map((e) => DerniersMotsClesAutocompleteSuggestionItem(e)),
  ];
}
