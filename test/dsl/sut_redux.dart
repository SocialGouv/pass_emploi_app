import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

class SUT {
  late Store<AppState> givenStore;
  late dynamic Function() whenDispatching;

  Future<void> thenExpectChangingStatesInOrder(List<Function(AppState)> stateExpectations) async {
    givenStore.prepareExpectInOrder(stateExpectations);
    givenStore.dispatch(whenDispatching());
  }
}

extension _StoreTestExtension on Store<AppState> {
  Future<void> prepareExpectInOrder<S>(List<Function(AppState)> expectations) async {
    var matchers = expectations.map(
      (expectation) => predicate<AppState>((state) {
        expectation(state);
        return true;
      }),
    );

    return expect(onChange, emitsInOrder(matchers));
  }
}
