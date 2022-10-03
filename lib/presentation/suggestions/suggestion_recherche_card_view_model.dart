import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class SuggestionRechercheCardViewModel extends Equatable {
  final String type;
  final String titre;
  final String? metier;
  final String? localisation;
  final Function() ajouterSuggestion;

  SuggestionRechercheCardViewModel._({
    required this.type,
    required this.titre,
    this.metier,
    this.localisation,
    required this.ajouterSuggestion,
  });

  static SuggestionRechercheCardViewModel? create(Store<AppState> store, String suggestionId) {
    final state = store.state.suggestionsRechercheState;
    if (state is! SuggestionsRechercheSuccessState) return null;

    final suggestion = state.suggestions.firstWhereOrNull((element) => element.id == suggestionId);
    if (suggestion == null) return null;

    return SuggestionRechercheCardViewModel._(
      type: _text(suggestion.type),
      titre: suggestion.titre,
      metier: suggestion.metier,
      localisation: suggestion.localisation,
      ajouterSuggestion: () => store.dispatch(AccepterSuggestionRechercheRequestAction(suggestion)),
    );
  }

  @override
  List<Object?> get props => [type, titre, metier, localisation];
}

String _text(SuggestionType type) {
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
