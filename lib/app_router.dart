import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/choix_organisme_page.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';

class AppRouter {
  MaterialPageRoute<dynamic>? getMaterialPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case CejInformationPage.routeName:
        return MaterialPageRoute(builder: (context) => CejInformationPage());
      case CredentialsPage.routeName:
        return MaterialPageRoute(builder: (context) => CredentialsPage());
      case ChoixOrganismePage.routeName:
        return MaterialPageRoute(builder: (context) => ChoixOrganismePage());
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case OffreEmploiListPage.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => OffreEmploiListPage(
            onlyAlternance: args["onlyAlternance"] as bool,
            fromSavedSearch: (args["fromSavedSearch"] ?? false) as bool,
          ),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
