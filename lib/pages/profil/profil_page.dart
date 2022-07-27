import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/pages/profil/matomo_logging_page.dart';
import 'package:pass_emploi_app/pages/suppression_compte_page.dart';
import 'package:pass_emploi_app/presentation/profil/profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/profil/mon_conseiller_card.dart';
import 'package:pass_emploi_app/widgets/cards/profil/profil_card.dart';
import 'package:pass_emploi_app/widgets/cards/profil/standalone_profil_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/label_value_row.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class ProfilPage extends StatelessWidget {
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
      appBar: passEmploiAppBar(label: Strings.menuProfil, context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UsernameTitle(userName: viewModel.userName, onTitleTap: viewModel.onTitleTap),
              SizedBox(height: Margins.spacing_m),
              _ProfileCard(userEmail: viewModel.userName),
              SizedBox(height: Margins.spacing_m),
              if (viewModel.displayMonConseiller) MonConseillerCard(),
              Text(Strings.settingsLabel, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              _SuppressionAccountCard(),
              Text(Strings.legalInformation, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              _LegalInformationCard(),
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
    MatomoTracker.trackOutlink(link);
    launchExternalUrl(link);
  }

  SvgPicture _redirectIcon() => SvgPicture.asset(
        Drawables.icRedirection,
        width: 18,
        height: 18,
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
