import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class SharedPreferencesSpy implements SharedPreferences {
  final Map<String, String> storedValues = Map();

  @override
  Future<bool> setString(String key, String value) {
    storedValues[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> clear() => throw UnimplementedError();

  @override
  Future<bool> commit() => throw UnimplementedError();

  @override
  bool containsKey(String key) => storedValues.containsKey(key);

  @override
  Object? get(String key) => throw UnimplementedError();

  @override
  bool? getBool(String key) => throw UnimplementedError();

  @override
  double? getDouble(String key) => throw UnimplementedError();

  @override
  int? getInt(String key) => throw UnimplementedError();

  @override
  Set<String> getKeys() => throw UnimplementedError();

  @override
  String? getString(String key) => storedValues[key];

  @override
  List<String>? getStringList(String key) => throw UnimplementedError();

  @override
  Future<void> reload() => throw UnimplementedError();

  @override
  Future<bool> remove(String key) async {
    storedValues.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) => throw UnimplementedError();

  @override
  Future<bool> setDouble(String key, double value) => throw UnimplementedError();

  @override
  Future<bool> setInt(String key, int value) => throw UnimplementedError();

  @override
  Future<bool> setStringList(String key, List<String> value) => throw UnimplementedError();
}
