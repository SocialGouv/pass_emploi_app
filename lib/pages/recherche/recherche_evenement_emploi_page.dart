import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/evenement_emploi/actions_recherche_evenement_emploi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_evenement_emploi_contenu.dart';
import 'package:redux/redux.dart';

class RechercheEvenementEmploiPage extends RechercheOffrePage<Rendezvous> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheEvenementEmploiPage());
  }

  RechercheEvenementEmploiPage();

  static Widget withPrimaryAppBar() {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: Strings.eventAppBarTitle, backgroundColor: backgroundColor),
      body: RechercheEvenementEmploiPage(),
    );
  }

  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheEvenementEmploiViewModel.create(store);
  }

  @override
  String? appBarTitle() => null;

  //TODO: analytics
  @override
  String analyticsType() => "evenements_externes";

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheEvenementEmploiState;

  @override
  FavoriIdsState<Rendezvous> favorisState(AppState appState) => FavoriIdsState<Rendezvous>.notInitialized();

  @override
  Widget buildAlertBottomSheet() => SizedBox.shrink();

  @override
  Route<bool>? buildFiltresMaterialPageRoute() => null;

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheEvenementEmploiContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  @override
  Widget buildResultItem(
    BuildContext context,
    Rendezvous item,
    int index,
    BlocResultatRechercheViewModel<Rendezvous> resultViewModel,
  ) {
    //TODO: nouvelle carte à créer
    return Text("todo");
  }
}
