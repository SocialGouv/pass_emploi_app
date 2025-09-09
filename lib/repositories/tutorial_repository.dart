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
    if (await _isFirstInstall()) {
      await setTutorialRead();
      return false;
    }

    return await _isTutorialNotRead(Tutorial.versionTimestamp);
  }

  Future<bool> _isFirstInstall() async {
    final keys = (await _preferences.readAll()).keys;
    return keys.firstWhereOrNull((key) => key.startsWith(_keyPrefix)) == null;
  }

  Future<bool> _isTutorialNotRead(String version) async {
    final String? tutorialRead = await _preferences.read(key: '$_keyPrefix$version');
    return tutorialRead == null;
  }

  Future<bool> shouldShowFtIaTutorial() async {
    if (await _isFirstInstall()) {
      await setTutorialRead();
      return false;
    }

    return await _isTutorialNotRead(Tutorial.ftIaTutorialVersionTimestamp);
  }

  Future<void> setFtIaTutorialSeen() async {
    await _preferences.write(key: '$_keyPrefix${Tutorial.ftIaTutorialVersionTimestamp}', value: 'read');
  }
}
