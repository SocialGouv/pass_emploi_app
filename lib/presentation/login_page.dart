import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        colors: [AppColors.blue, AppColors.purple],
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
                                  "Identifie-toi pour accéder à\nPass Emploi",
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
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Veuillez entrer votre prénom';
                                    return null;
                                  },
                                  onChanged: (String? value) => _firstName = value,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
                                    labelText: "Prénom",
                                    labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                                child: TextFormField(
                                  style: TextStyles.textSmMedium(color: AppColors.nightBlue),
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Veuillez entrer votre nom';
                                    return null;
                                  },
                                  onChanged: (String? value) => _lastName = value,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 24, top: 18, bottom: 18),
                                    labelText: "Nom",
                                    labelStyle: TextStyles.textSmMedium(color: AppColors.bluePurple),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(51.0),
                                      borderSide: BorderSide(color: AppColors.borderGrey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(78),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) print(_firstName! + " " + _lastName!);
                                      },
                                      child: Container(
                                        height: 56,
                                        child: Center(
                                          child:
                                              Text('Se connecter', style: TextStyles.textSmMedium(color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                    color: AppColors.nightBlue,
                                  ),
                                ),
                              ),
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
    );
  }
}
