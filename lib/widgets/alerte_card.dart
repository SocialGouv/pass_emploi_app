import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/presentation/saved_search_card_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search_navigator_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_connector_aware.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';

class AlerteNavigator extends StatefulWidget {
  final Widget child;

  AlerteNavigator({required this.child});

  @override
  State<AlerteNavigator> createState() => _AlerteNavigatorState();
}

class _AlerteNavigatorState extends State<AlerteNavigator> {
  bool _shouldNavigate = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnectorAware<SavedSearchNavigatorViewModel>(
      converter: (store) => SavedSearchNavigatorViewModel.create(store),
      builder: (_, __) => widget.child,
      onWillChange: _onWillChange,
      distinct: true,
    );
  }

  void _onWillChange(SavedSearchNavigatorViewModel? _, SavedSearchNavigatorViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    final Widget? page = switch (newViewModel.searchNavigationState) {
      SavedSearchNavigationState.OFFRE_EMPLOI => RechercheOffreEmploiPage(onlyAlternance: false),
      SavedSearchNavigationState.OFFRE_ALTERNANCE => RechercheOffreEmploiPage(onlyAlternance: true),
      SavedSearchNavigationState.OFFRE_IMMERSION => RechercheOffreImmersionPage(),
      SavedSearchNavigationState.SERVICE_CIVIQUE => RechercheOffreServiceCiviquePage(),
      SavedSearchNavigationState.NONE => null,
    };
    if (page != null) {
      _shouldNavigate = false;
      Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
    }
  }
}

class AlerteCard extends StatelessWidget {
  final SavedSearch savedSearch;

  AlerteCard(this.savedSearch);

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
  final SavedSearch alerte;
  final SavedSearchCardViewModel viewModel;

  _Body(this.alerte, this.viewModel);

  @override
  Widget build(BuildContext context) {
    final _alerte = alerte;
    return switch (_alerte) {
      OffreEmploiSavedSearch() => _buildEmploiAndAlternanceCard(_alerte, viewModel),
      ImmersionSavedSearch() => _buildImmersionCard(_alerte, viewModel),
      ServiceCiviqueSavedSearch() => _buildServiceCiviqueCard(_alerte, viewModel),
      _ => Container(),
    };
  }
}

Widget _buildEmploiAndAlternanceCard(OffreEmploiSavedSearch alerte, SavedSearchCardViewModel viewModel) {
  final location = alerte.location?.libelle;
  return BaseCard(
    tag: alerte.onlyAlternance ? CardTag.alternance() : CardTag.emploi(),
    title: alerte.title,
    complements: location != null ? [CardComplement.place(text: location)] : null,
    onTap: () => viewModel.fetchSavedSearchResult(alerte),
  );
}

Widget _buildImmersionCard(ImmersionSavedSearch alerte, SavedSearchCardViewModel viewModel) {
  return BaseCard(
    tag: CardTag.immersion(),
    title: alerte.title,
    complements: [CardComplement.place(text: alerte.ville)],
    onTap: () => viewModel.fetchSavedSearchResult(alerte),
  );
}

Widget _buildServiceCiviqueCard(ServiceCiviqueSavedSearch alerte, SavedSearchCardViewModel viewModel) {
  return BaseCard(
    tag: CardTag.serviceCivique(),
    title: alerte.titre,
    complements: alerte.ville?.isNotEmpty == true ? [CardComplement.place(text: alerte.ville!)] : null,
    onTap: () => viewModel.fetchSavedSearchResult(alerte),
  );
}
