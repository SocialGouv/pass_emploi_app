import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class NextDispatcherSpy {
  bool wasCalled = false;
  late final dynamic _expectedAction;

  NextDispatcherSpy({dynamic expectedAction}) {
    _expectedAction = expectedAction;
  }

  dynamic performAction(dynamic action) {
    expect(action, _expectedAction);
    wasCalled = true;
  }
}

class StoreSpy extends Store<AppState> {
  late Object dispatchedAction;

  StoreSpy() : super(reducer, initialState: AppState.initialState());

  @override
  dispatch(action) => dispatchedAction = action;
}

class SharedPreferencesSpy extends FlutterSecureStorage {
  final Map<String, String> storedValues = Map();

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) {
    storedValues[key] = value!;
    return Future.value(true);
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => storedValues[key];

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    storedValues.remove(key);
  }
}
