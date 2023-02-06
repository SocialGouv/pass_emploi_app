import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/actions_recherche_emploi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/recherche/actions_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/bloc_criteres_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/bloc_resultat_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_emploi_contenu.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche_contenu.dart';
import 'package:redux/redux.dart';

abstract class RechercheOffrePage<Result> extends StatefulWidget {
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store);

  String appBarTitle();

  RechercheState rechercheState(AppState appState);

  FavoriListState<Result> favorisState(AppState appState);

  Widget buildAlertBottomSheet();

  Route<bool> buildFiltresMaterialPageRoute();

  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged});

  Widget buildResultItem(BuildContext context, Result item);

  @override
  State<RechercheOffrePage<Result>> createState() => _RechercheOffrePageState();
}

class _RechercheOffrePageState<Result> extends State<RechercheOffrePage<Result>> {
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
      appBar: SecondaryAppBar(title: widget.appBarTitle(), backgroundColor: backgroundColor),
      floatingActionButton: ActionsRecherche(
        buildViewModel: widget.buildActionsRechercheViewModel,
        buildAlertBottomSheet: widget.buildAlertBottomSheet,
        buildFiltresMaterialPageRoute: widget.buildFiltresMaterialPageRoute,
        onFiltreApplied: _onFiltreApplied,
      ),
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
            BlocCriteresRecherche<Result>(
              rechercheState: widget.rechercheState,
              buildCriteresContentWidget: widget.buildCriteresContentWidget,
            ),
            BlocResultatRecherche<Result>(
              listResultatKey: _listResultatKey,
              rechercheState: widget.rechercheState,
              favorisState: widget.favorisState,
              buildResultItem: widget.buildResultItem,
            ),
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
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store) {
    return ActionsRechercheEmploiViewModel.create(store);
  }

  @override
  String appBarTitle() => Strings.rechercheOffresEmploiTitle;

  @override
  RechercheState rechercheState(AppState appState) => appState.rechercheEmploiState;

  @override
  FavoriListState<OffreEmploi> favorisState(AppState appState) => appState.offreEmploiFavorisState;

  @override
  Widget buildAlertBottomSheet() {
    // TODO-1353 only alternance
    return OffreEmploiSavedSearchBottomSheet(onlyAlternance: false);
  }

  @override
  Route<bool> buildFiltresMaterialPageRoute() {
    // TODO-1353 only alternance
    return OffreEmploiFiltresPage.materialPageRoute(false);
  }

  @override
  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged}) {
    return CriteresRechercheEmploiContenu(onNumberOfCriteresChanged: onNumberOfCriteresChanged);
  }

  @override
  Widget buildResultItem(BuildContext context, OffreEmploi item) {
    final viewModel = OffreEmploiItemViewModel.create(item);
    return DataCard<OffreEmploi>(
      titre: viewModel.title,
      sousTitre: viewModel.companyName,
      lieu: viewModel.location,
      id: viewModel.id,
      dataTag: [viewModel.contractType, viewModel.duration ?? ''],
      onTap: () => _showOffreEmploiDetailsPage(context, viewModel.id),
      from: OffrePage.emploiResults, // TODO: 1353 - only alternance
      //from: widget.onlyAlternance ? OffrePage.alternanceResults : OffrePage.emploiResults,
    );
  }

  void _showOffreEmploiDetailsPage(BuildContext context, String offreId) {
    Navigator.push(
      context,
      // TODO: 1353 - only alternance
      //OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: widget.onlyAlternance),
      OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: false),
    );
  }
}
