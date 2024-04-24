import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_alertes.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_campagne_recrutement.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_cette_semaine.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_evenements.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_favoris.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_loading.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_outils.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_prochain_rendezvous.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_rating_app.dart';
import 'package:pass_emploi_app/pages/alerte_page.dart';
import 'package:pass_emploi_app/pages/benevolat_page.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_details_page.dart';
import 'package:pass_emploi_app/pages/offre_favoris_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_accueil_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_navigation_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class AccueilPage extends StatefulWidget {
  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  bool _onboardingShown = false;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.accueil,
      child: StoreConnector<AppState, AccueilViewModel>(
        onInit: (store) => store.dispatch(AccueilRequestAction()),
        converter: (store) => AccueilViewModel.create(store),
        builder: _builder,
        onDidChange: (previousViewModel, viewModel) {
          _handleOnboarding(viewModel);
          _handleDeeplink(previousViewModel, viewModel);
        },
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

  void _handleDeeplink(AccueilViewModel? oldViewModel, AccueilViewModel newViewModel) {
    final route = switch (newViewModel.deepLink) {
      final RendezvousDeepLink deeplink => RendezvousDetailsPage.materialPageRoute(
          RendezvousStateSource.noSource,
          deeplink.idRendezvous,
        ),
      final SessionMiloDeepLink deeplink => RendezvousDetailsPage.materialPageRoute(
          RendezvousStateSource.sessionMiloDetails,
          deeplink.idSessionMilo,
        ),
      final ActionDeepLink deeplink => UserActionDetailPage.materialPageRoute(
          deeplink.idAction,
          UserActionStateSource.noSource,
        ),
      AlerteDeepLink() => AlertePage.materialPageRoute(),
      AlertesDeepLink() => AlertePage.materialPageRoute(),
      FavorisDeepLink() => OffreFavorisPage.materialPageRoute(),
      BenevolatDeepLink() => BenevolatPage.materialPageRoute(),
      _ => null,
    };

    if (route != null) Navigator.push(context, route);
    if (newViewModel.shouldResetDeeplink) newViewModel.resetDeeplink();
  }

  void _handleOnboarding(AccueilViewModel newViewModel) {
    if (newViewModel.shouldShowOnboarding && !_onboardingShown) {
      _onboardingShown = true;
      OnboardingAccueilBottomSheet.show(context).then((_) => OnboardingNavigationBottomSheet.show(context));
    }
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
        DisplayState.LOADING => AccueilLoading(),
        DisplayState.CONTENT => _Blocs(viewModel),
        DisplayState.EMPTY || DisplayState.FAILURE => Retry(Strings.agendaError, () => viewModel.retry()),
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
      final CampagneRecrutementItem item => CampagneRecrutementCard(item),
      final CampagneEvaluationItem item => _CampagneCard(title: item.titre, description: item.description),
      final AccueilCetteSemaineItem item => AccueilCetteSemaine(item),
      final AccueilProchainRendezvousItem item => AccueilProchainRendezVous.fromRendezVous(item.rendezvousId),
      final AccueilProchaineSessionMiloItem item => AccueilProchainRendezVous.fromSession(item.sessionId),
      final AccueilEvenementsItem item => AccueilEvenements(item),
      final AccueilAlertesItem item => AccueilAlertes(item),
      final AccueilFavorisItem item => AccueilFavoris(item),
      final AccueilOutilsItem item => AccueilOutils(item),
      RatingAppItem() => AccueilRatingAppCard(),
    };
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
