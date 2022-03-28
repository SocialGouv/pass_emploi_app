import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/choix_organisme_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';

class AnalyticsScreenTracking {
  static final Map<String, String> trackedScreens = {
    ChoixOrganismePage.routeName: AnalyticsScreenNames.choixOrganisme,
    LoginPage.routeName: AnalyticsScreenNames.login,
  };
}
