import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_list_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/saved_search_card.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class AccueilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.accueil,
      child: StoreConnector<AppState, AccueilViewModel>(
        onInit: (store) => store.dispatch(AccueilRequestAction()),
        converter: (store) => AccueilViewModel.create(store),
        builder: (context, viewModel) => _scaffold(viewModel),
        distinct: true,
      ),
    );
  }

  Scaffold _scaffold(AccueilViewModel viewModel) {
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
    if (item is AccueilCetteSemaineItem) return _CetteSemaine(item);
    if (item is AccueilProchainRendezvousItem) return _ProchainRendezVous(item);
    if (item is AccueilEvenementsItem) return _Evenements(item);
    if (item is AccueilAlertesItem) return _Alertes(item);
    if (item is AccueilFavorisItem) return _Favoris(item);
    if (item is AccueilOutilsItem) return _Outils(item);
    return SizedBox.shrink();
  }
}

//TODO: move 1 file / item

class _CetteSemaine extends StatelessWidget {
  final AccueilCetteSemaineItem item;

  _CetteSemaine(this.item);

  @override
  Widget build(BuildContext context) {
    MaterialPageRoute<void> actionsDemarchesPageRoute() => item.monSuiviType == MonSuiviType.actions
        ? UserActionListPage.materialPageRoute()
        : DemarcheListPage.materialPageRoute();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilCetteSemaineSection, style: TextStyles.secondaryAppBar),
        SizedBox(height: Margins.spacing_s),
        CardContainer(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CetteSemaineRow(
                icon: Icon(AppIcons.today_rounded, color: AppColors.primary),
                text: item.rendezVous,
                addBorderRadius: true,
                onTap: () => Navigator.of(context).push(RendezvousListPage.materialPageRoute()),
              ),
              SepLine(0, 0),
              _CetteSemaineRow(
                icon: Icon(AppIcons.error_rounded, color: AppColors.warning),
                text: item.actionsDemarchesEnRetard,
                onTap: () => Navigator.of(context).push(actionsDemarchesPageRoute()),
              ),
              SepLine(0, 0),
              _CetteSemaineRow(
                icon: Icon(AppIcons.description_rounded, color: AppColors.accent1),
                text: item.actionsDemarchesARealiser,
                onTap: () => Navigator.of(context).push(actionsDemarchesPageRoute()),
              ),
              _CetteSemaineVoirDetails(
                onTap: () => StoreProvider.of<AppState>(context).dispatchAgendaDeeplink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CetteSemaineRow extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool addBorderRadius;
  final Function() onTap;

  const _CetteSemaineRow({required this.icon, required this.text, required this.onTap, this.addBorderRadius = false});

  @override
  Widget build(BuildContext context) {
    final borderRadius = addBorderRadius
        ? BorderRadius.only(
            topLeft: Radius.circular(Dimens.radius_base),
            topRight: Radius.circular(Dimens.radius_base),
          )
        : BorderRadius.zero;
    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Margins.spacing_xs, right: Margins.spacing_base),
                  child: icon,
                ),
                Expanded(
                  child: Text(text, style: TextStyles.textBaseBold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_xs),
                  child: Icon(AppIcons.chevron_right_rounded, color: AppColors.grey800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CetteSemaineVoirDetails extends StatelessWidget {
  final Function() onTap;

  const _CetteSemaineVoirDetails({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_m, horizontal: Margins.spacing_base),
      child: SecondaryButton(label: Strings.accueilVoirDetailsCetteSemaine, onPressed: onTap),
    );
  }
}

class _ProchainRendezVous extends StatelessWidget {
  final AccueilProchainRendezvousItem item;

  _ProchainRendezVous(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilRendezvousSection, style: TextStyles.secondaryAppBar),
        SizedBox(height: Margins.spacing_s),
        item.rendezVousId.rendezvousCard(
          context: context,
          stateSource: RendezvousStateSource.accueilProchainRendezvous,
          trackedEvent: EventType.RDV_DETAIL,
        ),
      ],
    );
  }
}

class _Evenements extends StatelessWidget {
  final AccueilEvenementsItem item;

  _Evenements(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilEvenementsSection, style: TextStyles.secondaryAppBar),
        SizedBox(height: Margins.spacing_s),
        ...item.evenementIds.map((id) => _EventCard(id)),
        SecondaryButton(label: Strings.accueilVoirLesEvenements, onPressed: () => {}), //TODO: navigate to events list
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final String id;

  _EventCard(this.id);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        id.rendezvousCard(
          context: context,
          stateSource: RendezvousStateSource.accueilLesEvenements,
          trackedEvent: EventType.RDV_DETAIL,
        ),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}

class _Alertes extends StatelessWidget {
  final AccueilAlertesItem item;

  _Alertes(this.item);

  @override
  Widget build(BuildContext context) {
    final hasContent = item.savedSearches.isNotEmpty;
    return SavedSearchNavigator(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.accueilMesAlertesSection, style: TextStyles.secondaryAppBar),
          SizedBox(height: Margins.spacing_s),
          if (hasContent) _AvecAlertes(item),
          if (!hasContent) _SansAlerte(),
        ],
      ),
    );
  }
}

class _AvecAlertes extends StatelessWidget {
  final AccueilAlertesItem item;

  _AvecAlertes(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...item.savedSearches.map((search) => _AlerteCard(search)),
        SecondaryButton(label: Strings.accueilVoirMesAbonnements, onPressed: () => goToSavedSearches(context)),
      ],
    );
  }

  void goToSavedSearches(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchSavedSearchesDeeplink();
  }
}

class _SansAlerte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Icon(
              AppIcons.notifications_rounded,
              color: AppColors.accent1,
              size: 40,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          Center(
            child: Text(
              Strings.accueilPasDalerteDescription,
              style: TextStyles.textBaseMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.accueilPasDalerteBouton,
            onPressed: () => goToRecherche(context),
          ),
        ],
      ),
    );
  }

  void goToRecherche(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchRechercheDeeplink();
  }
}

class _AlerteCard extends StatelessWidget {
  final SavedSearch savedSearch;

  _AlerteCard(this.savedSearch);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SavedSearchCard(savedSearch),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}

class _Favoris extends StatelessWidget {
  final AccueilFavorisItem item;

  _Favoris(this.item);

  @override
  Widget build(BuildContext context) {
    final hasContent = item.favoris.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilMesFavorisSection, style: TextStyles.secondaryAppBar),
        SizedBox(height: Margins.spacing_s),
        if (hasContent) _AvecFavoris(item),
        if (!hasContent) _SansFavori(),
      ],
    );
  }
}

class _AvecFavoris extends StatelessWidget {
  final AccueilFavorisItem item;

  _AvecFavoris(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...item.favoris.map((favori) => _FavorisCard(favori)),
        SecondaryButton(label: Strings.accueilVoirMesFavoris, onPressed: () => _goToFavoris(context)),
      ],
    );
  }

  void _goToFavoris(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchFavorisDeeplink();
  }
}

class _SansFavori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Icon(
              AppIcons.favorite_rounded,
              color: AppColors.accent1,
              size: 40,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          Center(
            child: Text(
              Strings.accueilPasDeFavorisDescription,
              style: TextStyles.textBaseMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.accueilPasDeFavorisBouton,
            onPressed: () => goToRecherche(context),
          ),
        ],
      ),
    );
  }

  void goToRecherche(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchRechercheDeeplink();
  }
}

class _FavorisCard extends StatelessWidget {
  final Favori favori;

  _FavorisCard(this.favori);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FavoriCard(
          title: favori.titre,
          company: favori.organisation,
          place: favori.localisation,
          bottomTip: Strings.voirLeDetail,
          solutionType: favori.type,
          onTap: () => _goToFavori(context, favori),
        ),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }

  MaterialPageRoute<void> _route(Favori favori) {
    switch (favori.type) {
      case SolutionType.OffreEmploi:
        return OffreEmploiDetailsPage.materialPageRoute(
          favori.id,
          fromAlternance: false,
          popPageWhenFavoriIsRemoved: true,
        );
      case SolutionType.Alternance:
        return OffreEmploiDetailsPage.materialPageRoute(
          favori.id,
          fromAlternance: true,
          popPageWhenFavoriIsRemoved: true,
        );
      case SolutionType.Immersion:
        return ImmersionDetailsPage.materialPageRoute(favori.id, popPageWhenFavoriIsRemoved: true);
      case SolutionType.ServiceCivique:
        return ServiceCiviqueDetailPage.materialPageRoute(favori.id, true);
    }
  }

  void _goToFavori(BuildContext context, Favori favori) {
    Navigator.push(context, _route(favori));
  }
}

class _Outils extends StatelessWidget {
  final AccueilOutilsItem item;

  _Outils(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Outils");
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
