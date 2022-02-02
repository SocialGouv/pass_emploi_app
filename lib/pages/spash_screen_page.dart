import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';

class SplashScreenPage extends TraceableStatelessWidget {
  SplashScreenPage() : super(name: AnalyticsScreenNames.splash);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EntreeBiseauBackground(),
        Center(child: SvgPicture.asset(Drawables.passEmploiLogo, semanticsLabel: Strings.logoTextDescription)),
      ],
    );
  }
}
