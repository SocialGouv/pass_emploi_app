import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:redux/redux.dart';

class MetierViewModel extends Equatable {
  final List<MetiersAutocompleteItem> metiers;
  final List<MetiersAutocompleteItem> derniersMetiers;
  final Function(String? input) onInputMetier;

  MetierViewModel._({
    required this.metiers,
    required this.derniersMetiers,
    required this.onInputMetier,
  });

  factory MetierViewModel.create(Store<AppState> store) {
    return MetierViewModel._(
      metiers: _metiersAutocompleteItems(store),
      derniersMetiers: _derniersMetiersAutocompleteItems(_derniersMetiers(store)),
      onInputMetier: (input) => store.dispatch(SearchMetierRequestAction(input)),
    );
  }

  List<MetiersAutocompleteItem> getAutocompleteItems(bool emptyInput) => emptyInput ? derniersMetiers : metiers;

  @override
  List<Object?> get props => [metiers, derniersMetiers];
}

abstract class MetiersAutocompleteItem extends Equatable {}

class MetiersAutocompleteTitleItem extends MetiersAutocompleteItem {
  final String title;

  MetiersAutocompleteTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class MetiersAutocompleteSuggestionItem extends MetiersAutocompleteItem {
  final Metier metier;
  final bool fromDerniersMetiers;

  MetiersAutocompleteSuggestionItem(this.metier, {this.fromDerniersMetiers = false});

  @override
  List<Object?> get props => [metier, fromDerniersMetiers];
}

List<MetiersAutocompleteItem> _metiersAutocompleteItems(Store<AppState> store) {
  return store.state.searchMetierState.metiers.map((e) => MetiersAutocompleteSuggestionItem(e)).toList();
}

List<MetiersAutocompleteItem> _derniersMetiersAutocompleteItems(List<Metier> metiers) {
  if (metiers.isEmpty) return [];
  final title = metiers.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    MetiersAutocompleteTitleItem(title),
    ...metiers.map((e) => MetiersAutocompleteSuggestionItem(e, fromDerniersMetiers: true)),
  ];
}

List<Metier> _derniersMetiers(Store<AppState> store) {
  return store.state.recherchesRecentesState.recentSearches
      .whereType<ImmersionSavedSearch>()
      .map((offre) => Metier(codeRome: offre.codeRome, libelle: offre.metier))
      .distinct()
      .take(3)
      .toList();
}
