import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';

class SecureStorageInMemoryDecorator extends FlutterSecureStorage {
  final FlutterSecureStorage decorated;
  final Map<String, String> _inMemoryStorage = {};
  final _lock = Lock();

  SecureStorageInMemoryDecorator(this.decorated);

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
    return _lock.synchronized(() async {
      await _initInMemoryStorageIfRequired(iOptions, aOptions, lOptions, webOptions, mOptions, wOptions);
      if (value != null) {
        _inMemoryStorage[key] = value;
      } else {
        _inMemoryStorage.remove(key);
      }
      decorated.write(
        key: key,
        value: value,
        iOptions: iOptions,
        aOptions: aOptions,
        lOptions: lOptions,
        webOptions: webOptions,
        mOptions: mOptions,
        wOptions: wOptions,
      );
    });
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
    return _lock.synchronized(() async {
      await _initInMemoryStorageIfRequired(iOptions, aOptions, lOptions, webOptions, mOptions, wOptions);
      return _inMemoryStorage[key];
    });
  }

  @override
  Future<bool> containsKey(
      {required String key,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions,
      WindowsOptions? wOptions}) async {
    return _lock.synchronized(() async {
      await _initInMemoryStorageIfRequired(iOptions, aOptions, lOptions, webOptions, mOptions, wOptions);
      return _inMemoryStorage.containsKey(key);
    });
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
    return _lock.synchronized(() async {
      await _initInMemoryStorageIfRequired(iOptions, aOptions, lOptions, webOptions, mOptions, wOptions);
      return _inMemoryStorage;
    });
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
    return _lock.synchronized(() async {
      await _initInMemoryStorageIfRequired(iOptions, aOptions, lOptions, webOptions, mOptions, wOptions);
      _inMemoryStorage.remove(key);
      decorated.delete(
        key: key,
        iOptions: iOptions,
        aOptions: aOptions,
        lOptions: lOptions,
        webOptions: webOptions,
        mOptions: mOptions,
        wOptions: wOptions,
      );
    });
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _lock.synchronized(() async {
      _inMemoryStorage.clear();
      decorated.deleteAll(
        iOptions: iOptions,
        aOptions: aOptions,
        lOptions: lOptions,
        webOptions: webOptions,
        mOptions: mOptions,
        wOptions: wOptions,
      );
    });
  }

  Future<void> _initInMemoryStorageIfRequired(
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  ) async {
    if (_inMemoryStorage.isEmpty) {
      _inMemoryStorage.addAll(await decorated.readAll(
        iOptions: iOptions,
        aOptions: aOptions,
        lOptions: lOptions,
        webOptions: webOptions,
        mOptions: mOptions,
        wOptions: wOptions,
      ));
    }
  }
}
