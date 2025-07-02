import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_alertes.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_campagne_recrutement.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_cette_semaine.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_evenements.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_loading.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_onboarding_tile.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_outils.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_prochain_rendezvous.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_rating_app.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_suivi_des_offres.dart';
import 'package:pass_emploi_app/pages/accueil/remote_campagne_accueil_card.dart';
import 'package:pass_emploi_app/pages/alerte_page.dart';
import 'package:pass_emploi_app/pages/benevolat_page.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_details_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_form_page.dart';
import 'package:pass_emploi_app/pages/la_bonne_alternance_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/notifications_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/information_bandeau.dart';
import 'package:pass_emploi_app/widgets/offre_suivie_form.dart';
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
        onInit: (store) {
          store.dispatch(AccueilRequestAction());
          store.dispatch(InAppNotificationsRequestAction());
          store.dispatch(DateConsultationNotificationRequestAction());
        },
        converter: (store) => AccueilViewModel.create(store),
        builder: _builder,
        onDidChange: (previousViewModel, viewModel) {
          _handleNotificationsBottomSheet(viewModel);
          _handleDeeplink(previousViewModel, viewModel);
        },
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, AccueilViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: ConnectivityContainer(
        child: _Body(viewModel),
      ),
    );
  }

  Future<void> _handleDeeplink(AccueilViewModel? oldViewModel, AccueilViewModel newViewModel) async {
    if (newViewModel.deepLink is RappelCreationDemarcheDeepLink) {
      await _handleRappelCreationDemarcheDeeplink();
    } else if (newViewModel.deepLink is RappelCreationActionDeepLink) {
      await _handleRappelCreationActionDeeplink();
    } else {
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
        BenevolatDeepLink() => BenevolatPage.materialPageRoute(),
        LaBonneAlternanceDeepLink() => LaBonneAlternancePage.materialPageRoute(),
        CampagneDeepLink() => CampagneDetailsPage.materialPageRoute(),
        _ => null,
      };

      if (route != null) Navigator.push(context, route);
      if (newViewModel.shouldResetDeeplink) newViewModel.resetDeeplink();
    }
  }

  Future<void> _handleRappelCreationDemarcheDeeplink() async {
    // Displaying of MonSuivi page is required if user wants to display details of created demarche.
    await _displayMonSuiviPage();
    if (mounted) Navigator.push(context, CreateDemarcheFormPage.route());
  }

  Future<void> _handleRappelCreationActionDeeplink() async {
    // As context is not available anymore in callback, navigator needs to be instantiated here.
    final navigator = Navigator.of(context);
    // Displaying of MonSuivi page is required if user wants to display details of created action.
    await _displayMonSuiviPage();
    CreateUserActionFormPage.pushUserActionCreationTunnel(navigator, UserActionStateSource.monSuivi);
  }

  dynamic _displayMonSuiviPage() {
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(MonSuiviDeepLink(), DeepLinkOrigin.inAppNavigation),
    );
  }

  void _handleNotificationsBottomSheet(AccueilViewModel viewModel) {
    final context = this.context;
    if (viewModel.shouldShowAllowNotifications && !_onboardingShown) {
      _onboardingShown = true;
      NotificationsBottomSheet.show(context);
    }
  }
}

class _Body extends StatelessWidget {
  final AccueilViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PrimarySliverAppbar(
          title: Strings.accueilAppBarTitle,
          withNewNotifications: viewModel.withNewNotifications,
        ),
        SliverToBoxAdapter(
          child: AnimatedSwitcher(
            duration: AnimationDurations.fast,
            child: switch (viewModel.displayState) {
              DisplayState.LOADING => AccueilLoading(),
              DisplayState.CONTENT => _Blocs(viewModel),
              DisplayState.EMPTY || DisplayState.FAILURE => Retry(Strings.accueilError, () => viewModel.retry()),
            },
          ),
        ),
      ],
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
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(Margins.spacing_base),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.gradientPrimary,
                ),
              ),
              child: Column(
                children: _buildItemsWithGradient(),
              ),
            ),
            SizedBox(height: Margins.spacing_m),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
              child: Column(
                children: _buildItemsWithoutGradient(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemsWithGradient() {
    final items = <Widget>[];

    for (int i = 0; i < viewModel.items.length; i++) {
      final item = viewModel.items[i];

      if (item is AccueilCetteSemaineItem) {
        items.add(_buildItem(item));
        items.add(SizedBox(height: Margins.spacing_m));
        break;
      }

      items.add(_buildItem(item));
      if (i < viewModel.items.length - 1) {
        items.add(SizedBox(height: Margins.spacing_m));
      }
    }

    return items;
  }

  List<Widget> _buildItemsWithoutGradient() {
    final items = <Widget>[];
    bool foundCetteSemaine = false;

    for (int i = 0; i < viewModel.items.length; i++) {
      final item = viewModel.items[i];

      if (item is AccueilCetteSemaineItem) {
        foundCetteSemaine = true;
        continue;
      }

      if (foundCetteSemaine) {
        items.add(_buildItem(item));
        if (i < viewModel.items.length - 1) {
          items.add(SizedBox(height: Margins.spacing_m));
        }
      }
    }

    return items;
  }

  Widget _buildItem(AccueilItem item) {
    return switch (item) {
      final ErrorDegradeeItem item => InformationBandeau(icon: AppIcons.error_rounded, text: item.message),
      final OnboardingItem item => AccueilOnboardingTile(item),
      final OffreSuivieAccueilItem item => OffreSuivieForm(
          offreId: item.offreId,
          showOffreDetails: true,
          trackingSource: OffreSuiviTrackingSource.accueil,
        ),
      final RemoteCampagneAccueilItem item => RemoteCampagneAccueilCard(item),
      final CampagneRecrutementItem item => CampagneRecrutementCard(item),
      final CampagneEvaluationItem item => _CampagneCard(title: item.titre, description: item.description),
      final AccueilCetteSemaineItem item => AccueilCetteSemaine(item),
      final AccueilProchainRendezvousItem item => AccueilProchainRendezVous.fromRendezVous(item.rendezvousId),
      final AccueilProchaineSessionMiloItem item => AccueilProchainRendezVous.fromSession(item.sessionId),
      final AccueilEvenementsItem item => AccueilEvenements(item),
      final AccueilAlertesItem item => AccueilAlertes(item),
      final AccueilSuiviDesOffresItem item => AccueilSuiviDesOffres(item),
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
