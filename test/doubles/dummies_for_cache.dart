import 'package:file/src/interface/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/cache_object.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart';

class DummyConfig implements Config {
  @override
  String get cacheKey => "test";

  @override
  FileService get fileService => DummyFileService();

  @override
  FileSystem get fileSystem => DummyFileSystem();

  @override
  int get maxNrOfCacheObjects => 1;

  @override
  CacheInfoRepository get repo => DummyCacheInfoRepository();

  @override
  Duration get stalePeriod => Duration(days: 1);
}

class DummyFileService extends FileService {
  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }
}

class DummyCacheInfoRepository extends CacheInfoRepository {
  @override
  Future<bool> close() {
    throw UnimplementedError();
  }

  @override
  Future<int> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> deleteAll(Iterable<int> ids) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDataFile() {
    throw UnimplementedError();
  }

  @override
  Future<bool> exists() {
    throw UnimplementedError();
  }

  @override
  Future<CacheObject?> get(String key) {
    throw UnimplementedError();
  }

  @override
  Future<List<CacheObject>> getAllObjects() {
    throw UnimplementedError();
  }

  @override
  Future<List<CacheObject>> getObjectsOverCapacity(int capacity) {
    throw UnimplementedError();
  }

  @override
  Future<List<CacheObject>> getOldObjects(Duration maxAge) {
    throw UnimplementedError();
  }

  @override
  Future<CacheObject> insert(CacheObject cacheObject, {bool setTouchedToNow = true}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> open() async {
    return false;
  }

  @override
  Future<int> update(CacheObject cacheObject, {bool setTouchedToNow = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateOrInsert(CacheObject cacheObject) {
    throw UnimplementedError();
  }
}

class DummyFileSystem extends FileSystem {
  @override
  Future<File> createFile(String name) {
    throw UnimplementedError();
  }
}
