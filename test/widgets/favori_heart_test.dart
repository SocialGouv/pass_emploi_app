import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/pages/app_page.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';

void main() {
  group("getAnalyticsWidgetName with from and isFavori", () {
    void assertAnalyticsWidgetName(AppPage from, bool isFavori, String? expected) {
      test("AppPage: $from & isFavori: $isFavori -> $expected", () {
        // Given
        final helper = FavoriHeartAnalyticsHelper();
        // When
        final result = helper.getAnalyticsWidgetName(from, isFavori);
        // Then
        expect(result, expected);
      });
    }

    assertAnalyticsWidgetName(AppPage.emploiResults, true, "recherche/emploi/search_results?favori=true");
    assertAnalyticsWidgetName(AppPage.emploiResults, false, "recherche/emploi/search_results?favori=false");
    assertAnalyticsWidgetName(AppPage.emploiDetails, true, "recherche/emploi/detail?favori=true");
    assertAnalyticsWidgetName(AppPage.emploiDetails, false, "recherche/emploi/detail?favori=false");
    assertAnalyticsWidgetName(AppPage.emploiFavoris, false, "favoris/list/emploi?favori=false");
    assertAnalyticsWidgetName(AppPage.emploiFavoris, true, null); // Cannot add favori from favori page

    assertAnalyticsWidgetName(AppPage.alternanceResults, true, "recherche/alternance/search_results?favori=true");
    assertAnalyticsWidgetName(AppPage.alternanceResults, false, "recherche/alternance/search_results?favori=false");
    assertAnalyticsWidgetName(AppPage.alternanceDetails, true, "recherche/alternance/detail?favori=true");
    assertAnalyticsWidgetName(AppPage.alternanceDetails, false, "recherche/alternance/detail?favori=false");
    assertAnalyticsWidgetName(AppPage.alternanceFavoris, false, "favoris/list/alternance?favori=false");
    assertAnalyticsWidgetName(AppPage.alternanceFavoris, true, null); // Cannot add favori from favori page
  });

  group("getAnalyticsEventName with from", () {
    void assertAnalyticsEventName(AppPage from, String? expected) {
      test("AppPage: $from -> $expected", () {
        // Given
        final helper = FavoriHeartAnalyticsHelper();
        // When
        final result = helper.getAnalyticsEventName(from);
        // Then
        expect(result, expected);
      });
    }

    assertAnalyticsEventName(AppPage.emploiResults, "recherche/emploi/search_results");
    assertAnalyticsEventName(AppPage.emploiDetails, "recherche/emploi/detail");
    assertAnalyticsEventName(AppPage.emploiFavoris, "favoris/list/emploi");

    assertAnalyticsEventName(AppPage.alternanceResults, "recherche/alternance/search_results");
    assertAnalyticsEventName(AppPage.alternanceDetails, "recherche/alternance/detail");
    assertAnalyticsEventName(AppPage.alternanceFavoris, "favoris/list/alternance");
  });
}
