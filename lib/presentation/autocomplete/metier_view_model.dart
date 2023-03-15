import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:redux/redux.dart';

class MetierViewModel extends Equatable {
  final List<MetiersItem> metiers;
  final List<MetiersItem> derniersMetiers;
  final Function(String? input) onInputMetier;

  MetierViewModel._({
    required this.metiers,
    required this.derniersMetiers,
    required this.onInputMetier,
  });

  factory MetierViewModel.create(Store<AppState> store) {
    return MetierViewModel._(
      metiers: _metiersItems(store),
      derniersMetiers: _derniersMetiersItems(_derniersMetiers(store)),
      onInputMetier: (input) => store.dispatch(SearchMetierRequestAction(input)),
    );
  }

  List<MetiersItem> getAutocompleteItems(bool emptyInput) => emptyInput ? derniersMetiers : metiers;

  @override
  List<Object?> get props => [metiers, derniersMetiers];
}

abstract class MetiersItem extends Equatable {}

enum MetierSource { autocomplete, derniersMetiers }

class MetiersTitleItem extends MetiersItem {
  final String title;

  MetiersTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class MetiersSuggestionItem extends MetiersItem {
  final Metier metier;
  final MetierSource source;

  MetiersSuggestionItem(this.metier, this.source);

  @override
  List<Object?> get props => [metier, source];
}

List<MetiersItem> _metiersItems(Store<AppState> store) {
  return store.state.searchMetierState.metiers.map((e) => MetiersSuggestionItem(e, MetierSource.autocomplete)).toList();
}

List<MetiersItem> _derniersMetiersItems(List<Metier> metiers) {
  if (metiers.isEmpty) return [];
  final title = metiers.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    MetiersTitleItem(title),
    ...metiers.map((e) => MetiersSuggestionItem(e, MetierSource.derniersMetiers)),
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
