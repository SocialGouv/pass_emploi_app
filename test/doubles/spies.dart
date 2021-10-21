import 'package:flutter_test/flutter_test.dart';

class NextDispatcherSpy {
  bool wasCalled = false;
  late final dynamic _expectedAction;

  NextDispatcherSpy({dynamic expectedAction}) {
    _expectedAction = expectedAction;
  }

  dynamic performAction(dynamic action) {
    expect(_expectedAction, action);
    wasCalled = true;
  }
}