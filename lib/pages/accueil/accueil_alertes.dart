import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/pages/alerte_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/alerte_card.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilAlertes extends StatelessWidget {
  final AccueilAlertesItem item;

  AccueilAlertes(this.item);

  @override
  Widget build(BuildContext context) {
    final hasContent = item.alertes.isNotEmpty;
    return AlerteNavigator(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LargeSectionTitle(Strings.accueilMesAlertesSection),
          SizedBox(height: Margins.spacing_base),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: Strings.listSemanticsLabel,
          child: Column(
                children: item.alertes.map((search) => _AlerteCard(search)).toList(),
              ),
        ),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirMesAlertes, onPressed: () => goToAlerte(context)),
      ],
    );
  }

  void goToAlerte(BuildContext context) {
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.alerteListFromAccueil);
    Navigator.push(context, AlertePage.materialPageRoute());
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
              color: AppColors.accent2,
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
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(
        RechercheDeepLink(),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }
}

class _AlerteCard extends StatelessWidget {
  final Alerte alerte;

  _AlerteCard(this.alerte);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AlerteCard(alerte),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}
