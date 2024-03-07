import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

import '../utils/stream_matcher_helpers.dart';
import 'matchers.dart';

class StoreSut {
  late Store<AppState> givenStore;
  late Function() _whenFunction;

  /////////////////////////////
  // - When

  void whenDispatchingAction(dynamic Function() when) {
    setUp(() => _whenFunction = () async => await givenStore.dispatch(when()));
  }

  void whenDispatchingActions(List<dynamic> actions) {
    setUp(() {
      _whenFunction = () async {
        for (final action in actions) {
          await givenStore.dispatch(action);
        }
      };
    });
  }

  void when(Function() when) {
    setUp(() => _whenFunction = when);
  }

  /////////////////////////////
  // - Then

  Future<void> thenExpectChangingStatesThroughOrder(List<Matcher> matchers) async {
    expect(givenStore.onChange, emitsInOrder(matchers.map((matcher) => emitsThrough(matcher))));
    await _whenFunction();
  }

  Future<void> thenExpectAtSomePoint(Matcher matcher) async {
    Future.delayed(Duration(milliseconds: 50), () => givenStore.teardown());
    expect(givenStore.onChange, emitsAtLeastOnce(matcher));
    await _whenFunction();
  }

  Future<void> thenExpectNever(Matcher matcher) async {
    Future.delayed(Duration(milliseconds: 50), () => givenStore.teardown());
    expect(givenStore.onChange, neverEmits(matcher));
    await _whenFunction();
  }

  Future<void> thenDebugStates(dynamic Function(AppState) info) async {
    expect(givenStore.onChange, emitsThrough(DebugMatcher(info)));
    await _whenFunction();
  }

  Future<void> then(Function() expect) async {
    await _whenFunction();
    expect();
  }
}
