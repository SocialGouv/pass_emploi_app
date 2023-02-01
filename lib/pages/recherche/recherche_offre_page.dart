import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche.dart';

class RechercheOffrePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffrePage());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 1353 - StoreConnector juste pour le dispose, voir si à mettre dans un view model
    return StoreConnector<AppState, int>(
      builder: (_, __) {
        const backgroundColor = AppColors.grey100;
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: SecondaryAppBar(title: Strings.rechercheOffresEmploiTitle, backgroundColor: backgroundColor),
          body: Padding(
            padding: const EdgeInsets.only(
              left: Margins.spacing_base,
              top: Margins.spacing_base,
              right: Margins.spacing_base,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CriteresRecherche(),
                ResultatRecherche(),
              ],
            ),
          ),
        );
      },
      onDispose: (store) => store.dispatch(RechercheResetAction<OffreEmploi>()),
      converter: (store) => 0,
      distinct: true,
    );
  }
}
