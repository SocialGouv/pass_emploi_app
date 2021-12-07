import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LoginPage extends TraceableStatelessWidget {
  LoginPage() : super(name: AnalyticsScreenNames.login);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.create(store),
      distinct: true,
      builder: (context, viewModel) => Scaffold(body: _body(viewModel)),
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

  ClipRRect _loginButton(LoginViewModel viewModel) {
    return ClipRRect(
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
