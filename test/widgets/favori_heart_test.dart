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

    assertAnalyticsWidgetName(OffrePage.offreFavoris, false, "favoris/list?favori=false");
    assertAnalyticsWidgetName(OffrePage.offreFavoris, true, null); // Cannot add favori from favori page

    assertAnalyticsWidgetName(OffrePage.emploiResults, true, "/solutions/emploi/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.emploiResults, false, "/solutions/emploi/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.emploiDetails, true, "/solutions/emploi/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.emploiDetails, false, "/solutions/emploi/detail?favori=false");

    assertAnalyticsWidgetName(OffrePage.alternanceResults, true, "/solutions/alternance/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.alternanceResults, false, "/solutions/alternance/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.alternanceDetails, true, "/solutions/alternance/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.alternanceDetails, false, "/solutions/alternance/detail?favori=false");

    assertAnalyticsWidgetName(
        OffrePage.serviceCiviqueResults, true, "/solutions/service_civique/search_results?favori=true");
    assertAnalyticsWidgetName(
        OffrePage.serviceCiviqueResults, false, "/solutions/service_civique/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.serviceCiviqueDetails, true, "/solutions/service_civique/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.serviceCiviqueDetails, false, "/solutions/service_civique/detail?favori=false");

    assertAnalyticsWidgetName(OffrePage.immersionResults, true, "/solutions/immersion/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.immersionResults, false, "/solutions/immersion/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.immersionDetails, true, "/solutions/immersion/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.immersionDetails, false, "/solutions/immersion/detail?favori=false");
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

    assertAnalyticsEventName(OffrePage.offreFavoris, "favoris/list");

    assertAnalyticsEventName(OffrePage.emploiResults, "recherche/emploi/search_results");
    assertAnalyticsEventName(OffrePage.emploiDetails, "recherche/emploi/detail");

    assertAnalyticsEventName(OffrePage.alternanceResults, "recherche/alternance/search_results");
    assertAnalyticsEventName(OffrePage.alternanceDetails, "recherche/alternance/detail");

    assertAnalyticsEventName(OffrePage.serviceCiviqueResults, "recherche/service_civique/search_results");
    assertAnalyticsEventName(OffrePage.serviceCiviqueDetails, "recherche/service_civique/detail");

    assertAnalyticsEventName(OffrePage.immersionResults, "recherche/immersion/search_results");
    assertAnalyticsEventName(OffrePage.immersionDetails, "recherche/immersion/detail");
  });
}
