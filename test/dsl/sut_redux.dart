import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

import 'matchers.dart';

class StoreSut {
  late Store<AppState> givenStore;
  late dynamic Function() _whenDispatching;

  void when(dynamic Function() when) {
    setUp(() => _whenDispatching = when);
  }

  void thenExpectChangingStatesThroughOrder(List<Matcher> matchers) {
    expect(givenStore.onChange, emitsInOrder(matchers.map((matcher) => emitsThrough(matcher))));
    givenStore.dispatch(_whenDispatching());
  }

  void debug(dynamic Function(AppState) info) {
    expect(givenStore.onChange, emitsThrough(DebugMatcher(info)));
    givenStore.dispatch(_whenDispatching());
  }
}
