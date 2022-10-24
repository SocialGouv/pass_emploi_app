import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class VoirSuggestionsRechercheViewModel extends Equatable {
  final bool hasSuggestionsRecherche;

  VoirSuggestionsRechercheViewModel._({
    required this.hasSuggestionsRecherche,
  });

  factory VoirSuggestionsRechercheViewModel.create(Store<AppState> store) {
    return VoirSuggestionsRechercheViewModel._(
      hasSuggestionsRecherche: _hasSuggestionsRecherche(store.state.suggestionsRechercheState),
    );
  }

  @override
  List<Object?> get props => [hasSuggestionsRecherche];
}

bool _hasSuggestionsRecherche(SuggestionsRechercheState suggestionsRechercheState) {
  return (suggestionsRechercheState is SuggestionsRechercheSuccessState &&
      suggestionsRechercheState.suggestions.isNotEmpty);
}
