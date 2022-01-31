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
          Column(
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(Drawables.icLogo, width: 145, semanticsLabel: Strings.logoTextDescription),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 16, right: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Strings.performLogin, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
                    SizedBox(height: Margins.spacing_base),
                    _body(viewModel, context),
                  ],
                ),
              ),
              Flexible(child: SizedBox(), flex: 1),
            ],
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
        return Column(children: [..._loginButtons(viewModel, context)]);
    }
  }

  Column _failure(LoginViewModel viewModel, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Strings.loginError, style: TextStyles.textSmMedium(color: AppColors.warning)),
        SizedBox(height: Margins.spacing_s),
        ..._loginButtons(viewModel, context),
      ],
    );
  }

  List<Widget> _loginButtons(LoginViewModel viewModel, BuildContext context) {
    final buttonsWithSpaces = viewModel.loginButtons.expand(
      (e) =>
      [
        _loginButton(e.label, e.action, context),
        SizedBox(height: Margins.spacing_base),
      ],
    );
    return buttonsWithSpaces.toList();
  }

  Widget _loginButton(String text, GestureTapCallback onTap, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          child: InkWell(
            onTap: () => onTap(),
            child: Container(
              height: 56,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 220,
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyles.textSmMedium(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          color: AppColors.nightBlue,
        ),
      ),
    );
  }
}
