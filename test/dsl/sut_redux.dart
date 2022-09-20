import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

class StateIs<T> extends Matcher {
  final dynamic Function(AppState) property;
  final Function(T)? moreExpectations;

  StateIs(this.property, [this.moreExpectations]);

  @override
  bool matches(Object? item, Map matchState) {
    if (item == null || item is! AppState) return false;
    final subState = property(item);
    if (subState is T) {
      if (moreExpectations != null) moreExpectations!(subState);
      return true;
    }
    return false;
  }

  @override
  Description describe(Description description) => description.add("state isn't");
}

class StateMatch extends Matcher {
  final bool Function(AppState) statePredicate;
  final Function(AppState)? moreExpectations;

  StateMatch(this.statePredicate, [this.moreExpectations]);

  @override
  bool matches(Object? item, Map matchState) {
    if (item == null || item is! AppState) return false;
    if (statePredicate(item)) {
      if (moreExpectations != null) moreExpectations!(item);
      return true;
    }
    return false;
  }

  @override
  Description describe(Description description) => description.add("state doesn't match");
}

class DebugMatcher extends Matcher {
  final dynamic Function(AppState) getDebugInfo;

  DebugMatcher(this.getDebugInfo);

  @override
  bool matches(Object? item, Map matchState) {
    if (item == null) {
      print("DebugMatcher: item null");
      return false;
    }
    if (item is! AppState) {
      print("DebugMatcher: item isn't an AppState");
      return false;
    }
    print("DebugMatcher: ${getDebugInfo(item)}");
    return false;
  }

  @override
  Description describe(Description description) => description.add('state debug');
}

// todo : faire du commentaire doc ? faire le contributing ?
// todo : move matchers ?

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
