import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_files.dart';

void throwModeDemoExceptionIfNecessary(bool isGet, Uri uri) {
  if (!kDebugMode) return;
  if (!isGet) return;
  if (!uri.toString().isSupposedToBeMocked()) return;
  if (getDemoFileName(uri.path, uri.query) == null) throw ModeDemoException(uri.toString());
}

class ModeDemoException implements Exception {
  final String _urlToBeMocked;

  ModeDemoException(String urlToBeMocked) : _urlToBeMocked = urlToBeMocked;

  @override
  String toString() {
    return '''
        URL $_urlToBeMocked is supposed to be mocked. 
        Please complete mode_demo_files.dart declare URL as not supposed to be mocked.
      '''
        .trim();
  }
}
