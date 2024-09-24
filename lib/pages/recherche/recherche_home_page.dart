import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherches_recentes.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_home_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/textes.dart';
import 'package:pass_emploi_app/widgets/voir_suggestions_recherche_bandeau.dart';

class RechercheHomePage extends StatefulWidget {
  @override
  State<RechercheHomePage> createState() => _RechercheHomePageState();
}

class _RechercheHomePageState extends State<RechercheHomePage> {
  bool _onboardingShown = false;
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.rechercheHome,
      child: StoreConnector<AppState, RechercheHomePageViewModel>(
        converter: (store) => RechercheHomePageViewModel.create(store, releaseMode: kReleaseMode),
        builder: _builder,
        onDidChange: (_, newVm) => _handleOnboarding(newVm),
      ),
    );
  }

  void _handleOnboarding(RechercheHomePageViewModel viewModel) {
    if (viewModel.shouldShowOnboarding && !_onboardingShown) {
      _onboardingShown = true;
      OnboardingBottomSheet.show(context, source: OnboardingSource.reherche);
    }
  }

  Widget _builder(BuildContext context, RechercheHomePageViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          children: [
            RecherchesRecentes(),
            _NosOffres(offreTypes: viewModel.offreTypes),
          ],
        ),
      ),
    );
  }
}

class _NosOffres extends StatelessWidget {
  final List<OffreType> offreTypes;

  const _NosOffres({required this.offreTypes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.rechercheHomeNosOffres),
        SizedBox(height: Margins.spacing_base),
        VoirSuggestionsRechercheBandeau(
          onTapShowSuggestions: () {
            PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.rechercheSuggestionsListe);
            Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute());
          },
        ),
        SizedBox(height: Margins.spacing_base),
        if (offreTypes.contains(OffreType.emploi)) ...[
          _BlocSolution(
            title: Strings.rechercheHomeOffresEmploiTitle,
            subtitle: Strings.rechercheHomeOffresEmploiSubtitle,
            icon: AppIcons.description_rounded,
            onTap: () => Navigator.push(context, RechercheOffreEmploiPage.materialPageRoute(onlyAlternance: false)),
          ),
          SizedBox(height: Margins.spacing_base),
        ],
        if (offreTypes.contains(OffreType.alternance)) ...[
          _BlocSolution(
            title: Strings.rechercheHomeOffresAlternanceTitle,
            subtitle: Strings.rechercheHomeOffresAlternanceSubtitle,
            icon: AppIcons.signpost_rounded,
            onTap: () => Navigator.push(context, RechercheOffreEmploiPage.materialPageRoute(onlyAlternance: true)),
          ),
          SizedBox(height: Margins.spacing_base),
        ],
        if (offreTypes.contains(OffreType.immersion)) ...[
          _BlocSolution(
            title: Strings.rechercheHomeOffresImmersionTitle,
            subtitle: Strings.rechercheHomeOffresImmersionSubtitle,
            icon: AppIcons.immersion,
            onTap: () => Navigator.push(context, RechercheOffreImmersionPage.materialPageRoute()),
          ),
          SizedBox(height: Margins.spacing_base),
        ],
        if (offreTypes.contains(OffreType.serviceCivique)) ...[
          _BlocSolution(
            title: Strings.rechercheHomeOffresServiceCiviqueTitle,
            subtitle: Strings.rechercheHomeOffresServiceCiviqueSubtitle,
            icon: AppIcons.service_civique,
            onTap: () => Navigator.push(context, RechercheOffreServiceCiviquePage.materialPageRoute()),
          ),
        ],
      ],
    );
  }
}

class _BlocSolution extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() onTap;

  const _BlocSolution({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent3, size: Dimens.icon_size_m),
            SizedBox(height: Margins.spacing_s),
            Text(title, style: TextStyles.textMBold),
            SizedBox(height: Margins.spacing_m),
            Text(subtitle, style: TextStyles.textBaseRegular),
          ],
        ),
      ),
    );
  }
}
