import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/entree_background.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';

class LoginPage extends TraceableStatelessWidget {
  LoginPage() : super(name: AnalyticsScreenNames.login);

  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.create(store),
      distinct: true,
      builder: (context, viewModel) => _content(viewModel, context),
    );
  }

  Scaffold _content(LoginViewModel viewModel, BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          EntreeBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 64,
                  ),
                  SvgPicture.asset(
                    Drawables.passEmploiLogo,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                        Text("Je suis suivi par un conseiller...",
                            style: TextStyles.textBaseBold, textAlign: TextAlign.center),
                        SizedBox(height: Margins.spacing_m),
                        _body(viewModel, context),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Margins.spacing_m, 0, Margins.spacing_m, Margins.spacing_m),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Text("Vous n’avez pas de compte pass emploi ?",
                                style: TextStyles.textBaseRegular.copyWith(color: Colors.white))),
                        SizedBox(height: 16),
                        SecondaryButton(label: "Demander un compte pass emploi", onPressed: () {}),
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
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      case DisplayState.FAILURE:
        return _failure(viewModel, context);
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [..._loginButtons(viewModel, context)],
        );
    }
  }

  Column _failure(LoginViewModel viewModel, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(Strings.loginError, style: TextStyles.textSmMedium(color: AppColors.warning))),
        SizedBox(height: Margins.spacing_base),
        ..._loginButtons(viewModel, context),
      ],
    );
  }

  List<Widget> _loginButtons(LoginViewModel viewModel, BuildContext context) {
    final buttonsWithSpaces = viewModel.loginButtons.expand(
      (e) => [
        _loginButton(e, context),
        SizedBox(height: Margins.spacing_base),
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
}
