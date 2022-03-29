import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/analytics/analytics_screen_tracking.dart';

void main() {
  test("login tracking", () {
    // Given
    final settings = RouteSettings(name: "/login");

    // When
    final tracking = AnalyticsScreenTracking.onGenerateScreenTracking(settings);

    // Then
    expect(tracking, "login");
  });

  test("choix organisme tracking", () {
    // Given
    final settings = RouteSettings(name: "/entree/choix-organisme");

    // When
    final tracking = AnalyticsScreenTracking.onGenerateScreenTracking(settings);

    // Then
    expect(tracking, "entree/choix-organisme");
  });

  test("offres emploi results tracking", () {
    // Given
    final settings = RouteSettings(name: "/recherche/search_results", arguments: {"onlyAlternance": false});

    // When
    final tracking = AnalyticsScreenTracking.onGenerateScreenTracking(settings);

    // Then
    expect(tracking, "recherche/emploi/search_results");
  });

  test("offres alternance results tracking", () {
    // Given
    final settings = RouteSettings(name: "/recherche/search_results", arguments: {"onlyAlternance": true});

    // When
    final tracking = AnalyticsScreenTracking.onGenerateScreenTracking(settings);

    // Then
    expect(tracking, "recherche/alternance/search_results");
  });

  test("router should not be tracked", () {
    // Given
    final settings = RouteSettings(name: "/router");

    // When
    final tracking = AnalyticsScreenTracking.onGenerateScreenTracking(settings);

    // Then
    expect(tracking, isNull);
  });
}
