import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _accessCode;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      converter: (store) => LoginViewModel.create(store),
      builder: (context, viewModel) => Scaffold(
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Stack(
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
                        Expanded(child: SvgPicture.asset("assets/ic_logo.svg", semanticsLabel: 'Logo Pass Emploi')),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 28),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40, right: 40),
                                  child: Text(
                                    "Connecte-toi",
                                    style: TextStyles.textMdMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                                  child: TextFormField(
                                    style: TextStyles.textSmMedium(color: AppColors.nightBlue),
                                    keyboardType: TextInputType.name,
                                    textCapitalization: TextCapitalization.words,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Ton code d\'accès doit être renseigné';
                                      return null;
                                    },
                                    onChanged: (String? value) => _accessCode = value,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
                                      labelText: 'Code d\'accès',
                                      labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                if (viewModel.withFailure)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      "Erreur lors de la connexion",
                                      style: TextStyles.textSmMedium(color: AppColors.errorRed),
                                    ),
                                  ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                                  child: viewModel.withLoading ? _loginButtonLoading() : _loginButton(viewModel),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ClipRRect _loginButton(LoginViewModel viewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              viewModel.onLoginAction(_accessCode!);
            }
          },
          child: Container(
            height: 56,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Connexion', style: TextStyles.textSmMedium(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        color: AppColors.nightBlue,
      ),
    );
  }

  ClipRRect _loginButtonLoading() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 56,
        color: AppColors.bluePurple,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Se connecter', style: TextStyles.textSmMedium(color: Colors.white)),
              SizedBox(width: 8),
              Container(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1))
            ],
          ),
        ),
      ),
    );
  }
}
