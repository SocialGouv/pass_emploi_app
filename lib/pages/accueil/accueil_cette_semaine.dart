import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilCetteSemaine extends StatelessWidget {
  final AccueilCetteSemaineItem item;

  AccueilCetteSemaine(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle("Cette semaine"),
        SizedBox(height: Margins.spacing_base),
        Semantics(
          label: Strings.listSemanticsLabel,
          child: CardContainer(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rendez-vous
                _CetteSemaineRow(
                  icon: Icon(AppIcons.today_rounded, color: AppColors.primary),
                  text: item.rendezVous,
                  addBorderRadius: true,
                  onTap: () => Navigator.of(context).push(RendezvousListPage.materialPageRoute()),
                ),
                SepLine(0, 0),
                // Démarches en retard
                _CetteSemaineRow(
                  icon: Icon(AppIcons.error_rounded, color: AppColors.warning),
                  text: item.actionsDemarchesEnRetard,
                  onTap: () {
                    context.trackEvent(EventType.ACTION_LISTE);
                    Navigator.of(context).push(DemarcheListPage.materialPageRoute());
                  },
                ),
                SepLine(0, 0),
                // Démarches à réaliser
                _CetteSemaineRow(
                  icon: Icon(AppIcons.description_rounded, color: AppColors.accent1),
                  text: item.actionsDemarchesARealiser,
                  onTap: () {
                    context.trackEvent(EventType.ACTION_LISTE);
                    Navigator.of(context).push(DemarcheListPage.materialPageRoute());
                  },
                ),
                SepLine(0, 0),
                _CetteSemaineRow(
                  icon: Icon(AppIcons.add_alert_rounded, color: AppColors.primary),
                  text: "Vos suggestions d'alertes",
                  onTap: () {
                    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.accueilSuggestionsListe);
                    Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute(fetchSuggestions: true));
                  },
                ),
                _CetteSemaineVoirDetails(
                  onTap: () => StoreProvider.of<AppState>(context).dispatch(
                    HandleDeepLinkAction(
                      AgendaDeepLink(),
                      DeepLinkOrigin.inAppNavigation,
                    ),
                  ),
                ),
              ],
            ),
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
