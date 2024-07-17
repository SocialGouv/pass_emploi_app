import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/actions_recherche_immersion_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_alerte_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_immersion_contenu.dart';
import 'package:redux/redux.dart';

class RechercheOffreImmersionPage extends RechercheOffrePage<Immersion> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffreImmersionPage());
  }

  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheImmersionViewModel.create(store);
  }

  @override
  String? appBarTitle() => Strings.rechercheOffresImmersionTitle;

  @override
  String analyticsType() => AnalyticsScreenNames.immersionRecherche;

  @override
  String placeHolderTitle() => Strings.recherchePlaceholderTitle;

  @override
  String placeHolderSubtitle() => Strings.rechercheLancerUneRechercheHint;

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheImmersionState;

  @override
  FavoriIdsState<Immersion> favorisState(AppState appState) => appState.immersionFavorisIdsState;

  @override
  Widget buildAlertBottomSheet() => ImmersionAlerteBottomSheet();

  @override
  Future<bool?>? buildFiltresBottomSheet(BuildContext context) => ImmersionFiltresPage.show(context);

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheImmersionContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  @override
  Widget buildResultItem(
    BuildContext context,
    Immersion item,
    int index,
    BlocResultatRechercheViewModel<Immersion> resultViewModel,
  ) {
    final card = DataCard<Immersion>(
      titre: item.metier,
      sousTitre: item.nomEtablissement,
      lieu: item.ville,
      dataTag: [item.secteurActivite],
      onTap: () => _showOffreDetailsPage(context, item.id),
      from: OffrePage.immersionResults,
      id: item.id,
      additionalChild: item.fromEntrepriseAccueillante ? CardTag.entrepriseAccueillante() : null,
    );
    if (_shouldAddEntreprisesAccueillantesHeader(index, resultViewModel)) {
      return Column(children: [
        InfoCard(message: Strings.entreprisesAccueillantesHeader),
        SizedBox(height: Margins.spacing_base),
        card,
      ]);
    } else {
      return card;
    }
  }

  void _showOffreDetailsPage(BuildContext context, String offreId) {
    Navigator.push(
      context,
      ImmersionDetailsPage.materialPageRoute(offreId),
    );
  }

  bool _shouldAddEntreprisesAccueillantesHeader(int index, BlocResultatRechercheViewModel<Immersion> resultViewModel) {
    if (index != 0) return false;
    return resultViewModel.items.any((immersion) => immersion.fromEntrepriseAccueillante);
  }
}
