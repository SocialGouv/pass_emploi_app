import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/redux/actions/detailed_offer_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/detailed_offer_repository.dart';

import '../doubles/fixtures.dart';
import '../models/detailed_offer_test.dart';
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
    store.onChange.any((element) => element.detailedOfferState is DetailedOfferLoadingState);
    final successState =
    store.onChange.firstWhere((element) => element.detailedOfferState is DetailedOfferSuccessState);

    // When
    store.dispatch(GetDetailedOfferAction(offerId: "offerId"));

    // Then

    expect(await displayedLoading, true);
    final appState = await successState;
    var searchState = (appState.detailedOfferState as DetailedOfferSuccessState);
    expect(searchState.offer.id, "123TZKB");
  });

  test("detailed offer should be fetched and an error must be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.detailedOfferRepository = DetailedOfferRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
    );

    final displayedLoading =
    store.onChange.any((element) => element.detailedOfferState is DetailedOfferLoadingState);
    final displayedError =
    store.onChange.any((element) => element.detailedOfferState is DetailedOfferFailureState);

    // When
    store.dispatch(GetDetailedOfferAction(offerId: "offerId"));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

class DetailedOfferRepositorySuccessStub extends DetailedOfferRepository {
  DetailedOfferRepositorySuccessStub() : super("");

  @override
  Future<DetailedOffer?> getDetailedOffer({
    required String offerId,
  }) async {
    return mockedDetailedOffer();
  }
}

class  DetailedOfferRepositoryFailureStub extends DetailedOfferRepository {
  DetailedOfferRepositoryFailureStub() : super("");

  @override
  Future<DetailedOffer?> getDetailedOffer({
    required String offerId,
  }) async {
    return null;
  }
}