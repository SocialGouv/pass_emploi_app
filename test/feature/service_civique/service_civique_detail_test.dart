import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("service civique detail should be loaded when asked", () async {
    final factory = TestStoreFactory();
    factory.serviceCiviqueDetailRepository = ServiceCiviqueDetailRepositoryWithDataStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.serviceCiviqueDetailState is ServiceCiviqueDetailLoadingState);
    final successState =
        store.onChange.firstWhere((e) => e.serviceCiviqueDetailState is ServiceCiviqueDetailSuccessState);

    // When
    store.dispatch(GetServiceCiviqueDetailAction("id"));

    // Then
    expect(await displayedLoading, true);

    final successAppState = await successState;
    final dataState = (successAppState.serviceCiviqueDetailState as ServiceCiviqueDetailSuccessState);
    expect(dataState.detail, mockServiceCiviqueDetail());
  });

  test("service civique detail should be error when fail occur", () async {
    final factory = TestStoreFactory();
    factory.serviceCiviqueDetailRepository = ServiceCiviqueDetailRepositoryWithErrorStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.serviceCiviqueDetailState is ServiceCiviqueDetailLoadingState);
    final errorState =
        store.onChange.firstWhere((e) => e.serviceCiviqueDetailState is ServiceCiviqueDetailFailureState);

    // When
    store.dispatch(GetServiceCiviqueDetailAction("id"));

    // Then
    expect(await displayedLoading, true);

    final errorAppState = await errorState;
    expect(errorAppState.serviceCiviqueDetailState, ServiceCiviqueDetailFailureState());
  });
}
