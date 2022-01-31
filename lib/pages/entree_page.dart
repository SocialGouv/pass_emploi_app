import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/entree_background.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';

class EntreePage extends TraceableStatelessWidget {
  const EntreePage() : super(name: AnalyticsScreenNames.entree);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const EntreeBackground(),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryActionButton(
                          label: "Se connecter",
                          onPressed: () {
                            Navigator.push(context, LoginPage.materialPageRoute());
                          }),
                      SizedBox(height: Margins.spacing_base),
                      SecondaryButton(label: "Demander un compte pass emploi", onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}