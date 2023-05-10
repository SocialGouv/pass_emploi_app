import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class SuggestionRechercheCardViewModel extends Equatable {
  final String titre;
  final String type;
  final String? source;
  final String? metier;
  final String? localisation;
  final Function() ajouterSuggestion;
  final Function() refuserSuggestion;

  SuggestionRechercheCardViewModel._({
    required this.titre,
    required this.type,
    required this.source,
    required this.metier,
    required this.localisation,
    required this.ajouterSuggestion,
    required this.refuserSuggestion,
  });

  static SuggestionRechercheCardViewModel? create(Store<AppState> store, String suggestionId) {
    final state = store.state.suggestionsRechercheState;
    if (state is! SuggestionsRechercheSuccessState) return null;

    final suggestion = state.suggestions.firstWhereOrNull((element) => element.id == suggestionId);
    if (suggestion == null) return null;

    return SuggestionRechercheCardViewModel._(
      titre: suggestion.titre,
      type: _suggestionTypeLabel(suggestion.type),
      source: _suggestionSourceLabel(suggestion.source),
      metier: suggestion.metier,
      localisation: suggestion.localisation,
      ajouterSuggestion: () =>
          store.dispatch(TraiterSuggestionRechercheRequestAction(suggestion, TraiterSuggestionType.accepter)),
      refuserSuggestion: () =>
          store.dispatch(TraiterSuggestionRechercheRequestAction(suggestion, TraiterSuggestionType.refuser)),
    );
  }

  @override
  List<Object?> get props => [titre, type, source, metier, localisation];
}

String _suggestionTypeLabel(SuggestionType type) {
  switch (type) {
    case SuggestionType.emploi:
      return Strings.suggestionTypeEmploi;
    case SuggestionType.alternance:
      return Strings.suggestionTypeAlternance;
    case SuggestionType.immersion:
      return Strings.suggestionTypeImmersion;
    case SuggestionType.civique:
      return Strings.suggestionTypeServiceCivique;
  }
}

String? _suggestionSourceLabel(SuggestionSource? source) {
  switch (source) {
    case SuggestionSource.poleEmploi:
      return Strings.suggestionSourcePoleEmploi;
    case SuggestionSource.conseiller:
      return Strings.suggestionSourceConseiller;
    default:
      return null;
  }
}
