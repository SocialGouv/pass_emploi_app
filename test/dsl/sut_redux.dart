import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

class StoreSut {
  bool _skipFirstChange = false;
  late Store<AppState> givenStore;
  late dynamic Function() _whenDispatching;

  void setSkipFirstChange(bool value) {
    setUp(() => _skipFirstChange = value);
  }

  void when(dynamic Function() when) {
    setUp(() => _whenDispatching = when);
  }

  Future<void> thenExpectChangingStatesInOrder(List<Function(AppState)> stateExpectations) async {
    givenStore.prepareExpectInOrder(expectations: stateExpectations, skipFirstChange: _skipFirstChange);

    givenStore.dispatch(_whenDispatching());
  }
}

extension _StoreTestExtension on Store<AppState> {
  Future<void> prepareExpectInOrder<S>(
      {required List<Function(AppState)> expectations, required bool skipFirstChange}) async {
    final matchers = expectations.map(
      (expectation) => predicate<AppState>((state) {
        expectation(state);
        return true;
      }),
    );

    return expect(_onChange(skipFirstChange: skipFirstChange), emitsInOrder(matchers));
  }

  Stream<AppState> _onChange({required bool skipFirstChange}) {
    if (skipFirstChange) return onChange.skip(1);
    return onChange;
  }
}
