import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';

void main() {
  group("getAnalyticsWidgetName with from and isFavori", () {
    void assertAnalyticsWidgetName(OffrePage from, bool isFavori, String? expected) {
      test("AppPage: $from & isFavori: $isFavori -> $expected", () {
        // Given
        final helper = FavoriHeartAnalyticsHelper();
        // When
        final result = helper.getAnalyticsWidgetName(from, isFavori);
        // Then
        expect(result, expected);
      });
    }

    assertAnalyticsWidgetName(OffrePage.emploiResults, true, "recherche/emploi/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.emploiResults, false, "recherche/emploi/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.emploiDetails, true, "recherche/emploi/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.emploiDetails, false, "recherche/emploi/detail?favori=false");
    assertAnalyticsWidgetName(OffrePage.emploiFavoris, false, "favoris/list/emploi?favori=false");
    assertAnalyticsWidgetName(OffrePage.emploiFavoris, true, null); // Cannot add favori from favori page

    assertAnalyticsWidgetName(OffrePage.alternanceResults, true, "recherche/alternance/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.alternanceResults, false, "recherche/alternance/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.alternanceDetails, true, "recherche/alternance/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.alternanceDetails, false, "recherche/alternance/detail?favori=false");
    assertAnalyticsWidgetName(OffrePage.alternanceFavoris, false, "favoris/list/alternance?favori=false");
    assertAnalyticsWidgetName(OffrePage.alternanceFavoris, true, null); // Cannot add favori from favori page
  });

  group("getAnalyticsEventName with from", () {
    void assertAnalyticsEventName(OffrePage from, String? expected) {
      test("AppPage: $from -> $expected", () {
        // Given
        final helper = FavoriHeartAnalyticsHelper();
        // When
        final result = helper.getAnalyticsEventName(from);
        // Then
        expect(result, expected);
      });
    }

    assertAnalyticsEventName(OffrePage.emploiResults, "recherche/emploi/search_results");
    assertAnalyticsEventName(OffrePage.emploiDetails, "recherche/emploi/detail");
    assertAnalyticsEventName(OffrePage.emploiFavoris, "favoris/list/emploi");

    assertAnalyticsEventName(OffrePage.alternanceResults, "recherche/alternance/search_results");
    assertAnalyticsEventName(OffrePage.alternanceDetails, "recherche/alternance/detail");
    assertAnalyticsEventName(OffrePage.alternanceFavoris, "favoris/list/alternance");
  });
}
