import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/alerte/init/alerte_initialize_action.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/service_civique_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When user tries to save an service civique search ...", () {
    final serviceCiviqueAlerte = ServiceCiviqueAlerte(
      id: "id",
      titre: "Boulanger - Paris",
      filtres: ServiceCiviqueFiltresParameters.distance(10),
      location: mockLocation(),
      ville: "Paris",
      domaine: Domaine.values[2],
    );

    final AppState initialState = AppState.initialState().copyWith(
      serviceCiviqueAlerteCreateState: AlerteCreateState.initialized(serviceCiviqueAlerte),
      loginState: successMiloUserState(),
    );

    test("alerte should successfully update its state when alerte api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.serviceCiviqueAlerteRepository = ServiceCiviqueAlerteRepositorySuccessStub();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.serviceCiviqueAlerteCreateState.status == AlerteCreateStatus.SUCCESS;
      });

      // When
      store.dispatch(AlerteCreateRequestAction(serviceCiviqueAlerte, "Boulanger - Paris"));

      // Then
      final immersionAlerteState = (await expected).serviceCiviqueAlerteCreateState;
      expect(immersionAlerteState is AlerteCreateSuccessfullyCreated, true);
    });

    test("alerte should fail when alerte api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.serviceCiviqueAlerteRepository = ServiceCiviqueAlerteRepositoryFailureStub();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.serviceCiviqueAlerteCreateState.status == AlerteCreateStatus.ERROR;
      });

      // When
      store.dispatch(AlerteCreateRequestAction(serviceCiviqueAlerte, "Boulanger - Paris"));

      // Then
      final serviceCiviqueAlerteState = (await expected).serviceCiviqueAlerteCreateState;
      expect(serviceCiviqueAlerteState is AlerteCreateFailureState, true);
    });
  });

  test("SaveSearchInitializeAction should update store with rights information", () async {
    // Given
    final initialState = givenState() //
        .loggedInUser() //
        .successRechercheServiceCiviqueStateWithRequest(
          criteres: ServiceCiviqueCriteresRecherche(location: mockLocation()),
          filtres: ServiceCiviqueFiltresRecherche(distance: 10, startDate: null, domain: null),
        );
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.authenticator = MockAuthenticator.successful();
    final store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final expected = store.onChange.firstWhere((e) {
      return e.serviceCiviqueAlerteCreateState is AlerteCreateInitialized;
    });

    // When
    store.dispatch(SaveSearchInitializeAction<ServiceCiviqueAlerte>());

    // Then
    final state = (await expected).serviceCiviqueAlerteCreateState as AlerteCreateInitialized<ServiceCiviqueAlerte>;
    expect(
        state.search,
        ServiceCiviqueAlerte(
          id: "",
          domaine: null,
          titre: "",
          location: mockLocation(),
          ville: "",
          filtres: ServiceCiviqueFiltresParameters.distance(10),
        ));
  });

  group("When user tries to get a list of immersion alertes ...", () {
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
      expect(alertes.length, 1);
      expect(alertes[0].getTitle(), "Je suis un titre");
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
  });

  group("when user request a specific saved search", () {
    final sut = StoreSut();
    sut.whenDispatchingAction(() => FetchAlerteResultsFromIdAction('id'));

    test('should retrieve results coming from same criteres and filtres', () {
      sut.givenStore = givenState().loggedInUser().store((factory) {
        factory.getAlerteRepository = AlerteRepositorySuccessStub();
        factory.serviceCiviqueRepository = ServiceCiviqueRepositorySuccessStub();
      });

      sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithSameCriteresAndFiltres()]);
    });
  });
}

class ServiceCiviqueRepositorySuccessStub extends ServiceCiviqueRepository {
  ServiceCiviqueRepositorySuccessStub() : super(DioMock());

  @override
  Future<RechercheResponse<ServiceCivique>?> rechercher({
    required String userId,
    required RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche> request,
  }) async {
    return RechercheResponse(results: mockOffresServiceCivique10(), canLoadMore: false);
  }
}

class ServiceCiviqueAlerteRepositorySuccessStub extends ServiceCiviqueAlerteRepository {
  ServiceCiviqueAlerteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> postAlerte(String userId, ServiceCiviqueAlerte alerte, String title) async {
    return true;
  }
}

class ServiceCiviqueAlerteRepositoryFailureStub extends ServiceCiviqueAlerteRepository {
  ServiceCiviqueAlerteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> postAlerte(String userId, ServiceCiviqueAlerte alerte, String title) async {
    return false;
  }
}

class AlerteRepositorySuccessStub extends GetAlerteRepository {
  AlerteRepositorySuccessStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<ServiceCiviqueAlerte>?> getAlerte(String userId) async {
    return _getServiceCiviqueAlerteList();
  }
}

class AlerteRepositoryFailureStub extends GetAlerteRepository {
  AlerteRepositoryFailureStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<ServiceCiviqueAlerte>?> getAlerte(String userId) async {
    return null;
  }
}

List<ServiceCiviqueAlerte> _getServiceCiviqueAlerteList() {
  return [
    ServiceCiviqueAlerte(
      id: "id",
      titre: "Je suis un titre",
      location: mockCommuneLocation(),
      filtres: ServiceCiviqueFiltresParameters.distance(50),
    )
  ];
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheServiceCiviqueState.status == RechercheStatus.initialLoading);
}

Matcher _shouldSucceedWithSameCriteresAndFiltres() {
  return StateMatch(
    (state) => state.rechercheServiceCiviqueState.status == RechercheStatus.success,
    (state) {
      expect(
        state.rechercheServiceCiviqueState.request!.criteres,
        ServiceCiviqueCriteresRecherche(location: mockCommuneLocation()),
      );
      expect(
        state.rechercheServiceCiviqueState.request!.filtres,
        ServiceCiviqueFiltresRecherche(distance: 50, startDate: null, domain: null),
      );
      expect(state.rechercheServiceCiviqueState.results?.length, 10);
    },
  );
}
