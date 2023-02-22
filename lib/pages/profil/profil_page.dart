import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/pages/diagoriente/diagoriente_entry_page.dart';
import 'package:pass_emploi_app/pages/partage_activite_page.dart';
import 'package:pass_emploi_app/pages/profil/matomo_logging_page.dart';
import 'package:pass_emploi_app/pages/suppression_compte_page.dart';
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
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/rating_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/profil/mon_conseiller_card.dart';
import 'package:pass_emploi_app/widgets/cards/profil/profil_card.dart';
import 'package:pass_emploi_app/widgets/cards/profil/standalone_profil_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/label_value_row.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

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
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: Strings.menuProfil, withProfileButton: false, backgroundColor: backgroundColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UsernameTitle(userName: viewModel.userName, onTitleTap: viewModel.onTitleTap),
              SizedBox(height: Margins.spacing_m),
              PrimaryActionButton(
                label: 'TODO Diagorente',
                onPressed: () => Navigator.push(context, DiagorienteEntryPage.materialPageRoute()),
              ),
              SizedBox(height: Margins.spacing_m),
              _ProfileCard(userEmail: viewModel.userEmail),
              SizedBox(height: Margins.spacing_m),
              if (viewModel.displayMonConseiller) MonConseillerCard(),
              Text(Strings.settingsLabel, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              _SuppressionAccountCard(),
              _ActivityShareCard(),
              Text(Strings.legalInformation, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              _LegalInformationCard(),
              SizedBox(height: Margins.spacing_m),
              Text(Strings.helpTitle, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              _RatingCard(),
              SizedBox(height: Margins.spacing_m),
              if (viewModel.displayDeveloperOptions) ...[
                Text(Strings.developerOptions, style: TextStyles.textLBold()),
                SizedBox(height: Margins.spacing_m),
                _MatomoCard(),
              ],
              SecondaryButton(
                onPressed: () => StoreProvider.of<AppState>(context).dispatch(RequestLogoutAction()),
                label: Strings.logoutAction,
              ),
            ],
          ),
        ),
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
      child: Text(userName, style: TextStyles.textLBold()),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String userEmail;

  _ProfileCard({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return ProfilCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.personalInformation, style: TextStyles.textMBold),
          SizedBox(height: Margins.spacing_m),
          LabelValueRow(
            label: Text(Strings.emailAddressLabel, style: TextStyles.textBaseRegular),
            value: Text(
              userEmail,
              style: TextStyles.textBaseBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
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
    return ProfilCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () => _launchAndTrackExternalLink(Strings.legalNoticeUrl),
                child: Padding(
                  padding: const EdgeInsets.all(Margins.spacing_base),
                  child: LabelValueRow(
                    label: Text(Strings.legalNoticeLabel, style: TextStyles.textBaseRegular),
                    value: _redirectIcon(),
                  ),
                ),
              ),
              SepLine(0, 0, color: AppColors.grey100),
              InkWell(
                onTap: () => _launchAndTrackExternalLink(Strings.termsOfServiceUrl),
                child: Padding(
                  padding: const EdgeInsets.all(Margins.spacing_base),
                  child: LabelValueRow(
                    label: Text(Strings.termsOfServiceLabel, style: TextStyles.textBaseRegular),
                    value: _redirectIcon(),
                  ),
                ),
              ),
              SepLine(0, 0, color: AppColors.grey100),
              InkWell(
                onTap: () => _launchAndTrackExternalLink(Strings.privacyPolicyUrl),
                child: Padding(
                  padding: const EdgeInsets.all(Margins.spacing_base),
                  child: LabelValueRow(
                    label: Text(Strings.privacyPolicyLabel, style: TextStyles.textBaseRegular),
                    value: _redirectIcon(),
                  ),
                ),
              ),
              SepLine(0, 0, color: AppColors.grey100),
              InkWell(
                onTap: () => _launchAndTrackExternalLink(Strings.accessibilityUrl),
                child: Padding(
                  padding: const EdgeInsets.all(Margins.spacing_base),
                  child: LabelValueRow(
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Strings.accessibilityLevelLabel, style: TextStyles.textBaseRegular),
                        Text(
                          Strings.accessibilityLevelNonConforme,
                          style: TextStyles.textBaseBold,
                        )
                      ],
                    ),
                    value: _redirectIcon(),
                  ),
                ),
              ),
            ],
          ),
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

class _RatingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StandaloneProfilCard(
      text: Strings.ratingAppLabel,
      onTap: () => showPassEmploiBottomSheet(context: context, builder: (context) => RatingBottomSheet()),
    );
  }
}
