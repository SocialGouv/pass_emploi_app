import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/presentation/saved_search_card_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search_navigator_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';

class SavedSearchNavigator extends StatefulWidget {
  final Widget child;

  SavedSearchNavigator({required this.child});

  @override
  State<SavedSearchNavigator> createState() => _SavedSearchNavigatorState();
}

class _SavedSearchNavigatorState extends State<SavedSearchNavigator> {
  bool _shouldNavigate = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchNavigatorViewModel>(
      converter: (store) => SavedSearchNavigatorViewModel.create(store),
      builder: (_, __) => widget.child,
      onWillChange: _onWillChange,
      distinct: true,
    );
  }

  void _onWillChange(SavedSearchNavigatorViewModel? _, SavedSearchNavigatorViewModel? newViewModel) {
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

class SavedSearchCard extends StatelessWidget {
  final SavedSearch savedSearch;

  SavedSearchCard(this.savedSearch);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchCardViewModel>(
      converter: (store) => SavedSearchCardViewModel.create(store),
      builder: (context_, viewModel) => _Body(savedSearch, viewModel),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final SavedSearch savedSearch;
  final SavedSearchCardViewModel viewModel;

  _Body(this.savedSearch, this.viewModel);

  @override
  Widget build(BuildContext context) {
    final _savedSearch = savedSearch;
    if (_savedSearch is OffreEmploiSavedSearch) {
      return _buildEmploiAndAlternanceCard(context, _savedSearch, viewModel);
    } else if (_savedSearch is ImmersionSavedSearch) {
      return _buildImmersionCard(context, _savedSearch, viewModel);
    } else if (_savedSearch is ServiceCiviqueSavedSearch) {
      return _buildServiceCiviqueCard(context, _savedSearch, viewModel);
    } else {
      return Container();
    }
  }
}

Widget _buildEmploiAndAlternanceCard(
  BuildContext context,
  OffreEmploiSavedSearch offreEmploi,
  SavedSearchCardViewModel viewModel,
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
  SavedSearchCardViewModel viewModel,
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
  SavedSearchCardViewModel viewModel,
) {
  return FavoriCard(
    solutionType: SolutionType.ServiceCivique,
    title: savedSearchsServiceCivique.titre,
    place: savedSearchsServiceCivique.ville?.isNotEmpty == true ? savedSearchsServiceCivique.ville : null,
    bottomTip: Strings.voirResultatsSuggestion,
    onTap: () => viewModel.fetchSavedSearchResult(savedSearchsServiceCivique),
  );
}
