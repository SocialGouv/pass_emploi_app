import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/actions_recherche_emploi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_emploi_contenu.dart';
import 'package:redux/redux.dart';

class RechercheOffreServiceCiviquePage extends RechercheOffrePage<OffreEmploi> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffreServiceCiviquePage());
  }

  //TODO(1355)
  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheEmploiViewModel.create(store);
  }

  //TODO(1355)
  @override
  String appBarTitle() => Strings.rechercheOffresEmploiTitle;

  //TODO(1355)
  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheEmploiState;

  //TODO(1355)
  @override
  FavoriListState<OffreEmploi> favorisState(AppState appState) => appState.offreEmploiFavorisState;

  //TODO(1355)
  @override
  Widget buildAlertBottomSheet() {
    return OffreEmploiSavedSearchBottomSheet(onlyAlternance: false);
  }

  //TODO(1355)
  @override
  Route<bool> buildFiltresMaterialPageRoute() {
    return OffreEmploiFiltresPage.materialPageRoute(false);
  }

  //TODO(1355)
  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheEmploiContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  //TODO(1355)
  @override
  Widget buildResultItem(BuildContext context, OffreEmploi item) {
    final viewModel = OffreEmploiItemViewModel.create(item);
    return DataCard<OffreEmploi>(
      titre: viewModel.title,
      sousTitre: viewModel.companyName,
      lieu: viewModel.location,
      id: viewModel.id,
      dataTag: [viewModel.contractType, viewModel.duration ?? ''],
      onTap: () => _showOffreDetailsPage(context, viewModel.id),
      from: OffrePage.emploiResults,
    );
  }

  //TODO(1355)
  void _showOffreDetailsPage(BuildContext context, String offreId) {
    Navigator.push(
      context,
      OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: false),
    );
  }
}
