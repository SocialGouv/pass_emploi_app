import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/login_bottom_sheet/login_bottom_sheet_home.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';

class LoginPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.login,
      child: StoreConnector<AppState, LoginViewModel>(
        converter: (store) => LoginViewModel.create(store),
        distinct: true,
        onWillChange: (oldVm, newVm) => _onWillChange(oldVm, newVm, context),
        builder: (context, viewModel) => _Scaffold(viewModel, _Body(viewModel)),
      ),
    );
  }

  void _onWillChange(LoginViewModel? previousVM, LoginViewModel newVM, BuildContext context) {
    if (previousVM?.withLoading != false) return;
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
  final LoginViewModel viewModel;
  final Widget body;

  const _Scaffold(this.viewModel, this.body);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          EntreeBiseauBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Margins.spacing_l),
                  AppLogo(width: 200),
                  SizedBox(height: Margins.spacing_l),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
                    padding: EdgeInsets.all(Margins.spacing_m),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(viewModel.suiviText, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
                        SizedBox(height: Margins.spacing_m),
                        if (viewModel.withLoading) Center(child: CircularProgressIndicator()),
                        if (!viewModel.withLoading) body,
                      ],
                    ),
                  ),
                  SizedBox(height: Margins.spacing_base),
                  if (viewModel.withAskAccountButton) _AskAccountButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final LoginViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        SizedBox(height: Margins.spacing_base),
        PrimaryActionButton(
          label: "Login",
          onPressed: () => LoginBottomSheet.show(context),
        ),
      ],
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

class _AskAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Margins.spacing_m, 0, Margins.spacing_m, Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              Strings.dontHaveAccount,
              style: TextStyles.textBaseRegular.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          SecondaryButton(
            label: Strings.askAccount,
            onPressed: () => Navigator.push(context, CejInformationPage.materialPageRoute()),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
