import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_route_settings.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class SplashScreenPage extends StatelessWidget {

  SplashScreenPage._();

  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => SplashScreenPage._(), settings: AnalyticsRouteSettings.splash());
  }

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
