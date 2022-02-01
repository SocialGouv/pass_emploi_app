import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/widgets/entree_background.dart';

class SplashScreenPage extends TraceableStatelessWidget {
  SplashScreenPage() : super(name: AnalyticsScreenNames.splash);

  @override
  Widget build(BuildContext context) {
    return EntreeBackground();
  }
}
