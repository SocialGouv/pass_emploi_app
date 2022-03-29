import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/choix_organisme_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';

class AnalyticsScreenTracking {
  static final Map<String, String Function(RouteSettings settings)> trackedScreens = {
    ChoixOrganismePage.routeName: (settings) => AnalyticsScreenNames.choixOrganisme,
    LoginPage.routeName: (settings) => AnalyticsScreenNames.login,
    OffreEmploiListPage.routeName: (settings) {
      final args = settings.arguments as Map<String, dynamic>;
      return args["onlyAlternance"] as bool
          ? AnalyticsScreenNames.alternanceResults
          : AnalyticsScreenNames.emploiResults;
    }
  };
}
