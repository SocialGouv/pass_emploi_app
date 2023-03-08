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

    assertAnalyticsWidgetName(OffrePage.alternanceResults, true, "/solutions/alternance/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.alternanceResults, false, "/solutions/alternance/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.alternanceDetails, true, "/solutions/alternance/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.alternanceDetails, false, "/solutions/alternance/detail?favori=false");

    assertAnalyticsWidgetName(
      OffrePage.serviceCiviqueResults,
      true,
      "/solutions/service_civique/search_results?favori=true",
    );
    assertAnalyticsWidgetName(
      OffrePage.serviceCiviqueResults,
      false,
      "/solutions/service_civique/search_results?favori=false",
    );
    assertAnalyticsWidgetName(OffrePage.serviceCiviqueDetail, true, "/solutions/service_civique/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.serviceCiviqueDetail, false, "/solutions/service_civique/detail?favori=false");

    assertAnalyticsWidgetName(OffrePage.immersionResults, true, "/solutions/immersion/search_results?favori=true");
    assertAnalyticsWidgetName(OffrePage.immersionResults, false, "/solutions/immersion/search_results?favori=false");
    assertAnalyticsWidgetName(OffrePage.immersionDetails, true, "/solutions/immersion/detail?favori=true");
    assertAnalyticsWidgetName(OffrePage.immersionDetails, false, "/solutions/immersion/detail?favori=false");
  });
}
