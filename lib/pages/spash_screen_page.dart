import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class SplashScreenPage extends TraceableStatelessWidget {
  SplashScreenPage._() : super(name: AnalyticsScreenNames.splash);

  static MaterialPageRoute materialPageRoute() => MaterialPageRoute(builder: (context) => SplashScreenPage._());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.lightBlue, AppColors.lightPurple],
        ),
      ),
      child: Center(child: SvgPicture.asset("assets/ic_logo.svg", semanticsLabel: Strings.logoTextDescription)),
    );
  }
}
