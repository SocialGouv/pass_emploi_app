import 'package:equatable/equatable.dart';
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
import 'package:pass_emploi_app/widgets/recherche/bloc_criteres_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/bloc_resultat_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche_contenu.dart';
import 'package:redux/redux.dart';

abstract class RechercheOffrePage<Result extends Equatable> extends StatefulWidget {
  abstract final String appBarTitle;

  @override
  State<RechercheOffrePage> createState() => _RechercheOffrePageState();
}

class _RechercheOffrePageState<Result extends Equatable> extends State<RechercheOffrePage> {
  Store<AppState>? _store;
  final _listResultatKey = GlobalKey();

  @override
  void dispose() {
    _store?.dispatch(RechercheResetAction<Result>());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _store = StoreProvider.of<AppState>(context);
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: widget.appBarTitle, backgroundColor: backgroundColor),
      floatingActionButton: ActionsRecherche(onFiltreApplied: _onFiltreApplied),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //TODO: 1353 - jusqu'à ce que la complétion se fasse sur un écran à part
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(
          left: Margins.spacing_base,
          top: Margins.spacing_base,
          right: Margins.spacing_base,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocCriteresRecherche(),
            BlocResultatRecherche(listResultatKey: _listResultatKey),
          ],
        ),
      ),
    );
  }

  void _onFiltreApplied() => (_listResultatKey.currentState as ResultatRechercheContenuState?)?.scrollToTop();
}

class RechercheOffreEmploiPage extends RechercheOffrePage<OffreEmploi> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffreEmploiPage());
  }

  @override
  final String appBarTitle = Strings.rechercheOffresEmploiTitle;
}
