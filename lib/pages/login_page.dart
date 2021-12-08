import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LoginPage extends TraceableStatelessWidget {
  LoginPage() : super(name: AnalyticsScreenNames.login);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.create(store),
      distinct: true,
      builder: (context, viewModel) => _content(viewModel),
    );
  }

  Scaffold _content(LoginViewModel viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.lightBlue, AppColors.lightPurple],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SvgPicture.asset(Drawables.icLogo, width: 145, semanticsLabel: Strings.logoTextDescription),
              ),
              Expanded(
                child: Container(
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
                      Text(Strings.performLogin, style: TextStyles.textMdMedium, textAlign: TextAlign.center),
                      SizedBox(height: 16),
                      _body(viewModel),
                    ],
                  ),
                ),
              ),
              Flexible(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body(LoginViewModel viewModel) {
    switch (viewModel.displayState) {
      case LoginViewModelDisplayState.LOADER:
        return Center(child: CircularProgressIndicator());
      case LoginViewModelDisplayState.FAILURE:
        return _failure(viewModel);
      default:
        return Center(child: _loginButton(viewModel));
    }
  }

  Widget _loginButton(LoginViewModel viewModel) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          child: InkWell(
            onTap: () => viewModel.onLoginAction(),
            child: Container(
              height: 56,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(Strings.login, style: TextStyles.textSmMedium(color: Colors.white))],
                ),
              ),
            ),
          ),
          color: AppColors.nightBlue,
        ),
      ),
    );
  }

  Column _failure(LoginViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Strings.loginError, style: TextStyles.textSmMedium(color: AppColors.errorRed)),
        SizedBox(height: 8),
        _loginButton(viewModel),
      ],
    );
  }
}
