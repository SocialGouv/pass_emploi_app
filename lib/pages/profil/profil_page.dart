import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/pages/cv/cv_list_page.dart';
import 'package:pass_emploi_app/pages/diagoriente/diagoriente_entry_page.dart';
import 'package:pass_emploi_app/pages/notification_preferences_page.dart';
import 'package:pass_emploi_app/pages/partage_activite_page.dart';
import 'package:pass_emploi_app/pages/profil/matomo_logging_page.dart';
import 'package:pass_emploi_app/pages/suppression_compte_page.dart';
import 'package:pass_emploi_app/presentation/profil/profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/temp/cje_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/cards/profil/mon_conseiller_card.dart';
import 'package:pass_emploi_app/widgets/contact_page.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/in_app_feedback.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/rating_page.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class ProfilPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => ProfilPage());

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.profil,
      child: StoreConnector<AppState, ProfilPageViewModel>(
        onInit: (store) => store.dispatch(DetailsJeuneRequestAction()),
        converter: (store) => ProfilPageViewModel.create(store),
        builder: (_, vm) => _Scaffold(vm),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final ProfilPageViewModel viewModel;

  const _Scaffold(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(
        title: Strings.menuProfil,
        withProfileButton: false,
        canPop: true,
      ),
      body: Semantics(
        container: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TODO(22-11-2024): Remove after PO review
                InAppFeedback(
                  feature: 'raclette',
                  label: "Manger une raclette 🧀 avec mes collègues sur ma pause déjeuner me rend heureux.",
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.only(bottom: Margins.spacing_base),
                ),
                _UsernameTitle(userName: viewModel.userName, onTitleTap: viewModel.onTitleTap),
                SizedBox(height: Margins.spacing_base),
                if (viewModel.withCje) ...[
                  _OutilCard(
                    title: "Ma carte “jeune engagé”",
                    subtitle: "Accéder à toutes mes réductions",
                    imagePath: "assets/cje/logo.webp",
                    onTap: () => Navigator.push(context, CjePage.materialPageRoute(CjePageSource.profil)),
                  ),
                  SizedBox(height: Margins.spacing_base),
                ],
                _OutilCard(
                  title: Strings.diagorienteDiscoverCardTitle,
                  subtitle: Strings.diagorienteDiscoverCardSubtitle,
                  imagePath: Drawables.diagorienteLogo,
                  onTap: () => Navigator.push(context, DiagorienteEntryPage.materialPageRoute()),
                ),
                SizedBox(height: Margins.spacing_base),
                if (viewModel.withDownloadCv) ...[
                  _CurriculumVitaeCard(),
                  SizedBox(height: Margins.spacing_base),
                ],
                _MailCard(userEmail: viewModel.userEmail),
                SizedBox(height: Margins.spacing_base),
                if (viewModel.displayMonConseiller) MonConseillerCard(),
                _SectionTitle(Strings.settingsLabel),
                SizedBox(height: Margins.spacing_base),
                _ListTileCard(tiles: [
                  _ListTileData(
                    title: Strings.notificationsLabel,
                    onTap: () => Navigator.push(context, NotificationPreferencesPage.materialPageRoute()),
                  ),
                  _ListTileData(
                    title: Strings.suppressionAccountLabel,
                    onTap: () => Navigator.push(context, SuppressionComptePage.materialPageRoute()),
                  ),
                  _ListTileData(
                    title: Strings.activityShareLabel,
                    onTap: () => Navigator.push(context, PartageActivitePage.materialPageRoute()),
                  ),
                ]),
                SizedBox(height: Margins.spacing_m),
                _SectionTitle(Strings.legalInformation),
                SizedBox(height: Margins.spacing_base),
                _ListTileCard(
                  externalRedirect: true,
                  tiles: [
                    _ListTileData(
                      title: Strings.legalNoticeLabel,
                      onTap: () => _launchAndTrackExternalLink(Strings.legalNoticeUrl),
                    ),
                    _ListTileData(
                      title: Strings.termsOfServiceLabel,
                      onTap: () => _launchAndTrackExternalLink(Strings.termsOfServiceUrl),
                    ),
                    _ListTileData(
                      title: Strings.privacyPolicyLabel,
                      onTap: () => _launchAndTrackExternalLink(Strings.privacyPolicyUrl),
                    ),
                    _ListTileData(
                      title: Strings.accessibilityLevelLabel,
                      onTap: () => _launchAndTrackExternalLink(Strings.accessibilityUrl),
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_m),
                _SectionTitle(Strings.helpTitle),
                SizedBox(height: Margins.spacing_base),
                _ListTileCard(tiles: [
                  _ListTileData(
                    title: Strings.ratingAppLabel,
                    onTap: () => Navigator.push(context, RatingPage.materialPageRoute()),
                  ),
                  _ListTileData(
                    title: Strings.contactTeamLabel,
                    onTap: () => Navigator.push(context, ContactPage.materialPageRoute()),
                  ),
                ]),
                SizedBox(height: Margins.spacing_m),
                if (kDebugMode || viewModel.displayDeveloperOptions) ...[
                  _SectionTitle(Strings.developerOptions),
                  SizedBox(height: Margins.spacing_base),
                  _ListTileCard(tiles: [
                    _ListTileData(
                      title: Strings.developerOptionMatomo,
                      onTap: () => Navigator.push(context, MatomoLoggingPage.materialPageRoute()),
                    ),
                    _ListTileData(
                      title: Strings.developerOptionDeleteAllPrefs,
                      onTap: () {
                        context.dispatch(DeveloperOptionsDeleteAllPrefsAction());
                        showSnackBarWithSystemError(context, "Killez 💀- voire supprimer 🗑 - l'app");
                      },
                    ),
                  ]),
                  SizedBox(height: Margins.spacing_l),
                ],
                SecondaryButton(
                  onPressed: () => context.dispatch(RequestLogoutAction(LogoutReason.userLogout)),
                  label: Strings.logoutAction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(title, style: TextStyles.textLBold()),
    );
  }
}

class _OutilCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const _OutilCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: CardContainer(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(imagePath, width: 42, height: 42),
            SizedBox(width: Margins.spacing_s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.textBaseBold),
                  SizedBox(height: Margins.spacing_xs),
                  Text(subtitle, style: TextStyles.textSRegular()),
                ],
              ),
            ),
            SizedBox(width: Margins.spacing_s),
            Icon(AppIcons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _CurriculumVitaeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: () => Navigator.push(context, CvListPage.materialPageRoute()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.cvCardTitle, style: TextStyles.textMBold),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.cvCardSubtitle, style: TextStyles.textBaseRegular),
          PressedTip(Strings.cvCadCaption),
        ],
      ),
    );
  }
}

class _UsernameTitle extends StatelessWidget {
  final String userName;
  final Function() onTitleTap;

  _UsernameTitle({required this.userName, required this.onTitleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onTitleTap,
      child: _SectionTitle(userName),
    );
  }
}

class _MailCard extends StatelessWidget {
  final String userEmail;

  _MailCard({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(Strings.personalInformation, style: TextStyles.textMBold)),
          SizedBox(height: Margins.spacing_m),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(Strings.emailAddressLabel, style: TextStyles.textBaseRegular),
              Text(
                userEmail,
                textAlign: TextAlign.right,
                style: TextStyles.textBaseBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  final List<_ListTileData> tiles;
  final bool externalRedirect;

  const _ListTileCard({required this.tiles, this.externalRedirect = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: CardContainer(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: tiles
              .map(
                (data) {
                  return [
                    Semantics(
                      link: externalRedirect,
                      button: !externalRedirect,
                      child: ListTile(
                        onTap: data.onTap,
                        title: Text(data.title, style: TextStyles.textBaseRegular),
                        leading: externalRedirect
                            ? Icon(
                                AppIcons.open_in_new_rounded,
                                size: Dimens.icon_size_base,
                                color: AppColors.contentColor,
                              )
                            : null,
                        trailing: externalRedirect
                            ? SizedBox()
                            : Icon(
                                AppIcons.chevron_right_rounded,
                                size: Dimens.icon_size_m,
                                color: AppColors.contentColor,
                              ),
                      ),
                    ),
                    Divider(color: AppColors.grey100, height: 0),
                  ];
                },
              )
              .expand((e) => e)
              .toList()
            ..removeLast(),
        ),
      ),
    );
  }
}

class _ListTileData {
  final String title;
  final VoidCallback onTap;

  _ListTileData({required this.title, required this.onTap});
}

void _launchAndTrackExternalLink(String link) {
  PassEmploiMatomoTracker.instance.trackOutlink(link);
  launchExternalUrl(link);
}
