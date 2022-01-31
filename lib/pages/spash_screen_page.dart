import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class SplashScreenPage extends TraceableStatelessWidget {
  SplashScreenPage() : super(name: AnalyticsScreenNames.splash);

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColors.primary);
  }
}
