import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';

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
      case LoginPage.routeName:
        return LoginPage();
      case OffreEmploiListPage.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return OffreEmploiListPage(
          onlyAlternance: args["onlyAlternance"] as bool,
          fromSavedSearch: (args["fromSavedSearch"] ?? false) as bool,
        );
      default:
        return null;
    }
  }
}
