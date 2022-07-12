import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';

class AppRouter {
  MaterialPageRoute<dynamic>? getMaterialPageRoute(RouteSettings settings) {
    final widget = _getWidget(settings);
    return widget != null ? MaterialPageRoute(builder: (context) => widget, settings: settings) : null;
  }

  Widget? _getWidget(RouteSettings settings) {
    switch (settings.name) {
      case CejInformationPage.routeName:
        return CejInformationPage();
      case CredentialsPage.routeName:
        return CredentialsPage();
      default:
        return null;
    }
  }
}
