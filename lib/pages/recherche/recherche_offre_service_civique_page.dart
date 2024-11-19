import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_filtres_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/service_civique/actions_recherche_service_civique_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/service_civique_alerte_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_service_civique_contenu.dart';
import 'package:redux/redux.dart';

class RechercheOffreServiceCiviquePage extends RechercheOffrePage<ServiceCivique> {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffreServiceCiviquePage());
  }

  @override
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheServiceCiviqueViewModel.create(store);
  }

  @override
  String? appBarTitle() => Strings.rechercheOffresServiceCiviqueTitle;

  @override
  String analyticsType() => AnalyticsScreenNames.serviceCiviqueRecherche;

  @override
  String placeHolderTitle() => Strings.recherchePlaceholderTitle;

  @override
  String placeHolderSubtitle() => Strings.rechercheLancerUneRechercheHint;

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheServiceCiviqueState;

  @override
  FavoriIdsState<ServiceCivique> favorisState(AppState appState) => appState.serviceCiviqueFavorisIdsState;

  @override
  Widget buildAlertBottomSheet() => ServiceCiviqueAlerteBottomSheet();

  @override
  Future<bool?>? buildFiltresBottomSheet(BuildContext context) => ServiceCiviqueFiltresPage.show(context);

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheServiceCiviqueContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  @override
  Widget buildResultItem(
    BuildContext context,
    ServiceCivique item,
    int index,
    BlocResultatRechercheViewModel<ServiceCivique> resultViewModel,
  ) {
    return DataCard<ServiceCivique>(
      titre: item.title,
      category: Domaine.fromTag(item.domain)?.titre,
      sousTitre: item.companyName,
      lieu: item.location,
      id: item.id,
      date: item.startDate?.toDateTimeUtcOnLocalTimeZone().toDayWithFullMonth(),
      from: OffrePage.serviceCiviqueResults,
      onTap: () => _showOffreDetailsPage(context, item.id),
    );
  }

  void _showOffreDetailsPage(BuildContext context, String offreId) {
    Navigator.push(
      context,
      ServiceCiviqueDetailPage.materialPageRoute(offreId),
    );
  }
}
