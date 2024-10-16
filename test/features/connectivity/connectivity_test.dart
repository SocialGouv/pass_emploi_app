import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_state.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Connectivity', () {
    final sut = StoreSut();

    group("when subscribing to connectivity updates", () {
      sut.whenDispatchingAction(() => SubscribeToConnectivityUpdatesAction());

      test('should receive connectivity updates and change state accordingly', () async {
        // Given
        final controller = StreamController<List<ConnectivityResult>>();
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.connectivityWrapper = ConnectivityWrapper(controller.stream)});

        // When
        controller.sink.add([ConnectivityResult.wifi]);

        // Then
        sut.thenExpectChangingStatesThroughOrder([
          _shouldHaveConnectivity([]),
          _shouldHaveConnectivity([ConnectivityResult.wifi]),
        ]);
      });
    });

    group("when subscribing to connectivity updates", () {
      test('should receive connectivity updates and change state accordingly', () async {
        // Given
        final wrapper = MockConnectivityWrapper();
        final store = givenState() //
            .loggedIn()
            .store((f) => {f.connectivityWrapper = wrapper});

        // When
        await store.dispatch(UnsubscribeFromConnectivityUpdatesAction());

        // Then
        verify(() => wrapper.unsubscribeFromUpdates()).called(1);
      });
    });
  });
}

Matcher _shouldHaveConnectivity(List<ConnectivityResult> results) {
  return StateIs<ConnectivityState>(
    (state) => state.connectivityState,
    (state) => expect(state.results, results),
  );
}
