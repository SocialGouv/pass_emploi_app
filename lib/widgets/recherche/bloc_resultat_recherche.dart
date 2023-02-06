import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/recherche/recherche_message_placeholder.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche_contenu.dart';

class BlocResultatRecherche<Result> extends StatelessWidget {
  final Key listResultatKey;
  final RechercheState Function(AppState) rechercheState;
  final FavoriListState<Result> Function(AppState) favorisState;
  final Widget Function(BuildContext, Result) buildResultItem;

  BlocResultatRecherche({
    required this.listResultatKey,
    required this.rechercheState,
    required this.favorisState,
    required this.buildResultItem,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocResultatRechercheViewModel<Result>>(
      builder: _builder,
      converter: (store) => BlocResultatRechercheViewModel.create(store, rechercheState),
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocResultatRechercheViewModel<Result> viewModel) {
    switch (viewModel.displayState) {
      case BlocResultatRechercheDisplayState.recherche:
        return RechercheMessagePlaceholder(Strings.rechercheLancerUneRechercheHint);
      case BlocResultatRechercheDisplayState.empty:
        return RechercheMessagePlaceholder(Strings.noContentError);
      case BlocResultatRechercheDisplayState.results:
        return ResultatRechercheContenu<Result>(
          key: listResultatKey,
          viewModel: viewModel,
          favorisState: favorisState,
          buildItem: buildResultItem,
        );
    }
  }
}
