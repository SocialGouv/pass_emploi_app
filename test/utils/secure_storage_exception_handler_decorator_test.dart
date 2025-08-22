import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/utils/secure_storage_exception_handler_decorator.dart';

void main() {
  final secureStorage = SecureStorageExceptionHandlerDecorator(_ExceptionThrowerSecureStorage());

  test('write should not propagate exception', () {
    expect(() => secureStorage.write(key: 'key', value: 'value'), returnsNormally);
  });

  test('read should not propagate exception', () {
    expect(() => secureStorage.read(key: 'key'), returnsNormally);
  });

  test('delete should not propagate exception', () {
    expect(() => secureStorage.delete(key: 'key'), returnsNormally);
  });
}

class _ExceptionThrowerSecureStorage extends FlutterSecureStorage {
  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    throw PlatformException(code: 'code');
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    throw PlatformException(code: 'code');
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    throw PlatformException(code: 'code');
  }
}
