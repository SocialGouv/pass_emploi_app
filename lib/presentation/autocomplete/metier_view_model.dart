import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

class MetierViewModel extends Equatable {
  final List<MetierItem> metiersAutocomplete;
  final List<MetierItem> metiersSuggestions;
  final bool containsDiagorienteFavoris;
  final bool containsMetiersRecents;
  final Function(String? input) onInputMetier;

  MetierViewModel._({
    required this.metiersAutocomplete,
    required this.metiersSuggestions,
    required this.containsDiagorienteFavoris,
    required this.containsMetiersRecents,
    required this.onInputMetier,
  });

  factory MetierViewModel.create(Store<AppState> store) {
    final metiersFromRecherchesRecentes = _dernierMetierItems(_derniersMetiers(store));
    final metiersFromDiagoriente = _metiersFromDiagoriente(store);
    return MetierViewModel._(
      metiersAutocomplete: _metierItems(store),
      metiersSuggestions: metiersFromRecherchesRecentes + metiersFromDiagoriente,
      containsDiagorienteFavoris: metiersFromDiagoriente.isNotEmpty,
      containsMetiersRecents: metiersFromRecherchesRecentes.isNotEmpty,
      onInputMetier: (input) => store.dispatch(SearchMetierRequestAction(input)),
    );
  }

  List<MetierItem> getAutocompleteItems(bool emptyInput) => emptyInput ? metiersSuggestions : metiersAutocomplete;

  @override
  List<Object?> get props => [
        metiersAutocomplete,
        metiersSuggestions,
        containsDiagorienteFavoris,
        containsMetiersRecents,
      ];
}

abstract class MetierItem extends Equatable {}

enum MetierSource { autocomplete, dernieresRecherches, diagorienteMetiersFavoris }

class MetierTitleItem extends MetierItem {
  final String title;

  MetierTitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class MetierSuggestionItem extends MetierItem {
  final Metier metier;
  final MetierSource source;

  MetierSuggestionItem(this.metier, this.source);

  @override
  List<Object?> get props => [metier, source];
}

List<MetierItem> _metierItems(Store<AppState> store) {
  return store.state.searchMetierState.metiers.map((e) => MetierSuggestionItem(e, MetierSource.autocomplete)).toList();
}

List<MetierItem> _dernierMetierItems(List<Metier> metiers) {
  if (metiers.isEmpty) return [];
  final title = metiers.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    MetierTitleItem(title),
    ...metiers.map((e) => MetierSuggestionItem(e, MetierSource.dernieresRecherches)),
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

List<MetierItem> _metiersFromDiagoriente(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is! DiagorientePreferencesMetierSuccessState || state.metiersFavoris.isEmpty) return [];
  return [
    MetierTitleItem(Strings.vosPreferencesMetiers),
    ...state.metiersFavoris //
        .sorted((a, b) => compareStringSortedAlphabetically(a.libelle, b.libelle))
        .map((e) => MetierSuggestionItem(e, MetierSource.diagorienteMetiersFavoris)),
  ];
}
