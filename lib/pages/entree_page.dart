import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';

import 'create_account_page.dart';

class EntreePage extends TraceableStatelessWidget {
  const EntreePage() : super(name: AnalyticsScreenNames.entree);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const EntreeBiseauBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 64),
                SvgPicture.asset(Drawables.passEmploiLogo),
                SizedBox(height: 20),
                Image.asset(Drawables.icUnJeuneUneSolution),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(Drawables.jeuneEntree, alignment: Alignment.bottomCenter),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(Margins.spacing_m),
                          child: Container(
                            decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 6), // changes position of shadow
                              ),
                            ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Margins.spacing_base, vertical: Margins.spacing_m),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PrimaryActionButton(
                                      label: Strings.loginAction,
                                      onPressed: () {
                                        Navigator.push(context, LoginPage.materialPageRoute());
                                      }),
                                  SizedBox(height: Margins.spacing_base),
                                  SecondaryButton(
                                      label: Strings.askAccount,
                                      onPressed: () {
                                        Navigator.push(context, CreateAccountPage.materialPageRoute());
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}