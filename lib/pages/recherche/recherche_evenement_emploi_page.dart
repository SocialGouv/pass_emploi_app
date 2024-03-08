import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/pages/evenement_emploi/evenement_emploi_filtres_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/evenement_emploi/actions_recherche_evenement_emploi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/evenement_emploi_card.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_evenement_emploi_contenu.dart';
import 'package:redux/redux.dart';

class RechercheEvenementEmploiPage extends RechercheOffrePage<EvenementEmploi> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheEvenementEmploiPage());
  }

  RechercheEvenementEmploiPage();

  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheEvenementEmploiViewModel.create(store);
  }

  @override
  String? appBarTitle() => null;

  @override
  String analyticsType() => AnalyticsScreenNames.evenementEmploiRecherche;

  @override
  String placeHolderTitle() => Strings.eventPlaceholderTitle;

  @override
  String placeHolderSubtitle() => Strings.eventPlaceholderSubtitle;

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheEvenementEmploiState;

  @override
  FavoriIdsState<EvenementEmploi> favorisState(AppState appState) => FavoriIdsState<EvenementEmploi>.notInitialized();

  @override
  Widget buildAlertBottomSheet() => SizedBox.shrink();

  @override
  Future<bool?>? buildFiltresBottomSheet(BuildContext context) => EvenementEmploiFiltresPage.show(context);

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheEvenementEmploiContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  @override
  Widget buildResultItem(
    BuildContext context,
    EvenementEmploi item,
    int index,
    BlocResultatRechercheViewModel<EvenementEmploi> resultViewModel,
  ) {
    final viewModel = EvenementEmploiItemViewModel.create(item);
    return EvenementEmploiCard(viewModel);
  }
}
