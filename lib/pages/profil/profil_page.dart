import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/pages/cv/cv_list_page.dart';
import 'package:pass_emploi_app/pages/diagoriente/diagoriente_entry_page.dart';
import 'package:pass_emploi_app/pages/partage_activite_page.dart';
import 'package:pass_emploi_app/pages/profil/matomo_logging_page.dart';
import 'package:pass_emploi_app/pages/suppression_compte_page.dart';
import 'package:pass_emploi_app/presentation/cvm/cvm_chat_page.dart';
import 'package:pass_emploi_app/presentation/profil/profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/cards/profil/mon_conseiller_card.dart';
import 'package:pass_emploi_app/widgets/cards/profil/profil_card.dart';
import 'package:pass_emploi_app/widgets/cards/profil/standalone_profil_card.dart';
import 'package:pass_emploi_app/widgets/contact_page.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/rating_page.dart';

class ProfilPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return ProfilPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.profil,
      child: StoreConnector<AppState, ProfilPageViewModel>(
        onInit: (store) => store.dispatch(DetailsJeuneRequestAction()),
        converter: (store) => ProfilPageViewModel.create(store),
        builder: (BuildContext context, ProfilPageViewModel vm) => _buildScaffold(context, vm),
        distinct: true,
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, ProfilPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(
        title: Strings.menuProfil,
        withProfileButton: false,
        canPop: true,
      ),
      body: Semantics(
        label: Strings.listSemanticsLabel,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UsernameTitle(userName: viewModel.userName, onTitleTap: viewModel.onTitleTap),
                SizedBox(height: Margins.spacing_m),
                _DiscoverDiagorienteCard(),
                SizedBox(height: Margins.spacing_m),
                if (viewModel.withDownloadCv) ...[
                  _CurriculumVitaeCard(),
                  SizedBox(height: Margins.spacing_m),
                ],
                SizedBox(height: Margins.spacing_m),
                _ProfileCard(userEmail: viewModel.userEmail),
                SizedBox(height: Margins.spacing_m),
                if (viewModel.displayMonConseiller) MonConseillerCard(),
                _SectionTitle(Strings.settingsLabel),
                SizedBox(height: Margins.spacing_m),
                _SuppressionAccountCard(),
                _ActivityShareCard(),
                _SectionTitle(Strings.legalInformation),
                SizedBox(height: Margins.spacing_m),
                _LegalInformationCard(),
                SizedBox(height: Margins.spacing_m),
                _SectionTitle(Strings.helpTitle),
                SizedBox(height: Margins.spacing_m),
                _RatingCard(),
                SizedBox(height: Margins.spacing_m),
                if (viewModel.displayDeveloperOptions) ...[
                  _SectionTitle(Strings.developerOptions),
                  SizedBox(height: Margins.spacing_m),
                  _MatomoCard(),
                  _CvmChatPage()
                ],
                SecondaryButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(RequestLogoutAction(LogoutReason.userLogout));
                  },
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

class _DiscoverDiagorienteCard extends StatelessWidget {
  const _DiscoverDiagorienteCard();

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.white;
    return CardContainer(
      backgroundColor: AppColors.primary,
      splashColor: AppColors.primaryDarken,
      onTap: () => Navigator.push(context, DiagorienteEntryPage.materialPageRoute()),
      child: Column(
        children: [
          Text(Strings.diagorienteDiscoverCardTitle, style: TextStyles.textMBold.copyWith(color: textColor)),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.diagorienteDiscoverCardSubtitle, style: TextStyles.textBaseRegularWithColor(textColor)),
          PressedTip(Strings.diagorienteDiscoverCardPressedTip, textColor: textColor),
        ],
      ),
    );
  }
}

class _CurriculumVitaeCard extends StatelessWidget {
  const _CurriculumVitaeCard();

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

class _ProfileCard extends StatelessWidget {
  final String userEmail;

  _ProfileCard({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: ProfilCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.personalInformation, style: TextStyles.textMBold),
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
      ),
    );
  }
}

class _SuppressionAccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StandaloneProfilCard(
      text: Strings.suppressionAccountLabel,
      onTap: () => Navigator.push(
        context,
        SuppressionComptePage.materialPageRoute(),
      ),
    );
  }
}

class _ActivityShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StandaloneProfilCard(
      text: Strings.activityShareLabel,
      onTap: () => Navigator.push(context, PartageActivitePage.materialPageRoute()),
    );
  }
}

class _LegalInformationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: Strings.listSemanticsLabel,
      child: ProfilCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              onTap: () => _launchAndTrackExternalLink(Strings.legalNoticeUrl),
              title: Text(Strings.legalNoticeLabel, style: TextStyles.textBaseRegular),
              trailing: _redirectIcon(),
            ),
            Divider(color: AppColors.grey100, height: 0),
            ListTile(
              onTap: () => _launchAndTrackExternalLink(Strings.termsOfServiceUrl),
              title: Text(Strings.termsOfServiceLabel, style: TextStyles.textBaseRegular),
              trailing: _redirectIcon(),
            ),
            Divider(color: AppColors.grey100, height: 0),
            ListTile(
              onTap: () => _launchAndTrackExternalLink(Strings.privacyPolicyUrl),
              title: Text(Strings.privacyPolicyLabel, style: TextStyles.textBaseRegular),
              trailing: _redirectIcon(),
            ),
            Divider(color: AppColors.grey100, height: 0),
            ListTile(
              onTap: () => _launchAndTrackExternalLink(Strings.accessibilityUrl),
              title: Text(Strings.accessibilityLevelLabel, style: TextStyles.textBaseRegular),
              trailing: _redirectIcon(),
              subtitle: Text(
                Strings.accessibilityLevelNonConforme,
                style: TextStyles.textBaseBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchAndTrackExternalLink(String link) {
    PassEmploiMatomoTracker.instance.trackOutlink(link);
    launchExternalUrl(link);
  }

  Widget _redirectIcon() => Icon(
        AppIcons.open_in_new_rounded,
        semanticLabel: Strings.openInNavigator,
        size: Dimens.icon_size_base,
        color: AppColors.grey800,
      );
}

class _MatomoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StandaloneProfilCard(
      text: Strings.developerOptionMatomo,
      onTap: () => Navigator.push(context, MatomoLoggingPage.materialPageRoute()),
    );
  }
}

class _CvmChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StandaloneProfilCard(
      text: Strings.developerOptionCvm,
      onTap: () => Navigator.push(context, CvmChatPage.materialPageRoute()),
    );
  }
}

class _RatingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: Strings.listSemanticsLabel,
      child: ProfilCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              onTap: () => Navigator.of(context).push(ContactPage.materialPageRoute()),
              title: Text(Strings.contactTeamLabel, style: TextStyles.textBaseRegular),
              trailing: _arrowRedirectIcon(),
            ),
            Divider(color: AppColors.grey100, height: 0),
            ListTile(
              onTap: () => Navigator.of(context).push(RatingPage.materialPageRoute()),
              title: Text(
                Strings.ratingAppLabel,
                style: TextStyles.textBaseRegular,
              ),
              trailing: _arrowRedirectIcon(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrowRedirectIcon() => Icon(
        AppIcons.chevron_right_rounded,
        semanticLabel: Strings.openInNewTab,
        color: AppColors.contentColor,
      );
}
