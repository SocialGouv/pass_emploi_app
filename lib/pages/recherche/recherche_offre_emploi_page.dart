import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_origin_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/actions_recherche_emploi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_alerte_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_origin.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_emploi_contenu.dart';
import 'package:redux/redux.dart';

class RechercheOffreEmploiPage extends RechercheOffrePage<OffreEmploi> {
  final bool onlyAlternance;

  RechercheOffreEmploiPage({required this.onlyAlternance});

  static MaterialPageRoute<void> materialPageRoute({required bool onlyAlternance}) {
    return MaterialPageRoute(
      builder: (context) => RechercheOffreEmploiPage(
        onlyAlternance: onlyAlternance,
      ),
    );
  }

  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheEmploiViewModel.create(store);
  }

  @override
  String? appBarTitle() {
    return onlyAlternance ? Strings.rechercheOffresAlternanceTitle : Strings.rechercheOffresEmploiTitle;
  }

  @override
  String analyticsType() {
    return onlyAlternance ? AnalyticsScreenNames.alternanceRecherche : AnalyticsScreenNames.emploiRecherche;
  }

  @override
  String placeHolderTitle() => Strings.recherchePlaceholderTitle;

  @override
  String placeHolderSubtitle() => Strings.rechercheLancerUneRechercheHint;

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheEmploiState;

  @override
  FavoriIdsState<OffreEmploi> favorisState(AppState appState) => appState.offreEmploiFavorisIdsState;

  @override
  Widget buildAlertBottomSheet() => OffreEmploiAlerteBottomSheet(onlyAlternance: onlyAlternance);

  @override
  Future<bool?>? buildFiltresBottomSheet(BuildContext context) => OffreEmploiFiltresPage.show(context, onlyAlternance);

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheEmploiContenu(
      onlyAlternance: onlyAlternance,
      onNumberOfCriteresChanged: onNumberOfCriteresChanged,
    );
  }

  @override
  Widget buildResultItem(
    BuildContext context,
    OffreEmploi item,
    int index,
    BlocResultatRechercheViewModel<OffreEmploi> resultViewModel,
  ) {
    final viewModel = OffreEmploiItemViewModel.create(item);
    return DataCard<OffreEmploi>(
      tag: viewModel.originViewModel?.toWidget(),
      titre: viewModel.title,
      sousTitre: viewModel.companyName,
      lieu: viewModel.location,
      id: viewModel.id,
      dataTag: [viewModel.contractType, viewModel.duration ?? ''],
      onTap: () => _showOffreDetailsPage(context, viewModel.id),
      from: onlyAlternance ? OffrePage.alternanceResults : OffrePage.emploiResults,
    );
  }

  void _showOffreDetailsPage(BuildContext context, String offreId) {
    Navigator.push(context, OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: onlyAlternance));
  }
}

extension on OffreEmploiOriginViewModel {
  OffreEmploiOrigin toWidget() {
    return OffreEmploiOrigin(
      label: name,
      path: imagePath,
      size: OffreEmploiOriginSize.small,
    );
  }
}