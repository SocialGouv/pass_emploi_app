import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/choix_organisme_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';

class AnalyticsScreenTracking {
  static String? onGenerateScreenTracking(RouteSettings settings) {
    final routeName = settings.name;
    if (routeName == ChoixOrganismePage.routeName) return AnalyticsScreenNames.choixOrganisme;
    if (routeName == LoginPage.routeName) return "login";
    if (routeName == OffreEmploiListPage.routeName) {
      final args = settings.arguments as Map<String, dynamic>;
      return args["onlyAlternance"] as bool
          ? AnalyticsScreenNames.alternanceResults
          : AnalyticsScreenNames.emploiResults;
    }
    return null;
  }
}
