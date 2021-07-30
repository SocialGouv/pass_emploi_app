import 'dart:io';

String loadTestAssets(String path) {
  try {
    return File("assets/$path").readAsStringSync();
  } catch (FileSystemException) {
    return File("test/assets/$path").readAsStringSync();
  }
}
