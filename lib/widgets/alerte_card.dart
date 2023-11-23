import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/presentation/alerte_card_view_model.dart';
import 'package:pass_emploi_app/presentation/alerte_navigator_view_model.dart';
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
    return StoreConnectorAware<AlerteNavigatorViewModel>(
      converter: (store) => AlerteNavigatorViewModel.create(store),
      builder: (_, __) => widget.child,
      onWillChange: _onWillChange,
      distinct: true,
    );
  }

  void _onWillChange(AlerteNavigatorViewModel? _, AlerteNavigatorViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    final Widget? page = switch (newViewModel.searchNavigationState) {
      AlerteNavigationState.OFFRE_EMPLOI => RechercheOffreEmploiPage(onlyAlternance: false),
      AlerteNavigationState.OFFRE_ALTERNANCE => RechercheOffreEmploiPage(onlyAlternance: true),
      AlerteNavigationState.OFFRE_IMMERSION => RechercheOffreImmersionPage(),
      AlerteNavigationState.SERVICE_CIVIQUE => RechercheOffreServiceCiviquePage(),
      AlerteNavigationState.NONE => null,
    };
    if (page != null) {
      _shouldNavigate = false;
      Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
    }
  }
}

class AlerteCard extends StatelessWidget {
  final Alerte alerte;

  AlerteCard(this.alerte);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AlerteCardViewModel>(
      converter: (store) => AlerteCardViewModel.create(store),
      builder: (context_, viewModel) => _Body(alerte, viewModel),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final Alerte alerte;
  final AlerteCardViewModel viewModel;

  _Body(this.alerte, this.viewModel);

  @override
  Widget build(BuildContext context) {
    final alerteCast = alerte;
    return switch (alerteCast) {
      OffreEmploiAlerte() => _buildEmploiAndAlternanceCard(alerteCast, viewModel),
      ImmersionAlerte() => _buildImmersionCard(alerteCast, viewModel),
      ServiceCiviqueAlerte() => _buildServiceCiviqueCard(alerteCast, viewModel),
      _ => Container(),
    };
  }
}

Widget _buildEmploiAndAlternanceCard(OffreEmploiAlerte alerte, AlerteCardViewModel viewModel) {
  final location = alerte.location?.libelle;
  return BaseCard(
    tag: alerte.onlyAlternance ? CardTag.alternance() : CardTag.emploi(),
    title: alerte.title,
    complements: location != null ? [CardComplement.place(text: location)] : null,
    onTap: () => viewModel.fetchAlerteResult(alerte),
  );
}

Widget _buildImmersionCard(ImmersionAlerte alerte, AlerteCardViewModel viewModel) {
  return BaseCard(
    tag: CardTag.immersion(),
    title: alerte.title,
    complements: [CardComplement.place(text: alerte.ville)],
    onTap: () => viewModel.fetchAlerteResult(alerte),
  );
}

Widget _buildServiceCiviqueCard(ServiceCiviqueAlerte alerte, AlerteCardViewModel viewModel) {
  return BaseCard(
    tag: CardTag.serviceCivique(),
    title: alerte.titre,
    complements: alerte.ville?.isNotEmpty == true ? [CardComplement.place(text: alerte.ville!)] : null,
    onTap: () => viewModel.fetchAlerteResult(alerte),
  );
}
