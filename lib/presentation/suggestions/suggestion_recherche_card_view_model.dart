import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class SuggestionRechercheCardViewModel extends Equatable {
  final String titre;
  final OffreType type;
  final String? source;
  final String? metier;
  final String? localisation;
  final bool withLocationForm;
  final Function({Location? location, double? rayon}) ajouterSuggestion;
  final Function() refuserSuggestion;

  SuggestionRechercheCardViewModel._({
    required this.titre,
    required this.type,
    required this.source,
    required this.metier,
    required this.localisation,
    required this.withLocationForm,
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
      type: suggestion.type,
      source: _suggestionSourceLabel(suggestion.source),
      metier: suggestion.metier,
      localisation: suggestion.localisation,
      withLocationForm: suggestion.source == SuggestionSource.diagoriente,
      ajouterSuggestion: ({location, rayon}) {
        return store.dispatch(
          TraiterSuggestionRechercheRequestAction(
            suggestion,
            TraiterSuggestionType.accepter,
            location: location,
            rayon: rayon,
          ),
        );
      },
      refuserSuggestion: () {
        return store.dispatch(TraiterSuggestionRechercheRequestAction(suggestion, TraiterSuggestionType.refuser));
      },
    );
  }

  @override
  List<Object?> get props => [titre, type, source, metier, localisation, withLocationForm];
}

String? _suggestionSourceLabel(SuggestionSource? source) {
  switch (source) {
    case SuggestionSource.poleEmploi:
      return Strings.suggestionSourcePoleEmploi;
    case SuggestionSource.conseiller:
      return Strings.suggestionSourceConseiller;
    case SuggestionSource.diagoriente:
      return Strings.suggestionSourceDiagoriente;
    default:
      return null;
  }
}
