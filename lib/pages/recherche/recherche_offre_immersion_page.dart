import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/immersion_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/actions_recherche_immersion_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/entreprises_accueillantes_header.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_immersion_contenu.dart';
import 'package:pass_emploi_app/widgets/tags/entreprise_accueillante_tag.dart';
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
  String appBarTitle() => Strings.rechercheOffresImmersionTitle;

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheImmersionState;

  @override
  FavoriListState<Immersion> favorisState(AppState appState) => appState.immersionFavorisState;

  @override
  Widget buildAlertBottomSheet() => ImmersionSavedSearchBottomSheet();

  @override
  Route<bool> buildFiltresMaterialPageRoute() => ImmersionFiltresPage.materialPageRoute();

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
      additionalChild: item.fromEntrepriseAccueillante ? EntrepriseAccueillanteTag() : null,
    );
    if (_shouldAddEntreprisesAccueillantesHeader(index, resultViewModel)) {
      return Column(children: [EntreprisesAccueillantesHeader(), SizedBox(height: Margins.spacing_base), card]);
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
    return resultViewModel.items.indexWhere((immersion) => immersion.fromEntrepriseAccueillante) != -1;
  }
}
