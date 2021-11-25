import 'dart:io';

String loadTestAssets(String path) {
  try {
    return File("assets/$path").readAsStringSync();
  } catch (e) {
    return File("test/assets/$path").readAsStringSync();
  }
}

List<int> loadTestAssetsAsBytes(String path) {
  try {
    return File("assets/$path").readAsBytesSync();
  } catch (e) {
    return File("test/assets/$path").readAsBytesSync();
  }
}
