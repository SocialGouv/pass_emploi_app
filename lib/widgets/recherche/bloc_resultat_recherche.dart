import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/recherche/recherche_message_placeholder.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche_contenu.dart';

class BlocResultatRecherche extends StatelessWidget {
  final Key listResultatKey;

  BlocResultatRecherche({required this.listResultatKey});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocResultatRechercheViewModel>(
      builder: _builder,
      converter: (store) => BlocResultatRechercheViewModel.create(store),
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocResultatRechercheViewModel viewModel) {
    switch (viewModel.displayState) {
      case BlocResultatRechercheDisplayState.recherche:
        return RechercheMessagePlaceholder(Strings.rechercheLancerUneRechercheHint);
      case BlocResultatRechercheDisplayState.empty:
        return RechercheMessagePlaceholder(Strings.noContentError);
      case BlocResultatRechercheDisplayState.results:
        return ResultatRechercheContenu(key: listResultatKey, viewModel: viewModel);
    }
  }
}
