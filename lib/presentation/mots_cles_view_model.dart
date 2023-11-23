import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

class MotsClesViewModel extends Equatable {
  final List<MotsClesItem> motsCles;
  final bool containsDiagorienteFavoris;
  final bool containsMotsClesRecents;

  MotsClesViewModel({
    required this.motsCles,
    required this.containsDiagorienteFavoris,
    required this.containsMotsClesRecents,
  });

  factory MotsClesViewModel.create(Store<AppState> store) {
    final motsClesFromDiagoriente = _motsClesFromDiagoriente(store);
    final motsClesFromRechercheRecentes = _motsClesFromRechercheRecentes(store);
    final motsCles = motsClesFromRechercheRecentes + motsClesFromDiagoriente;
    return MotsClesViewModel(
      motsCles: motsCles,
      containsDiagorienteFavoris: motsClesFromDiagoriente.isNotEmpty,
      containsMotsClesRecents: motsClesFromRechercheRecentes.isNotEmpty,
    );
  }

  @override
  List<Object?> get props => [motsCles, containsDiagorienteFavoris, containsMotsClesRecents];
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
  final MotCleSource source;

  MotsClesSuggestionItem(this.text, this.source);

  @override
  List<Object?> get props => [text, source];
}

enum MotCleSource { dernieresRecherches, diagorienteMetiersFavoris }

List<MotsClesItem> _motsClesFromDiagoriente(Store<AppState> store) {
  final state = store.state.diagorientePreferencesMetierState;
  if (state is! DiagorientePreferencesMetierSuccessState || state.metiersFavoris.isEmpty) return [];
  return [
    MotsClesTitleItem(Strings.vosPreferencesMetiers),
    ...state.metiersFavoris //
        .map((e) => e.libelle)
        .toList()
        .sortedAlphabetically()
        .map((e) => MotsClesSuggestionItem(e, MotCleSource.diagorienteMetiersFavoris)),
  ];
}

List<MotsClesItem> _motsClesFromRechercheRecentes(Store<AppState> store) {
  final motCles = _derniersMotsCles(store);
  if (motCles.isEmpty) return [];
  final title = motCles.length == 1 ? Strings.derniereRecherche : Strings.dernieresRecherches;
  return [
    MotsClesTitleItem(title),
    ...motCles.map((e) => MotsClesSuggestionItem(e, MotCleSource.dernieresRecherches)),
  ];
}

List<String> _derniersMotsCles(Store<AppState> store) {
  return store.state.recherchesRecentesState.recentSearches
      .whereType<OffreEmploiAlerte>()
      .map((offre) => offre.keyword)
      .whereNotNull()
      .whereNot((keyword) => keyword.isEmpty)
      .distinct()
      .take(3)
      .toList();
}
