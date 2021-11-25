import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("detailed offer should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.detailedOfferRepository = DetailedOfferRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
    );

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiDetailsState is OffreEmploiDetailsLoadingState);
    final successState =
        store.onChange.firstWhere((element) => element.offreEmploiDetailsState is OffreEmploiDetailsSuccessState);

    // When
    store.dispatch(GetOffreEmploiDetailsAction(offreId: "offerId"));

    // Then

    expect(await displayedLoading, true);
    final appState = await successState;
    final searchState = (appState.offreEmploiDetailsState as OffreEmploiDetailsSuccessState);
    expect(searchState.offre.id, "123TZKB");
  });

  test("detailed offer should be fetched and an error must be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.detailedOfferRepository = DetailedOfferRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
    );

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiDetailsState is OffreEmploiDetailsLoadingState);
    final displayedError =
        store.onChange.any((element) => element.offreEmploiDetailsState is OffreEmploiDetailsFailureState);

    // When
    store.dispatch(GetOffreEmploiDetailsAction(offreId: "offerId"));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

class DetailedOfferRepositorySuccessStub extends OffreEmploiDetailsRepository {
  DetailedOfferRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<OffreEmploiDetails?> getOffreEmploiDetails({required String offreId}) async => mockOffreEmploiDetails();
}

class DetailedOfferRepositoryFailureStub extends OffreEmploiDetailsRepository {
  DetailedOfferRepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<OffreEmploiDetails?> getOffreEmploiDetails({required String offreId}) async => null;
}
