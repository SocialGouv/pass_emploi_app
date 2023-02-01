import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/recherche/actions_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche.dart';
import 'package:redux/redux.dart';

class RechercheOffrePage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffrePage());
  }

  @override
  State<RechercheOffrePage> createState() => _RechercheOffrePageState();
}

class _RechercheOffrePageState extends State<RechercheOffrePage> {
  Store<AppState>? _store;

  @override
  void dispose() {
    _store?.dispatch(RechercheResetAction<OffreEmploi>());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _store = StoreProvider.of<AppState>(context);
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CriteresRecherche(),
                ResultatRecherche(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ActionsRecherche(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
