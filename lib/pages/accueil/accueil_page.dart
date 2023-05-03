import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_alertes.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_cette_semaine.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_evenements.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_favoris.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_outils.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_prochain_rendezvous.dart';
import 'package:pass_emploi_app/pages/offre_favoris_tab_page.dart';
import 'package:pass_emploi_app/pages/saved_search_tab_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_alertes_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_cette_semaine_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_evenements_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_favoris_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_outils_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_prochain_rendezvous_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
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
        builder: (context, viewModel) => _scaffold(context, viewModel),
        onDidChange: (previousViewModel, viewModel) => _handleDeeplink(context, previousViewModel, viewModel),
        distinct: true,
      ),
    );
  }

  void _handleDeeplink(BuildContext context, AccueilViewModel? oldViewModel, AccueilViewModel newViewModel) {
    final deepLinkState = newViewModel.deepLinkState;
    if (deepLinkState is FavorisDeepLinkState) {
      Navigator.push(context, OffreFavorisTabPage.materialPageRoute());
    } else if (deepLinkState is SavedSearchesDeepLinkState) {
      Navigator.push(context, SavedSearchTabPage.materialPageRoute());
    } else {
      return;
    }
    newViewModel.resetDeeplink();
  }

  Scaffold _scaffold(BuildContext context, AccueilViewModel viewModel) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: Strings.accueilAppBarTitle, backgroundColor: backgroundColor),
      body: SafeArea(
        child: _Body(viewModel),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      case DisplayState.CONTENT:
        return _Blocs(viewModel);
      case DisplayState.EMPTY:
      case DisplayState.FAILURE:
        return _Retry(viewModel: viewModel);
    }
  }
}

class _Blocs extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Blocs(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_base),
      itemCount: viewModel.items.length,
      itemBuilder: _itemBuilder,
      separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_m),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = viewModel.items[index];
    if (item is AccueilCetteSemaineItem) return AccueilCetteSemaine(item);
    if (item is AccueilProchainRendezvousItem) return AccueilProchainRendezVous(item);
    if (item is AccueilEvenementsItem) return AccueilEvenements(item);
    if (item is AccueilAlertesItem) return AccueilAlertes(item);
    if (item is AccueilFavorisItem) return AccueilFavoris(item);
    if (item is AccueilOutilsItem) return AccueilOutils(item);
    return SizedBox.shrink();
  }
}

class _Retry extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Retry({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Retry(Strings.agendaError, () => viewModel.retry()),
    ));
  }
}
