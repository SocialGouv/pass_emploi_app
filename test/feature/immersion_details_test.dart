import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_details_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("immersion should be loaded and result displayed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionDetailsRepository = ImmersionDetailsRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading = store.onChange.any((e) => e.immersionDetailsState.isLoading());
    final Future<AppState> successStateFuture = store.onChange.firstWhere((e) => e.immersionDetailsState.isSuccess());

    // When
    store.dispatch(ImmersionDetailsAction.request("immersion-id"));

    // Then
    expect(await displayedLoading, isTrue);
    final successState = await successStateFuture;
    expect(successState.immersionDetailsState.getResultOrThrow(), _mockImmersionDetails());
  });

  test("immersion should be displayed as incomplete data when 404 error but offre is in favoris", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionDetailsRepository = ImmersionDetailsRepositoryNotFoundFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
          loginState: State<User>.success(mockUser()),
          immersionFavorisState: FavorisState<Immersion>.withMap({"offerId"}, {"offerId": mockImmersion()})),
    );

    final displayedLoading = store.onChange.any((element) => element.immersionDetailsState.isLoading());
    final displayedIncompleteData =
        store.onChange.firstWhere((element) => element.immersionDetailsState is ImmersionDetailsIncompleteDataState);

    // When
    store.dispatch(ImmersionDetailsAction.request("offerId"));

    // Then
    expect(await displayedLoading, true);
    final appState = await displayedIncompleteData;
    final detailsState = (appState.immersionDetailsState as ImmersionDetailsIncompleteDataState);
    expect(detailsState.immersion, mockImmersion());
  });

  test("immersion should be loaded and error displayed when repository returns null", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionDetailsRepository = ImmersionDetailsRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading = store.onChange.any((e) => e.immersionDetailsState.isLoading());
    final Future<bool> displayedError = store.onChange.any((e) => e.immersionDetailsState.isFailure());

    // When
    store.dispatch(ImmersionDetailsAction.request("immersion-id"));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });

  test("immersion should be reset on reset action", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInState().copyWith(immersionDetailsState: State<ImmersionDetails>.failure()),
    );

    final Future<AppState> resultStateFuture = store.onChange.first;

    // When
    store.dispatch(ImmersionDetailsAction.reset());

    // Then
    final resultState = await resultStateFuture;
    expect(resultState.immersionSearchState.isNotInitialized(), isTrue);
  });
}

class ImmersionDetailsRepositorySuccessStub extends ImmersionDetailsRepository {
  ImmersionDetailsRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreDetailsResponse<ImmersionDetails>> fetch(String offreId) async {
    return offreId == "immersion-id"
        ? OffreDetailsResponse(
            isGenericFailure: false,
            isOffreNotFound: false,
            details: _mockImmersionDetails(),
          )
        : OffreDetailsResponse(
            isGenericFailure: true,
            isOffreNotFound: false,
            details: null,
          );
  }
}

class ImmersionDetailsRepositoryFailureStub extends ImmersionDetailsRepository {
  ImmersionDetailsRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreDetailsResponse<ImmersionDetails>> fetch(String offreId) async {
    return OffreDetailsResponse(
      isGenericFailure: true,
      isOffreNotFound: false,
      details: null,
    );
  }
}

ImmersionDetails _mockImmersionDetails() {
  return ImmersionDetails(
    id: "",
    metier: "",
    companyName: "",
    secteurActivite: "",
    ville: "",
    address: "",
    isVolontaire: true,
    contact: null,
  );
}

class ImmersionDetailsRepositoryNotFoundFailureStub extends ImmersionDetailsRepository {
  ImmersionDetailsRepositoryNotFoundFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreDetailsResponse<ImmersionDetails>> fetch(String offreId) async {
    return OffreDetailsResponse(
      isGenericFailure: false,
      isOffreNotFound: true,
      details: null,
    );
  }
}
