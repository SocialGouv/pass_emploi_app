import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search_extractors.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test("tests offre emploi search extractor", () {
    // Given
    final filtres = EmploiFiltresRecherche.withFiltres(
      distance: 12,
      experience: [ExperienceFiltre.de_un_a_trois_ans],
      duree: [DureeFiltre.temps_partiel],
      contrat: [ContratFiltre.cdd_interim_saisonnier],
    );
    final location = mockLocation();

    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: 'Je suis un keyword',
            location: location,
            rechercheType: RechercheType.offreEmploiAndAlternance,
          ),
          filtres: filtres,
        )
        .store();

    // When
    final result = OffreEmploiSearchExtractor().getSearchFilters(store);

    // Then
    final expected = OffreEmploiSavedSearch(
      id: "",
      title: "Je suis un keyword",
      metier: "Je suis un keyword",
      location: location,
      keyword: "Je suis un keyword",
      onlyAlternance: false,
      filters: filtres,
    );
    expect(result, expected);
  });

  test("tests immersion search extractor", () {
    // Given
    final searchedMetier = mockAutocompleteMetiers().first;
    final store = AppState.initialState()
        .loggedInMiloUser()
        .successRechercheImmersionState(
          results: [
            Immersion(
              id: "id",
              metier: "metier",
              nomEtablissement: "nomEtablissement",
              secteurActivite: "secteurActivite",
              ville: "ville",
            )
          ],
          request: RechercheRequest(
            ImmersionCriteresRecherche(
              metier: mockAutocompleteMetiers().first,
              location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
            ),
            ImmersionFiltresRecherche.noFiltre(),
            1,
          ),
        )
        .copyWith(searchMetierState: SearchMetierState([searchedMetier]))
        .store();

    // When
    final result = ImmersionSearchExtractor().getSearchFilters(store);

    // Then
    expect(
      result,
      ImmersionSavedSearch(
        id: "",
        title: "Chevrier / Chevrière - ville",
        metier: "Chevrier / Chevrière",
        codeRome: searchedMetier.codeRome,
        location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
        ville: "ville",
        filtres: ImmersionFiltresRecherche.noFiltre(),
      ),
    );
  });
}
