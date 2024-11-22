import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import 'fixtures.dart';
import 'mocks.dart';

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
  final dispatchedActions = <dynamic>[];
  dynamic dispatchedAction;

  StoreSpy() : super(reducer, initialState: AppState.initialState(configuration: configuration()));

  StoreSpy.withState(AppState appState) : super(reducer, initialState: appState);

  @override
  void dispatch(dynamic action) {
    dispatchedAction = action;
    dispatchedActions.add(action);
  }
}

class FlutterSecureStorageSpy extends FlutterSecureStorage {
  final Duration delay;
  final Map<String, String> _storedValues = {};

  void reset() => _storedValues.clear();

  FlutterSecureStorageSpy({this.delay = const Duration(milliseconds: 10)});

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
  }) async {
    if (delay != Duration.zero) await simulateIoOperation();
    _storedValues[key] = value!;
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
  }) async {
    if (delay != Duration.zero) await simulateIoOperation();
    return _storedValues[key];
  }

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
    if (delay != Duration.zero) await simulateIoOperation();
    _storedValues.remove(key);
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (delay != Duration.zero) await simulateIoOperation();
    return _storedValues;
  }

  Future<void> simulateIoOperation() async => await Future.delayed(delay);
}

class SpyPassEmploiCacheManager extends PassEmploiCacheManager {
  SpyPassEmploiCacheManager() : super(MockCacheStore(), '');

  CachedResource? removeResourceParams;
  bool removeSuggestionsRechercheResourceWasCalled = false;

  @override
  Future<void> removeResource(CachedResource resourceToRemove, String userId) async {
    removeResourceParams = resourceToRemove;
  }

  @override
  Future<void> removeActionCommentaireResource(String actionId) async {}

  @override
  Future<void> removeSuggestionsRechercheResource({required String userId}) async {
    removeSuggestionsRechercheResourceWasCalled = true;
  }

  @override
  Future<void> emptyCache() => Future<void>.value();
}
