import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("detailed offer should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.detailedOfferRepository = OffreEmploiDetailsRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(loginState: State<User>.failure()),
    );

    final displayedLoading = store.onChange.any((element) => element.offreEmploiDetailsState.isLoading());
    final successState = store.onChange.firstWhere((element) => element.offreEmploiDetailsState.isSuccess());

    // When
    store.dispatch(OffreEmploiDetailsAction.request("offerId"));

    // Then

    expect(await displayedLoading, true);
    final appState = await successState;
    expect(appState.offreEmploiDetailsState.getResultOrThrow().id, "123TZKB");
  });

  test("detailed offer should be fetched and an error must be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.detailedOfferRepository = OffreEmploiDetailsRepositoryGenericFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(loginState: State<User>.failure()),
    );

    final displayedLoading = store.onChange.any((element) => element.offreEmploiDetailsState.isLoading());
    final displayedError = store.onChange.any((element) => element.offreEmploiDetailsState.isFailure());

    // When
    store.dispatch(OffreEmploiDetailsAction.request("offerId"));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });

  test("offre details should be displayed as incomplete data when 404 error but offre is in favoris", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.detailedOfferRepository = OffreEmploiDetailsRepositoryNotFoundFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
          loginState: State<User>.success(mockUser()),
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap({"offerId"}, {"offerId": mockOffreEmploi()})),
    );

    final displayedLoading = store.onChange.any((element) => element.offreEmploiDetailsState.isLoading());
    final displayedIncompleteData = store.onChange
        .firstWhere((element) => element.offreEmploiDetailsState is OffreEmploiDetailsIncompleteDataState);

    // When
    store.dispatch(OffreEmploiDetailsAction.request("offerId"));

    // Then
    expect(await displayedLoading, true);
    final appState = await displayedIncompleteData;
    final detailsState = (appState.offreEmploiDetailsState as OffreEmploiDetailsIncompleteDataState);
    expect(detailsState.offreEmploi, mockOffreEmploi());
  });
}

class OffreEmploiDetailsRepositorySuccessStub extends OffreEmploiDetailsRepository {
  OffreEmploiDetailsRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiDetailsResponse> getOffreEmploiDetails({required String offreId}) async {
    return OffreEmploiDetailsResponse(
      isGenericFailure: false,
      isOffreNotFound: false,
      offreEmploiDetails: mockOffreEmploiDetails(),
    );
  }
}

class OffreEmploiDetailsRepositoryGenericFailureStub extends OffreEmploiDetailsRepository {
  OffreEmploiDetailsRepositoryGenericFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiDetailsResponse> getOffreEmploiDetails({required String offreId}) async {
    return OffreEmploiDetailsResponse(
      isGenericFailure: true,
      isOffreNotFound: false,
      offreEmploiDetails: null,
    );
  }
}

class OffreEmploiDetailsRepositoryNotFoundFailureStub extends OffreEmploiDetailsRepository {
  OffreEmploiDetailsRepositoryNotFoundFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiDetailsResponse> getOffreEmploiDetails({required String offreId}) async {
    return OffreEmploiDetailsResponse(
      isGenericFailure: false,
      isOffreNotFound: true,
      offreEmploiDetails: null,
    );
  }
}
