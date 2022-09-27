import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheListViewModel extends Equatable {
  final List<SuggestionRecherche> suggestions;

  SuggestionsRechercheListViewModel._(this.suggestions);

  factory SuggestionsRechercheListViewModel.create(Store<AppState> store) {
    final state = store.state.suggestionsRechercheState;
    if (state is! SuggestionsRechercheSuccessState) {
      return SuggestionsRechercheListViewModel._([]);
    }
    return SuggestionsRechercheListViewModel._(state.suggestions);
  }

  @override
  List<Object?> get props => [suggestions];
}