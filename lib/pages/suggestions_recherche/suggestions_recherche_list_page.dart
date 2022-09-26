import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class SuggestionsRechercheListPage extends StatelessWidget {
  SuggestionsRechercheListPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return SuggestionsRechercheListPage._();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuggestionsRechercheListViewModel>(
      builder: (context, viewModel) => _Scaffold(viewModel: viewModel),
      converter: (store) => SuggestionsRechercheListViewModel.create(store),
      distinct: true,
    );
  }
}

class _Scaffold extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _Scaffold({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(
        label: Strings.suggestionsDeRechercheTitlePage,
        context: context,
        withBackButton: true,
      ),
      body: ListView.separated(
        itemCount: viewModel.suggestions.length,
        padding: const EdgeInsets.all(Margins.spacing_s),
        separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
        itemBuilder: (context, index) {
          return _Card(suggestion: viewModel.suggestions[index]);
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final SuggestionRecherche suggestion;

  _Card({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Text(suggestion.titre);
  }
}

