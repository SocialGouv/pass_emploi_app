import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/analytics/analytics_screen_tracking.dart';

void main() {
  group("onGenerateScreenTracking should properly build tracking page depending on route settings", () {
    void assertTracking(RouteSettings settings, String? expectedTracking) {
      test("${settings.name} with args ${settings.arguments} -> $expectedTracking", () async {
        // When
        final tracking = AnalyticsScreenTracking.onGenerateScreenTracking(settings);

        // Then
        expect(tracking, expectedTracking);
      });
    }

    assertTracking(RouteSettings(name: "/router"), null);
    assertTracking(RouteSettings(name: "/login"), "login");
    assertTracking(RouteSettings(name: "/entree/choix-organisme"), "entree/choix-organisme");
    assertTracking(
      RouteSettings(name: "/recherche/search_results", arguments: {"onlyAlternance": false}),
      "recherche/emploi/search_results",
    );
    assertTracking(
      RouteSettings(name: "/recherche/search_results", arguments: {"onlyAlternance": true}),
      "recherche/alternance/search_results",
    );
  });
}
