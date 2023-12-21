import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
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
        builder: (context, viewModel) => _content(viewModel, context),
      ),
    );
  }

  Scaffold _content(LoginViewModel viewModel, BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          EntreeBiseauBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 32),
                  AppLogo(width: 200),
                  SizedBox(height: 32),
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
                        _body(viewModel, context),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  if (viewModel.withAskAccountButton)
                    Padding(
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
                          SizedBox(height: 16),
                          SecondaryButton(
                            label: Strings.askAccount,
                            onPressed: () => Navigator.push(context, CejInformationPage.materialPageRoute()),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(LoginViewModel viewModel, BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.chargement => Center(child: CircularProgressIndicator()),
      DisplayState.erreur => _failure(viewModel, context),
      _ => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [..._loginButtons(viewModel, context)],
        )
    };
  }

  Widget _failure(LoginViewModel viewModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(Strings.loginError, style: TextStyles.textSMedium(color: AppColors.warning))),
        SizedBox(height: Margins.spacing_base),
        ..._loginButtons(viewModel, context),
      ],
    );
  }

  List<Widget> _loginButtons(LoginViewModel viewModel, BuildContext context) {
    final buttonsWithSpaces = viewModel.loginButtons.expandIndexed(
      (index, vm) => [
        _loginButton(vm, context),
        SizedBox(height: Margins.spacing_base),
        if (index < viewModel.loginButtons.length - 1) ...[
          OrSeperator(),
          SizedBox(height: Margins.spacing_base),
        ]
      ],
    );
    return buttonsWithSpaces.toList();
  }

  Widget _loginButton(LoginButtonViewModel viewModel, BuildContext context) {
    return PrimaryActionButton(
      label: viewModel.label,
      onPressed: viewModel.action,
      backgroundColor: viewModel.backgroundColor,
    );
  }

  void _onWillChange(LoginViewModel? previousVM, LoginViewModel newVM, BuildContext context) {
    if (previousVM?.displayState != DisplayState.chargement) return;
    if (newVM.displayState == DisplayState.erreur) _trackLoginResult(successful: false);
    if (newVM.displayState == DisplayState.contenu) {
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

class OrSeperator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: Margins.spacing_l),
        Expanded(child: Divider(color: AppColors.grey500)),
        SizedBox(width: Margins.spacing_base),
        Text(Strings.or, style: TextStyles.textBaseBold),
        SizedBox(width: Margins.spacing_base),
        Expanded(child: Divider(color: AppColors.grey500)),
        SizedBox(width: Margins.spacing_l),
      ],
    );
  }
}
