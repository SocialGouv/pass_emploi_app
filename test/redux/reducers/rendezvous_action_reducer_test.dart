import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

main() {
  group("reducer with rendezvous actions modifying rendezvous state", () {
    void assertState(dynamic action, State<List<Rendezvous>> expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.rendezvousState, expectedState);
      });
    }

    assertState(RendezvousLoadingAction(), State<List<Rendezvous>>.loading());
    assertState(RendezvousFailureAction(), State<List<Rendezvous>>.failure());
    assertState(RendezvousSuccessAction([rendezvous]), State<List<Rendezvous>>.success([rendezvous]));
  });
}

final rendezvous =
    Rendezvous(id: '', date: DateTime(2022), title: '', subtitle: '', comment: '', duration: '', modality: '');
