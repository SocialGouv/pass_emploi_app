import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/presentation/entree_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_home.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';
import 'package:pass_emploi_app/widgets/entree_brsa_background.dart';
import 'package:pass_emploi_app/widgets/hidden_menu.dart';

class EntreePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.entree,
      child: StoreConnector<AppState, EntreePageViewModel>(
        onInit: (store) => store.dispatch(PreferredLoginModeRequestAction()),
        converter: (store) => EntreePageViewModel.create(store),
        distinct: true,
        builder: (context, viewModel) => _scaffold(context, viewModel),
      ),
    );
  }

  Widget _scaffold(BuildContext context, EntreePageViewModel viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          Brand.isCej() ? EntreeBiseauBackground() : EntreeBrsaBackground(),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(child: Container()),
                  HiddenMenuGesture(child: AppLogo(width: 120)),
                  SizedBox(height: Margins.spacing_m),
                  _WelcomeText(),
                  SizedBox(height: Margins.spacing_xl),
                  CardContainer(
                    padding: EdgeInsets.only(
                      left: Margins.spacing_m,
                      right: Margins.spacing_m,
                      top: Margins.spacing_m,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (viewModel.preferredLoginMode != null) _PreferredLoginMode(viewModel.preferredLoginMode!),
                        viewModel.withLoading ? Center(child: CircularProgressIndicator()) : _LoginButton(),
                        SizedBox(height: Margins.spacing_m),
                        if (viewModel.technicalErrorMessage != null) ...[
                          _GenericError(viewModel.technicalErrorMessage!),
                          SizedBox(height: Margins.spacing_m),
                        ],
                        if (viewModel.withWrongDeviceClockMessage) ...[
                          _ErrorBanner(
                            title: Strings.loginWrongDeviceClockError,
                            description: Strings.loginWrongDeviceClockErrorDescription,
                          ),
                          SizedBox(height: Margins.spacing_m),
                        ],
                        Divider(
                          height: 1,
                          color: AppColors.primaryLighten,
                        ),
                        _InformationsLegales(),
                      ],
                    ),
                  ),
                  if (viewModel.withRequestAccountButton) ...[
                    SizedBox(height: Margins.spacing_base),
                    _AskAccount(),
                  ],
                  SizedBox(height: Margins.spacing_base),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Margins.spacing_m,
      ),
      child: Column(
        children: [
          Text(Strings.welcome, style: TextStyles.textLBold(color: Colors.white), textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_base),
          Text(Strings.welcomeMessage, style: TextStyles.textSMedium(color: Colors.white), textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_m),
        ],
      ),
    );
  }
}

class _AskAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.noAccount, style: TextStyles.textSMedium(color: Colors.white), textAlign: TextAlign.center),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(
          label: Strings.askAccount,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          onPressed: () => Navigator.push(context, CejInformationPage.materialPageRoute()),
        ),
      ],
    );
  }
}

class _InformationsLegales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(Strings.legalInformation, style: TextStyles.textBaseRegular),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.topLeft,
      children: [
        Column(
          children: [
            SizedBox(height: Margins.spacing_s),
            Link(Strings.legalNoticeLabel, Strings.legalNoticeUrl),
            SizedBox(height: Margins.spacing_m),
            Link(Strings.privacyPolicyLabel, Strings.privacyPolicyUrl),
            SizedBox(height: Margins.spacing_m),
            Link(Strings.termsOfServiceLabel, Strings.termsOfServiceUrl),
            SizedBox(height: Margins.spacing_m),
            Link(Strings.accessibilityLevelLabel, Strings.accessibilityUrl),
            SizedBox(height: Margins.spacing_m),
          ],
        )
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: Strings.loginAction,
      onPressed: () => LoginBottomSheet.show(context),
    );
  }
}

class Link extends StatelessWidget {
  final String label;
  final String link;

  const Link(this.label, this.link, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          PassEmploiMatomoTracker.instance.trackOutlink(link);
          launchExternalUrl(link);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(label, style: TextStyles.internalLink),
            SizedBox(width: Margins.spacing_s),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Icon(AppIcons.open_in_new_rounded, color: AppColors.primary),
            )
          ],
        ),
      ),
    );
  }
}

class _GenericError extends StatelessWidget {
  final String technicalErrorMessage;

  const _GenericError(this.technicalErrorMessage);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _ErrorBanner(
        title: Strings.loginGenericError,
        description: Strings.loginGenericErrorDescription,
      ),
      onDoubleTap: () => showDialog(
        context: context,
        builder: (context) => _ErrorInfoDialog(technicalErrorMessage),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String title;
  final String description;

  const _ErrorBanner({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CardContainer(
        backgroundColor: AppColors.warningLighten,
        withShadow: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: TextStyles.textSBoldWithColor(AppColors.warning)),
            SizedBox(height: Margins.spacing_s),
            Text(description, style: TextStyles.textXsRegular(color: AppColors.warning)),
          ],
        ),
      ),
    );
  }
}

class _ErrorInfoDialog extends StatelessWidget {
  final String message;

  _ErrorInfoDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Erreur technique'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text(Strings.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _PreferredLoginMode extends StatelessWidget {
  const _PreferredLoginMode(this.loginMode);
  final PreferredLoginModeViewModel? loginMode;

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
