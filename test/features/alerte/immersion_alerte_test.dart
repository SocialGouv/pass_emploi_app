import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/alerte/init/alerte_initialize_action.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/immersion_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_repository.dart';

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
    final immersionAlerte = ImmersionAlerte(
      id: "id",
      title: "Boulanger - Paris",
      filtres: ImmersionFiltresRecherche.noFiltre(),
      location: mockLocation(),
      metier: "Boulanger",
      ville: "Paris",
      codeRome: "ROME-PARIS",
    );

    final AppState initialState = AppState.initialState().copyWith(
      immersionAlerteCreateState: AlerteCreateState.initialized(immersionAlerte),
      loginState: successMiloUserState(),
    );

    test("alerte should successfully update its state when alerte api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.immersionAlerteRepository = ImmersionAlerteRepositorySuccessStub();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionAlerteCreateState.status == AlerteCreateStatus.SUCCESS;
      });

      // When
      store.dispatch(AlerteCreateRequestAction(immersionAlerte, "Boulanger - Paris"));

      // Then
      final immersionAlerteState = (await expected).immersionAlerteCreateState;
      expect(immersionAlerteState is AlerteCreateSuccessfullyCreated, true);
    });

    test("alerte should fail when alerte api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.immersionAlerteRepository = ImmersionAlerteRepositoryFailureStub();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionAlerteCreateState.status == AlerteCreateStatus.ERROR;
      });

      // When
      store.dispatch(AlerteCreateRequestAction(immersionAlerte, "Boulanger - Paris"));

      // Then
      final immersionAlerteState = (await expected).immersionAlerteCreateState;
      expect(immersionAlerteState is AlerteCreateFailureState, true);
    });

    test("SaveSearchInitializeAction should update store with rights information", () async {
      // Given
      final AppState initialState = AppState.initialState().loggedInMiloUser().successRechercheImmersionState(
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
            metier: Metier(codeRome: 'codeRome', libelle: 'metier'),
            location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
          ),
          ImmersionFiltresRecherche.noFiltre(),
          1,
        ),
      );
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionAlerteCreateState is AlerteCreateInitialized;
      });

      // When
      store.dispatch(SaveSearchInitializeAction<ImmersionAlerte>());

      // Then
      final state = (await expected).immersionAlerteCreateState as AlerteCreateInitialized<ImmersionAlerte>;
      expect(
          state.search,
          ImmersionAlerte(
            id: "",
            title: "metier - ville",
            codeRome: "codeRome",
            metier: "metier",
            location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
            ville: "ville",
            filtres: ImmersionFiltresRecherche.noFiltre(),
          ));
    });

    test("SaveSearchInitializeAction should update store with rights information when search has filtres", () async {
      // Given
      final AppState initialState = AppState.initialState().loggedInMiloUser().successRechercheImmersionState(
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
            metier: Metier(codeRome: 'codeRome', libelle: 'metier'),
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
          ),
          ImmersionFiltresRecherche.distance(27),
          1,
        ),
      );
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionAlerteCreateState is AlerteCreateInitialized;
      });

      // When
      store.dispatch(SaveSearchInitializeAction<ImmersionAlerte>());

      // Then
      final state = (await expected).immersionAlerteCreateState as AlerteCreateInitialized<ImmersionAlerte>;
      expect(
          state.search,
          ImmersionAlerte(
            id: "",
            title: "metier - ville",
            codeRome: "codeRome",
            metier: "metier",
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
            ville: "ville",
            filtres: ImmersionFiltresRecherche.distance(27),
          ));
    });

    test("SaveSearchInitializeAction should update store with right information when search has no result", () async {
      // Given
      final AppState initialState = AppState.initialState().loggedInMiloUser().successRechercheImmersionState(
        results: [],
        request: RechercheRequest(
          ImmersionCriteresRecherche(
            metier: Metier(codeRome: 'codeRome', libelle: ''),
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
          ),
          ImmersionFiltresRecherche.distance(34),
          1,
        ),
      );
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.authenticator = MockAuthenticator.successful();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionAlerteCreateState is AlerteCreateInitialized;
      });

      // When
      store.dispatch(SaveSearchInitializeAction<ImmersionAlerte>());

      // Then
      final state = (await expected).immersionAlerteCreateState as AlerteCreateInitialized<ImmersionAlerte>;
      expect(
          state.search,
          ImmersionAlerte(
            id: "",
            title: " - ville",
            codeRome: "codeRome",
            metier: "",
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
            ville: "ville",
            filtres: ImmersionFiltresRecherche.distance(34),
          ));
    });
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
      expect(alertes[0].getTitle(), "Boulangerie - viennoiserie - PARIS-14");
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
        factory.immersionRepository = ImmersionSuccessStub();
      });

      sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithSameCriteresAndFiltres()]);
    });
  });
}

class ImmersionSuccessStub extends ImmersionRepository {
  ImmersionSuccessStub() : super(DioMock());

  @override
  Future<RechercheResponse<Immersion>?> rechercher({
    required String userId,
    required RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche> request,
  }) async {
    return RechercheResponse(results: mockOffresImmersion10(), canLoadMore: false);
  }
}

class ImmersionAlerteRepositorySuccessStub extends ImmersionAlerteRepository {
  ImmersionAlerteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> postAlerte(String userId, ImmersionAlerte alerte, String title) async {
    return true;
  }
}

class ImmersionAlerteRepositoryFailureStub extends ImmersionAlerteRepository {
  ImmersionAlerteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> postAlerte(String userId, ImmersionAlerte alerte, String title) async {
    return false;
  }
}

class AlerteRepositorySuccessStub extends GetAlerteRepository {
  AlerteRepositorySuccessStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<ImmersionAlerte>?> getAlerte(String userId) async {
    return _getImmersionAlerteList();
  }
}

class AlerteRepositoryFailureStub extends GetAlerteRepository {
  AlerteRepositoryFailureStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<ImmersionAlerte>?> getAlerte(String userId) async {
    return null;
  }
}

List<ImmersionAlerte> _getImmersionAlerteList() {
  return [
    ImmersionAlerte(
      id: "id",
      title: "Boulangerie - viennoiserie - PARIS-14",
      codeRome: "D1102",
      metier: "Boulangerie - viennoiserie",
      location: mockCommuneLocation(label: "PARIS-14", lat: 48.830108, lon: 2.323026),
      ville: "PARIS-14",
      filtres: ImmersionFiltresRecherche.noFiltre(),
    )
  ];
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheImmersionState.status == RechercheStatus.initialLoading);
}

Matcher _shouldSucceedWithSameCriteresAndFiltres() {
  return StateMatch(
    (state) => state.rechercheImmersionState.status == RechercheStatus.success,
    (state) {
      expect(
        state.rechercheImmersionState.request!.criteres,
        ImmersionCriteresRecherche(
          metier: Metier(codeRome: "D1102", libelle: "Boulangerie - viennoiserie"),
          location: mockCommuneLocation(label: "PARIS-14", lat: 48.830108, lon: 2.323026),
        ),
      );
      expect(
        state.rechercheImmersionState.request!.filtres,
        ImmersionFiltresRecherche.noFiltre(),
      );
      expect(state.rechercheImmersionState.results?.length, 10);
    },
  );
}
