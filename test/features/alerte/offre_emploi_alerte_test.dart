import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/offre_emploi_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When user tries to save an offer search ...", () {
    final offreEmploiAlerte = OffreEmploiAlerte(
        id: "id",
        title: "Boulanger",
        filters: EmploiFiltresRecherche.noFiltre(),
        keyword: "Boulanger",
        onlyAlternance: false,
        location: mockLocation(),
        metier: "Boulanger");

    final AppState initialState = AppState.initialState().copyWith(
      offreEmploiAlerteCreateState: AlerteCreateState.initialized(offreEmploiAlerte),
      loginState: successMiloUserState(),
    );

    test("alerte should successfully update its state when alerte api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiAlerteRepository = OffreEmploiAlerteRepositorySuccessStub();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.offreEmploiAlerteCreateState.status == AlerteCreateStatus.SUCCESS;
      });

      // When
      store.dispatch(AlerteCreateRequestAction(offreEmploiAlerte, "Boulanger"));

      // Then
      final offreEmploiAlerteCreateState = (await expected).offreEmploiAlerteCreateState;
      expect(offreEmploiAlerteCreateState is AlerteCreateSuccessfullyCreated, true);
    });

    test("alerte should fail when alerte api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiAlerteRepository = OffreEmploiAlerteRepositoryFailureStub();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.offreEmploiAlerteCreateState.status == AlerteCreateStatus.ERROR;
      });

      // When
      store.dispatch(AlerteCreateRequestAction(offreEmploiAlerte, "Boulanger"));

      // Then
      final offreEmploiAlerteCreateState = (await expected).offreEmploiAlerteCreateState;
      expect(offreEmploiAlerteCreateState is AlerteCreateFailureState, true);
    });
  });

  group("When user tries to get a list of offre emploi/alternance alertes ...", () {
    test("update state with success if repository returns data", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.getAlerteRepository = AlerteRepositorySuccessStub();
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
      final displayedLoading = store.onChange.any((e) => e.alerteListState is AlerteListLoadingState);
      final successAppState = store.onChange.firstWhere((e) => e.alerteListState is AlerteListSuccessState);

      // When
      store.dispatch(AlerteListRequestAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await successAppState;
      final alertes = (appState.alerteListState as AlerteListSuccessState).alertes;
      expect(alertes, isNotNull);
      expect(alertes.length, 2);
      expect(alertes[0].getTitle(), "Boulangerie - NANTES");
      expect(alertes[1].getTitle(), "Flutter");
    });

    test("update state with failure if repository returns nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.getAlerteRepository = AlerteRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
      final displayedLoading = store.onChange.any((e) => e.alerteListState is AlerteListLoadingState);
      final failureAppState = store.onChange.firstWhere((e) => e.alerteListState is AlerteListFailureState);

      // When
      store.dispatch(AlerteListRequestAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await failureAppState;
      expect(appState.alerteListState is AlerteListFailureState, isTrue);
    });

    group("when user request a specific saved search", () {
      final sut = StoreSut();
      sut.whenDispatchingAction(() => FetchAlerteResultsFromIdAction('id'));

      test('should retrieve results coming from same criteres and filtres', () {
        sut.givenStore = givenState().loggedInUser().store((factory) {
          factory.getAlerteRepository = AlerteRepositorySuccessStub();
          factory.offreEmploiRepository = OffreEmploiRepositorySuccessStub();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithSameCriteresAndFiltres()]);
      });
    });
  });
}

class OffreEmploiRepositorySuccessStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessStub() : super(DioMock());

  @override
  Future<RechercheResponse<OffreEmploi>?> rechercher({
    required String userId,
    required RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  }) async {
    return RechercheResponse(results: mockOffresEmploi10(), canLoadMore: false);
  }
}

class OffreEmploiAlerteRepositorySuccessStub extends OffreEmploiAlerteRepository {
  OffreEmploiAlerteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> postAlerte(String userId, OffreEmploiAlerte alerte, String title) async {
    return true;
  }
}

class OffreEmploiAlerteRepositoryFailureStub extends OffreEmploiAlerteRepository {
  OffreEmploiAlerteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> postAlerte(String userId, OffreEmploiAlerte alerte, String title) async {
    return false;
  }
}

class AlerteRepositorySuccessStub extends GetAlerteRepository {
  AlerteRepositorySuccessStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<OffreEmploiAlerte>?> getAlerte(String userId) async {
    return _getOffreEmploiAlerteList();
  }
}

class AlerteRepositoryFailureStub extends GetAlerteRepository {
  AlerteRepositoryFailureStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<OffreEmploiAlerte>?> getAlerte(String userId) async {
    return null;
  }
}

List<OffreEmploiAlerte> _getOffreEmploiAlerteList() {
  return [
    OffreEmploiAlerte(
      id: "id",
      title: "Boulangerie - NANTES",
      metier: "Boulangerie",
      location: Location(libelle: "NANTES", code: "44109", type: LocationType.COMMUNE),
      keyword: "Boulangerie",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiAlerte(
      id: "id2",
      title: "Flutter",
      metier: "Flutter",
      location: null,
      keyword: "Flutter",
      onlyAlternance: true,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
  ];
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheEmploiState.status == RechercheStatus.initialLoading);
}

Matcher _shouldSucceedWithSameCriteresAndFiltres() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.success,
    (state) {
      expect(
        state.rechercheEmploiState.request!.criteres,
        EmploiCriteresRecherche(
          keyword: "Boulangerie",
          location: Location(libelle: "NANTES", code: "44109", type: LocationType.COMMUNE),
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
      );
      expect(
        state.rechercheEmploiState.request!.filtres,
        EmploiFiltresRecherche.withFiltres(
          distance: null,
          experience: [],
          contrat: [],
          duree: [],
        ),
      );
      expect(state.rechercheEmploiState.results?.length, 10);
    },
  );
}
