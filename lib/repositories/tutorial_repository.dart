import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/tutorial_page.dart';

class TutorialRepository {
  final FlutterSecureStorage _preferences;

  TutorialRepository(this._preferences);

  Future<List<TutorialPage>> getMiloTutorial() async {
    return await _shouldShowTutorial() ? TutorialPage.milo.toList() : [];
  }

  Future<List<TutorialPage>> getPoleEmploiTutorial() async {
    return await _shouldShowTutorial() ? TutorialPage.poleEmploi.toList() : [];
  }

  Future<void> setTutorialRead() async {
    await _preferences.write(key: 'tutorialRead-' + TutorialPage.version, value: 'read');
  }

  Future<bool> _shouldShowTutorial() async {
    final String? tutorialRead = await _preferences.read(key: 'tutorialRead-' + TutorialPage.version);
    return tutorialRead == null;
  }
}
