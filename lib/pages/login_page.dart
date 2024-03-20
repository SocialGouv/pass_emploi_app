import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/presentation/login_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_home.dart';
import 'package:pass_emploi_app/widgets/buttons/elevated_button_tile.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';
import 'package:pass_emploi_app/widgets/hidden_menu.dart';
import 'package:pass_emploi_app/widgets/welcome.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.login,
      child: StoreConnector<AppState, LoginPageViewModel>(
        onInit: (store) => store.dispatch(PreferredLoginModeRequestAction()),
        converter: (store) => LoginPageViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel),
        onWillChange: _onWillChange,
        distinct: true,
      ),
    );
  }

  void _onWillChange(LoginPageViewModel? previousVM, LoginPageViewModel newVM) {
    final bool isAfterWebAuthPage = previousVM?.withLoading == true && newVM.withLoading == false;
    if (!isAfterWebAuthPage) return;
    if (newVM.withWrongDeviceClockMessage || newVM.technicalErrorMessage != null) {
      _trackLoginResult(successful: false);
    } else {
      _trackLoginResult(successful: true);
    }
  }

  void _trackLoginResult({required bool successful}) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.webAuthPageEventCategory,
      action: successful ? AnalyticsEventNames.webAuthPageSuccessAction : AnalyticsEventNames.webAuthPageErrorAction,
    );
  }
}

class _Scaffold extends StatelessWidget {
  final LoginPageViewModel viewModel;

  _Scaffold(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final shrink = Brand.isCej() && MediaQuery.of(context).size.height < MediaSizes.height_xs;
    return Scaffold(
      body: Stack(
        children: [
          EntreeBiseauBackground(),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopSpacer(),
                    HiddenMenuGesture(child: AppLogo(width: 120)),
                    SizedBox(height: shrink ? Margins.spacing_base : Margins.spacing_m),
                    Welcome(),
                    SizedBox(height: shrink ? 0 : Margins.spacing_xl),
                    CardContainer(
                      padding: EdgeInsets.only(
                        left: Margins.spacing_m,
                        right: Margins.spacing_m,
                        top: Margins.spacing_m,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (viewModel.preferredLoginMode != null) ...[
                            _PreferredLoginMode(viewModel.preferredLoginMode!),
                            SizedBox(height: Margins.spacing_base),
                          ],
                          _LoginButton(viewModel),
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
          ),
        ],
      ),
    );
  }
}

class _TopSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(height: _spacerHeight(context));

  double _spacerHeight(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    if (deviceHeight < MediaSizes.height_xs) return 16;
    if (deviceHeight < MediaSizes.height_s) return 50;
    if (deviceHeight < MediaSizes.height_m) return 100;
    if (deviceHeight < MediaSizes.height_l) return 150;
    return 200;
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton(this.viewModel);

  final LoginPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.withLoading) return Center(child: CircularProgressIndicator());
    return PrimaryActionButton(
      label: Strings.loginAction,
      backgroundColor: Brand.isCej() ? AppColors.primary : AppColors.primaryDarkenStrong,
      onPressed: () {
        viewModel.onLogin != null ? viewModel.onLogin!.call() : LoginBottomSheet.show(context);
        if (viewModel.preferredLoginMode != null) {
          PassEmploiMatomoTracker.instance.trackEvent(
            eventCategory: AnalyticsEventNames.loginPageLoginModeCategory,
            action: AnalyticsEventNames.loginPageLoginDefaultModeAction,
          );
        }
      },
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
      onExpansionChanged: (_) {
        Future.delayed(AnimationDurations.medium, () {
          Scrollable.of(context).position.ensureVisible(
                context.findRenderObject()!,
                duration: AnimationDurations.fast,
              );
        });
      },
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

  final PreferredLoginModeViewModel loginMode;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      onPressed: () {
        LoginBottomSheet.show(context);
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.loginPageLoginModeCategory,
          action: AnalyticsEventNames.loginPageLoginChoseModeAction,
        );
      },
      label: loginMode.title,
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(
          loginMode.logo,
          fit: BoxFit.cover,
        ),
      ),
      suffix: Icon(AppIcons.chevron_right_rounded),
    );
  }
}
