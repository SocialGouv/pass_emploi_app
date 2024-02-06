import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class TutorialRepository {
  static const String _keyPrefix = 'tutorialRead-';

  final FlutterSecureStorage _preferences;

  TutorialRepository(this._preferences);

  List<TutorialPage> getMiloTutorial() => Tutorial.milo;

  List<TutorialPage> getPoleEmploiTutorial() => Tutorial.pe;

  Future<void> setTutorialRead() async {
    await _preferences.write(key: '$_keyPrefix${Tutorial.versionTimestamp}', value: 'read');
  }

  Future<bool> shouldShowTutorial() async {
    final keys = (await _preferences.readAll()).keys;
    final firstInstall = keys.firstWhereOrNull((key) => key.startsWith(_keyPrefix)) == null;
    if (firstInstall) return false;

    final String? tutorialRead = await _preferences.read(key: '$_keyPrefix${Tutorial.versionTimestamp}');
    return tutorialRead == null;
  }
}
