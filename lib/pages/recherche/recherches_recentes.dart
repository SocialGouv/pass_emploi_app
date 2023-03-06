import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/presentation/recherches_recentes_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';

class RecherchesRecentes extends StatefulWidget {
  const RecherchesRecentes({super.key});

  @override
  State<RecherchesRecentes> createState() => _RecherchesRecentesState();
}

class _RecherchesRecentesState extends State<RecherchesRecentes> {
  bool _shouldNavigate = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RecherchesRecentesViewModel>(
      onInit: (store) => store.dispatch(RecherchesRecentesRequestAction()),
      converter: (store) => RecherchesRecentesViewModel.create(store),
      builder: (context, viewModel) => _Body(viewModel),
      onWillChange: _onWillChange,
      distinct: true,
    );
  }

  void _onWillChange(RecherchesRecentesViewModel? _, RecherchesRecentesViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    switch (newViewModel.searchNavigationState) {
      case SavedSearchNavigationState.OFFRE_EMPLOI:
        _goToPage(RechercheOffreEmploiPage(onlyAlternance: false));
        break;
      case SavedSearchNavigationState.OFFRE_ALTERNANCE:
        _goToPage(RechercheOffreEmploiPage(onlyAlternance: true));
        break;
      case SavedSearchNavigationState.OFFRE_IMMERSION:
        _goToPage(RechercheOffreImmersionPage());
        break;
      case SavedSearchNavigationState.SERVICE_CIVIQUE:
        _goToPage(RechercheOffreServiceCiviquePage());
        break;
      case SavedSearchNavigationState.NONE:
        break;
    }
  }

  Future<bool> _goToPage(Widget page) {
    _shouldNavigate = false;
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
  }
}

class _Body extends StatelessWidget {
  final RecherchesRecentesViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    if (viewModel.rechercheRecente == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.derniereRecherche,
          style: TextStyles.textMRegular,
        ),
        SizedBox(height: Margins.spacing_base),
        _buildFavorisCard(context, viewModel),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}

Widget _buildFavorisCard(BuildContext context, RecherchesRecentesViewModel viewModel) {
  final savedSearch = viewModel.rechercheRecente;
  if (savedSearch is OffreEmploiSavedSearch) {
    return _buildEmploiAndAlternanceCard(context, savedSearch, viewModel);
  } else if (savedSearch is ImmersionSavedSearch) {
    return _buildImmersionCard(context, savedSearch, viewModel);
  } else if (savedSearch is ServiceCiviqueSavedSearch) {
    return _buildServiceCiviqueCard(context, savedSearch, viewModel);
  } else {
    return Container();
  }
}

Widget _buildEmploiAndAlternanceCard(
  BuildContext context,
  OffreEmploiSavedSearch offreEmploi,
  RecherchesRecentesViewModel viewModel,
) {
  return FavoriCard(
    solutionType: offreEmploi.onlyAlternance ? SolutionType.Alternance : SolutionType.OffreEmploi,
    title: offreEmploi.title,
    place: offreEmploi.location?.libelle,
    bottomTip: Strings.voirResultatsSuggestion,
    onTap: () => viewModel.fetchSavedSearchResult(offreEmploi),
  );
}

Widget _buildImmersionCard(
  BuildContext context,
  ImmersionSavedSearch savedSearchsImmersion,
  RecherchesRecentesViewModel viewModel,
) {
  return FavoriCard(
    solutionType: SolutionType.Immersion,
    title: savedSearchsImmersion.title,
    place: savedSearchsImmersion.ville,
    bottomTip: Strings.voirResultatsSuggestion,
    onTap: () => viewModel.fetchSavedSearchResult(savedSearchsImmersion),
  );
}

Widget _buildServiceCiviqueCard(
  BuildContext context,
  ServiceCiviqueSavedSearch savedSearchsServiceCivique,
  RecherchesRecentesViewModel viewModel,
) {
  return FavoriCard(
    solutionType: SolutionType.ServiceCivique,
    title: savedSearchsServiceCivique.titre,
    place: savedSearchsServiceCivique.ville?.isNotEmpty == true ? savedSearchsServiceCivique.ville : null,
    bottomTip: Strings.voirResultatsSuggestion,
    onTap: () => viewModel.fetchSavedSearchResult(savedSearchsServiceCivique),
  );
}
