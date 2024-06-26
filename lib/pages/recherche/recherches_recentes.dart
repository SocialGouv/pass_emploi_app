import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/presentation/recherches_recentes_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/alerte_card.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

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
  final Alerte alerte;

  _Body(this.alerte);

  @override
  Widget build(BuildContext context) {
    return AlerteNavigator(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MediumSectionTitle(Strings.derniereRecherche),
          SizedBox(height: Margins.spacing_base),
          AlerteCard(alerte),
          SizedBox(height: Margins.spacing_base),
        ],
      ),
    );
  }
}
