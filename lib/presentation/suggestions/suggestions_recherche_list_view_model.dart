import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheListViewModel extends Equatable {
  final List<String> suggestionIds;

  SuggestionsRechercheListViewModel._(this.suggestionIds);

  factory SuggestionsRechercheListViewModel.create(Store<AppState> store) {
    final state = store.state.suggestionsRechercheState;
    if (state is! SuggestionsRechercheSuccessState) {
      return SuggestionsRechercheListViewModel._([]);
    }
    final ids = state.suggestions.map((e) => e.id).toList();
    return SuggestionsRechercheListViewModel._(ids);
  }

  @override
  List<Object?> get props => [suggestionIds];
}