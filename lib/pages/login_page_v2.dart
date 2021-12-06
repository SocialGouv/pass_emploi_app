import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/login_view_model_v2.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

// TODO-115 : add loader and failure
class LoginPageV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModelV2>(
      converter: (store) => LoginViewModelV2.create(store),
      distinct: true,
      builder: (context, viewModel) => Scaffold(
        body: Center(child: _loginButton(viewModel)),
      ),
    );
  }

  ClipRRect _loginButton(LoginViewModelV2 viewModel) {
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
                children: [
                  Text(Strings.login, style: TextStyles.textSmMedium(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        color: AppColors.nightBlue,
      ),
    );
  }
}
