import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/presentation/recherches_recentes_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/saved_search_card.dart';

class RecherchesRecentes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RecherchesRecentesViewModel>(
      converter: (store) => RecherchesRecentesViewModel.create(store),
      builder: (context, viewModel) {
        final recherche = viewModel.rechercheRecente;
        return recherche != null ? _Body(recherche) : SizedBox.shrink();
      },
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final SavedSearch savedSearch;

  _Body(this.savedSearch);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.derniereRecherche,
          style: TextStyles.textMRegular,
        ),
        SizedBox(height: Margins.spacing_base),
        SavedSearchCard(savedSearch),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}
