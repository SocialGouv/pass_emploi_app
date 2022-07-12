import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/pages/login_page.dart';

class AnalyticsScreenTracking {
  static String? onGenerateScreenTracking(RouteSettings settings) {
    final routeName = settings.name;
    if (routeName == LoginPage.routeName) return "login";
    return null;
  }
}
