import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_actions.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/models/mon_conseiller_info.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/conseiller_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("should display mon conseiller informations", () async {
    // Given
    final store = _storeWithSuccessFetchingRepositories();
    final newState = store.onChange.firstWhere((element) => element.conseillerState is ConseillerSuccessState);

    // When
    store.dispatch(ConseillerRequestAction());

    // Then
    expect((await newState).conseillerState, ConseillerSuccessState(conseillerInfo: monConseillerInfoPerceval()));
  });

  test("should display loading", () async {
    // Given
    final store = _storeWithSuccessFetchingRepositories();
    final loadingDisplayed = store.onChange.any((element) => element.conseillerState is ConseillerLoadingState);

    // When
    store.dispatch(ConseillerRequestAction());

    // Then
    expect(await loadingDisplayed, true);
  });
}

Store<AppState> _storeWithSuccessFetchingRepositories() {
  final factory = TestStoreFactory();
  final repository = ConseillerRepositorySuccessStub();
  factory.conseillerRepository = repository;
  return factory.initializeReduxStore(initialState: loggedInState());
}

class ConseillerRepositorySuccessStub extends ConseillerRepository {
  ConseillerRepositorySuccessStub() : super('', DummyHttpClient());

  @override
  Future<MonConseillerInfo> fetch() async {
    return monConseillerInfoPerceval();
  }
}
