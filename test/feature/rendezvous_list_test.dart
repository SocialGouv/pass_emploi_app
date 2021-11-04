import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';

import '../doubles/dummies.dart';
import '../utils/test_setup.dart';

void main() {
  group("rendezvous request action should fetch rendezvous and…", () {
    test("update state with success if repository returns something", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.rendezvousRepository = RendezvousRepositorySuccessStub();
      final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

      final displayedLoading = store.onChange.any((element) => element.rendezvousState is RendezvousLoadingState);
      final successAppState = store.onChange.firstWhere((element) => element.rendezvousState is RendezvousSuccessState);

      // When
      store.dispatch(RequestRendezvousAction("1234"));

      // Then
      expect(await displayedLoading, true);
      final appState = await successAppState;
      expect((appState.rendezvousState as RendezvousSuccessState).rendezvous.length, 1);
      expect((appState.rendezvousState as RendezvousSuccessState).rendezvous[0].date, DateTime(2022));
    });

    test("update state with failure if repository returns nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.rendezvousRepository = RendezvousRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

      final displayedLoading = store.onChange.any((element) => element.rendezvousState is RendezvousLoadingState);
      final failureAppState = store.onChange.firstWhere((element) => element.rendezvousState is RendezvousFailureState);

      // When
      store.dispatch(RequestRendezvousAction("1234"));

      // Then
      expect(await displayedLoading, true);
      final appState = await failureAppState;
      expect(appState.rendezvousState is RendezvousFailureState, true);
    });
  });
}

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  RendezvousRepositorySuccessStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    return [Rendezvous(id: '', date: DateTime(2022), title: '', subtitle: '', comment: '', duration: '', modality: '')];
  }
}

class RendezvousRepositoryFailureStub extends RendezvousRepository {
  RendezvousRepositoryFailureStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<Rendezvous>?> getRendezvous(String userId) async => null;
}
