import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:redux/redux.dart';

class MetierViewModel extends Equatable {
  final List<Metier> metiers;
  final List<DerniersMetiersAutocompleteItem> derniersMetiers;
  final Function(String? input) onInputMetier;

  MetierViewModel._({
    required this.metiers,
    required this.derniersMetiers,
    required this.onInputMetier,
  });

  factory MetierViewModel.create(Store<AppState> store) {
    return MetierViewModel._(
      metiers: store.state.searchMetierState.metiers,
      derniersMetiers: _derniersMetiers(_metiers(store)),
      onInputMetier: (input) => store.dispatch(SearchMetierRequestAction(input)),
    );
  }

  @override
  List<Object?> get props => [metiers, derniersMetiers];
}

abstract class DerniersMetiersAutocompleteItem extends Equatable {}

class DerniersMetiersAutocompleteTitleItem extends DerniersMetiersAutocompleteItem {
  final String title;

  DerniersMetiersAutocompleteTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class DerniersMetiersAutocompleteSuggestionItem extends DerniersMetiersAutocompleteItem {
  final Metier metier;

  DerniersMetiersAutocompleteSuggestionItem(this.metier);

  @override
  List<Object?> get props => [metier];
}

List<DerniersMetiersAutocompleteItem> _derniersMetiers(List<Metier> metiers) {
  if (metiers.isEmpty) return [];
  final title = metiers.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    DerniersMetiersAutocompleteTitleItem(title),
    ...metiers.map((e) => DerniersMetiersAutocompleteSuggestionItem(e)),
  ];
}

List<Metier> _metiers(Store<AppState> store) {
  return store.state.recherchesRecentesState.recentSearches
      .whereType<ImmersionSavedSearch>()
      .map((offre) => Metier(codeRome: offre.codeRome, libelle: offre.metier))
      .distinct()
      .take(3)
      .toList();
}
