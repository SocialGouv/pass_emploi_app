import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.splash,
      child: Stack(
        children: [
          EntreeBiseauBackground(),
          Center(child: SvgPicture.asset(Drawables.cejAppLogo, semanticsLabel: Strings.logoTextDescription)),
        ],
      ),
    );
  }
}
