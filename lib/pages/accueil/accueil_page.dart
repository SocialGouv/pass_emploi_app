import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_alertes.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_cette_semaine.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_evenements.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_favoris.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_loading.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_outils.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_prochain_rendezvous.dart';
import 'package:pass_emploi_app/pages/alerte_page.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_details_page.dart';
import 'package:pass_emploi_app/pages/offre_favoris_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.accueil,
      child: StoreConnector<AppState, AccueilViewModel>(
        onInit: (store) => store.dispatch(AccueilRequestAction()),
        converter: (store) => AccueilViewModel.create(store),
        builder: _builder,
        onDidChange: (previousViewModel, viewModel) => _handleDeeplink(context, previousViewModel, viewModel),
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, AccueilViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: Strings.accueilAppBarTitle),
      body: ConnectivityContainer(child: _Body(viewModel)),
    );
  }

  void _handleDeeplink(BuildContext context, AccueilViewModel? oldViewModel, AccueilViewModel newViewModel) {
    final deepLink = newViewModel.deepLink;
    if (deepLink is FavorisDeepLink) {
      Navigator.push(context, OffreFavorisPage.materialPageRoute());
    } else if (deepLink is AlerteDeepLink) {
      Navigator.push(context, AlertePage.materialPageRoute());
    } else if (deepLink is AlertesDeepLink) {
      Navigator.push(context, AlertePage.materialPageRoute());
    } else {
      return;
    }
    newViewModel.resetDeeplink();
  }
}

class _Body extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (viewModel.displayState) {
        DisplayState.chargement => AccueilLoading(),
        DisplayState.contenu => _Blocs(viewModel),
        DisplayState.vide || DisplayState.erreur => _Retry(viewModel: viewModel),
      },
    );
  }
}

class _Blocs extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Blocs(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => viewModel.retry(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_base),
        itemCount: viewModel.items.length,
        itemBuilder: _itemBuilder,
        separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_m),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return switch (viewModel.items[index]) {
      final AccueilCampagneItem item => _CampagneCard(title: item.titre, description: item.description),
      final AccueilCetteSemaineItem item => AccueilCetteSemaine(item),
      final AccueilProchainRendezvousItem item => AccueilProchainRendezVous.fromRendezVous(item.rendezVousId),
      final AccueilProchaineSessionMiloItem item => AccueilProchainRendezVous.fromSession(item.sessionId),
      final AccueilEvenementsItem item => AccueilEvenements(item),
      final AccueilAlertesItem item => AccueilAlertes(item),
      final AccueilFavorisItem item => AccueilFavoris(item),
      final AccueilOutilsItem item => AccueilOutils(item),
    };
  }
}

class _Retry extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Retry({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Retry(Strings.agendaError, () => viewModel.retry()),
      ),
    );
  }
}

class _CampagneCard extends StatelessWidget {
  final String title;
  final String description;

  _CampagneCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return CampagneCard(
      onTap: () {
        Navigator.push(context, CampagneDetailsPage.materialPageRoute());
      },
      titre: title,
      description: description,
    );
  }
}
